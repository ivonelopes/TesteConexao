#include "hbclass.ch"

CREATE CLASS conexao

	VAR oCnn INIT {}
//msginfo( inicSErve, inicRoot )	
	//Conecção pegando do arquivo .ini
	DATA cTabela INIT ""
    DATA cServe INIT inicServe 			//"192.168.200.200" //"localhost"
    DATA cRoot INIT inicRoot			//"root"
    DATA cPass INIT inicPass			//"160676"
    DATA cPorta INIT inicPorta			//"3307"
    DATA cDataBase INIT inicDataBase	//"ivonels01"
	
	

    // Para conecão Local
	/*
	DATA cTabela INIT ""
    DATA cServe INIT "192.168.200.200" //"localhost"
    DATA cRoot INIT "root"
    DATA cPass INIT "160676"
    DATA cPorta INIT "3307"
    DATA cDataBase INIT "ivonels01"
	*/
	// Para conexão remota com Base ivonels (KingHost )- Testes 
	/*
	DATA cTabela INIT ""
	DATA cServe INIT "mysql.ivonels.com.br"
	DATA cRoot INIT "ivonels"
	DATA cPass INIT "dbRo160676"
	DATA cPorta INIT "3306"
    DATA cDataBase INIT "ivonels" 
*/
	
	// Para conexão remota com Base ivonels01 (KIngHost ) - Cobrinha
	/*
	DATA cTabela INIT ""
	DATA cServe INIT "mysql.ivonels.com.br"
	DATA cRoot INIT "ivonels01"
	DATA cPass INIT "dbRo160676"
	DATA cPorta INIT "3306"
    DATA cDataBase INIT "ivonels01" 
    */
	
/* teste Azure - mão funcionou
//vm-teste-maq-4-vnet/default   
DATA cServe INIT "20.226.111.147"
DATA cRoot INIT "AdminTeste-maq-4"
DATA cPass INIT "Rodrigo@160676"
DATA cPorta INIT "3389"
DATA cDataBase INIT ""
*/

/*
      cServe :="mysql.ivonels.com.br"
      cRoot := "ivonels"
      cPass := "dbRo160676"
      cPorta := ""
 */   
    METHOD conexaoMariaDB()
    METHOD conexaoBanco()
    METHOD closeConnection()
    //METHOD criaDataBase()
    //METHOD apagaDataBase()
    //METHOD criaTable()
    //METHOD apagaTable()
    //METHOD insereDAdos()
    //METHOD editaDados()
    //METHOD apagaDados()

END CLASS        
//-------------------------------------------------------------------
METHOD conexaoMariaDB CLASS conexao
LOCAL cString := ""
//LOCAL cServe, cRoot, cPass, cPorta, cString:=""

msginfo("conect Maria DB")
/*
      cServe :="localhost"
      cRoot := "root"
      cPass := "160676"
      cPorta := "3307"
*/
  
      oCnn:=Win_OleCreateObject("ADODB.Connection")
      
      cString:="DRIVER={MariaDB ODBC 3.1 Driver};"
      cString+="SERVER="+::cServe     // Servidor
      cString+=";PORT="+::cPorta      // Porta 
      cString+=";UID="+::cRoot        // Usuario
      cString+=";PASSWORD="+::cPass   // Senha 
      cString+=";OPTION=3;"

      BEGIN SEQUENCE WITH __BreakBlock() 
         oCnn:Open( cString ) 
      ENDSEQUENCE 
   
      //oCnn:Open(cString)
      //alert( oCnn:State())
      msginfo(oCnn:State())
	  
	  //cString:="SELECT * FROM minhaTabela"

      //oQuery := oCnn:Execute( cString )
        //msginfo(oQuery:Fields("codigo"):value, "to no edita")
      //  msginfo(oQuery:Fields("nome"):value, "to no edita")

      // esse tem que tirar o fechamento da conexao é feito por outro modulo
      conexao():CloseConnection()
   

return Self 
//-------------------------------------------------------------------
METHOD conexaoBanco CLASS conexao
LOCAL cString := ""
    //LOCAL cServe, cRoot, cPass, cPorta, cString:=""
    
// msginfo("conect Banco")
    /*
          cServe :="localhost"
          cRoot := "root"
          cPass := "160676"
          cPorta := "3307"
    */
          


          oCnn:=Win_OleCreateObject("ADODB.Connection")
          
          cString:="DRIVER={MariaDB ODBC 3.1 Driver};"
	      //cString:="DRIVER={MySQL ODBC 3.51 Driver};"
          cString+="SERVER="+::cServe     // Servidor
          cString+=";PORT="+::cPorta      // Porta 
          cString+=";DATABASE="+::cDataBase // Banco
          cString+=";UID="+::cRoot        // Usuario
          cString+=";PASSWORD="+::cPass   // Senha 
          cString+=";OPTION=3;"

		  oCnn:CursorLocation    := 3 // AD_USE_CLIENT
		  oCnn:CommandTimeOut    := 300 // seconds
		  oCnn:ConnectionTimeOut := 300 // seconds 
//  nConnection := RDDINFO( RDDI_CONNECT, { "ODBC", "Server=localhost;Driver={MySQL ODBC 5.1 Driver};dsn=;User=test;database=test;" } )
   
          BEGIN SEQUENCE WITH __BreakBlock() 
             oCnn:Open( cString ) 
          ENDSEQUENCE 
// msginfo("Dados do Servidor" )      
          //oCnn:Open(cString)
          //alert( oCnn:State())
if oCnn:State() != 1
	msginfo( "não Conectou" )
else
//msginfo(oCnn:State(), "aqui")
endif
          // esse tem que tirar o fechamento da conexao é feito por outro modulo
          //TtratarDados():CloseConnection()
       
    
    return Self 
//-------------------------------------------------------------------
METHOD CloseConnection() CLASS conexao

  //msginfo( ::oCnn:State() , "no closeConnection")
   //::CloseRecordset()
    BEGIN SEQUENCE WITH __BreakBlock()
       oCnn:Close()
    ENDSEQUENCE
   // msginfo( ::oCnn:State() , "no closeConnection_1")
 
 return nil
 //------------------------------------------------------------------



