#include 'minigui.ch'
#include 'adodb.ch'

function main()

	// Definição de variaveis públicas
	public cTitulo    	:= "Sistema Gerenciador de Plano Funerário "
    public oCnn 		:= NIL				// Objeto Conexão

	// cores
	public AzulEscuro	:= {  48 ,  99 , 137 }
    public AzulClaro	:= { 189 , 219 , 240 }
	public Cinza		:= { 173, 173, 173 }

	// Publicas para Arquivo .INI
	public pcFileIni := GetStartupFolder() + "\testeConexao.ini"

	public inicServe 	:= "mysql.ivonels.com.br"//:= "localhost"
	public inicRoot  	:= "ivonels" //:= "root"
	public inicPass 	:= "dbRo160676"//:= "160676"
	public inicPorta 	:= "3306"//:= "3307"
	public inicDataBase := "ivonels" //:= "test"

	// Define o CodePage - Estou bem confusa ainda
	REQUEST HB_CODEPAGE_PTISO 
	REQUEST HB_LANG_PT
	//REQUEST HB_CODEPAGE_PT850  // não sei qual usar
	HB_LANGSELECT("PT")

 	// Testar para ver se esse fontname faz diferença
	DEFINE FONT font_0 FONTNAME 'Segoe UI' SIZE 9 DEFAULT

	// Define o ambiente
	Set deleted On
	Set Date Brit
	Set Century ON
	Set Epoch to 1950
	Set Navigation Extended
//	Set multiple off warning // abrir 1 cópia somente
	SET TOOLTIPBALLOON ON
	
	// Array com os estados 
    estado := {"RO","AC","AM","RR","PA","AP","TO","MA","PI","CE","RN","PB","PE","AL","SE","BA","MG","ES","RJ","SP","PR","SC","RS","MT","MS","GO","DF"}
    asort(estado)

	// Estados e os respectivos códigos
    est1:={ {"RO","11"},;   
            {"AC","12"},;   
            {"AM","13"},;   
            {"RR","14"},;   
            {"PA","15"},;   
            {"AP","16"},;   
            {"TO","17"},;
		    {"MA","21"},;
            {"PI","22"},;
            {"CE","23"},;
            {"RN","24"},;
            {"PB","25"},;
            {"PE","26"},;
            {"AL","27"},;
            {"SE","28"},;
            {"BA","29"},;
            {"MG","31"},;
            {"ES","32"},;
            {"RJ","33"},;
            {"SP","35"},;
            {"PR","41"},;
            {"SC","42"},;
            {"RS","43"},;
            {"MS","50"},;
            {"MT","51"},;
            {"GO","52"},;
            {"DF","53"}}

	aSort( est1,,, { |x,y| x[1] < y[1]  } )  // ordena o primeiro elemento
	if Hb_fileExists("Checkres.txt")
		fErase( 'Checkres.txt' )
	endif
	//verifica se existe aquele arquivo criado pela tbrowse que eu não sei o que é

	// Verifica se o executável que gera o arquivo de autorização está na máquina ainda.	  
	if Hb_fileExists("GeraControle.exe")
		fErase("GeraControle.exe")
	else
		// Verifica se a maquina usada está autorizada e se a data está dento do perídodo autorizado	  	
		//verificaBasicos()
		// verifica Arquivo .ini - 
		if ! file( "testeConexao.ini" )
			// lê o arquivo .ini
			iniLe()
			//cadParam()
		else
		//msginfo( netName() )
			iniLe()
			//msginfo( inicTpImp )
		endif		
		verificaConexao()
	endif   

	var = .t.
	while var
		DEFINE WINDOW oWnd AT h(0), w(0) WIDTH GetDeskTopWidth(); //w(900);
        HEIGHT GetDeskTopHeight() -h(30);//h(550);
		TITLE cTitulo ;
		ICON "huck" ;
		MAIN ;
		BACKCOLOR AzulEscuro //;
		//ON INIT BuscaIni()
		//ON RELEASE ReleaseAllResources( 'oWnd') ;
		//ON INIT BuscaIni()
		
			DEFINE MAIN MENU  
				POPUP 'Teste'
					ITEM 'Testa Conexão' ACTION buscaIni()
				END POPUP
			END MENU
		END WINDOW
		oWnd.Center
        oWnd.activate
		
	end

return nil
//-----------------------------------------------------------------------------
function verificaConexao()

   if empty( oCnn ) 

//msginfo("Antes da Conexão" )
	  oCnn := conexao():new()
      oCnn:conexaoBanco()
msginfo("Depois da Conexão", str( oCnn:State(), 1 ))

    else
	   // ver as opções
	endif
	
	// OBSERVAÇÃO: LEMBRAR DE DESCONECTAR NA SAIDA DO SISTEMA

return nil
//------------------------------------------------
function conexaoSair()

	if ! empty( oCnn )
	   oCnn := conexao():new()
       oCnn:closeConnection()	
	endif
return nil
// ----------------------------------------------------------------
// Função que libera todos os recursos GDI de todos os controles
// ----------------------------------------------------------------
FUNCTION ReleaseAllResources(oWnd)
    LOCAL oCtrl

    // Finaliza edição de browse, se houver
    IF oBrw != NIL
	//msgInfo('entrei')
        //oBrw:EndEdit()
        oBrw:End()
        oBrw:Destroy()
        oBrw := NIL
    ENDIF

    // Varre todos os controles da janela
	/*
    FOR EACH oCtrl IN oWnd:aControls
        // Se o controle tiver método :Destroy(), chama
        IF HB_ISOBJECT(oCtrl) .AND. __objHasMethod(oCtrl, "Destroy")
            oCtrl:Destroy()
        ENDIF
        // Se tiver método :End(), chama também
        IF HB_ISOBJECT(oCtrl) .AND. __objHasMethod(oCtrl, "End")
            oCtrl:End()
        ENDIF
    NEXT
	*/
return nil
//-------------------------------------------------------------------
function iniLe()

	if !file( pcFileIni)
		iniSalva()
	endif
   
	BEGIN INI FILE pcFileIni
//		GET inicTpImp SECTION "Impressora Autentificação" ENTRY "Tipo de Impressao" 
//		GET inicPrinter SECTION "Impressora Autentificação" ENTRY "Nome da Impressora" 
//		GET inicPrinter1 SECTION "Impressora Autentificação" ENTRY  "Nome da Impressora1"

//		GET inicApa SECTION "Caminhos" ENTRY "Caminho Aparelhos"
//		GET inicConve SECTION "Caminhos" ENTRY "Caminho Convenio"
		GET inicServe SECTION "SERVER" ENTRY "hostname"
		GET inicRoot SECTION "SERVER" ENTRY "username"
		GET inicPass SECTION 'SERVER' ENTRY 'password'
		GET inicPorta SECTION 'SERVER' ENTRY 'port'
		GET inicDataBase SECTION 'SERVER' ENTRY 'database'
//msginfo( inicServe )		
	  //GET inicPrinter SECTION "Impressora Autentificação" ENTRY "Nome da Impressora" 
	  //GET inicCobri SECTION "Caminhos" ENTRY "Caminho Cobri"
	  //GET inicEdit SECTION "Instruções" ENTRY "Instruções Boleto"
	END INI

return nil
//---------------------------------------------------------------------------
function iniSalva()

	BEGIN INI FILE pcFileIni
//		SET SECTION "Impressora Autentificação" ENTRY "Tipo de Impressao"  TO  InicTpImp
//		SET SECTION "Impressora Autentificação" ENTRY "Nome da Impressora" TO inicPrinter
//		SET SECTION "Impressora Autentificação" ENTRY "Nome da Impressora1" TO inicPrinter1

//		SET SECTION "Caminhos" ENTRY "Caminho Aparelhos" TO inicApa 
//		SET SECTION "Caminhos" ENTRY "Caminho Convenio" TO inicConve 
		//SET SECTION "Impressora Autentificação" ENTRY "Nome da Impressora"  TO inicPrinter
		// SET SECTION "Caminhos" ENTRY "Caminho Cobri" TO inicCobri 
		// SET SECTION "Instruções" ENTRY "Instruções Boleto" TO inicEdit
		SET SECTION 'SERVER' ENTRY 'hostname' TO inicServe
		SET SECTION 'SERVER' ENTRY 'username' TO inicRoot
		SET SECTION 'SERVER' ENTRY 'password' TO inicPass
		SET SECTION 'SERVER' ENTRY 'port' TO inicPorta
		SET SECTION 'SERVER' ENTRY 'database' TO inicDataBase
	END INI

return nil
//--------------------------------------------------------------
static function buscaIni()

//	msginfo( inicPrinter, inicPrinter1 )
//LOCAL nompath, nomapa, nomconve, patht, pathapa, pathconve

/*
   // verifica Arquivo .ini - incluido 02/11/21
   if ! file( "planoNovo.ini" )
      // lê o arquivo .ini
  	  iniLe()
      //cadParam()
   else
      iniLe()
	  //msginfo( inicTpImp )
   endif
 */ 
    // Acessa arquivos .DBF do Programa antigo 
   configuraConect()
   //abrearq() 
   
 return nil
//-----------------------------------------------------------------------------
function configuraConect()


  DEFINE WINDOW telaconfig AT h(100), w(100) WIDTH w(400) HEIGHT h(400) ;
     TITLE "Dados Para Conexão Ao Banco de Dados MariaDB " ;
	 MODAL //;
	 //ON INIT configOnInit()
  
     @ h(010), w(10) FRAME frame_1 CAPTION "HostName" WIDTH 200 HEIGHT 50 OPAQUE
     @ h(028), w(20) TEXTBOX cServe WIDTH 180 HEIGHT 20 VALUE inicServe  
  
     @ h(070), w(10) FRAME frame_2 CAPTION "UserName" WIDTH 200 HEIGHT 50 OPAQUE
     @ h(088), w(20) TEXTBOX cRoot WIDTH 180 HEIGHT 20 VALUE inicRoot 
  
     @ h(130), w(10) FRAME frame_3 CAPTION "PassWord" WIDTH 200 HEIGHT 50 OPAQUE
     @ h(148), w(20) TEXTBOX cPass WIDTH 180 HEIGHT 20 VALUE inicPass
  
     @ h(190), w(10) FRAME frame_4 CAPTION "Porta" WIDTH 200 HEIGHT 50 OPAQUE
     @ h(208), w(20) TEXTBOX cPorta WIDTH 180 HEIGHT 20 VALUE inicPorta 
  
     @ h(250), w(10) FRAME frame_5 CAPTION "DataBase" WIDTH 200 HEIGHT 50 OPAQUE
     @ h(268), w(20) TEXTBOX cDataBase WIDTH 180 HEIGHT 20 VALUE inicDataBase 
	 
	 @ h(300), w(010) BUTTON ignorar CAPTION "Ignorar" ACTION ignorar()
	 
	 @ h(300), w(120) BUTTON salvar CAPTION "Salvar" ACTION salvar( 'telaconfig' )
	 
	 @ h(300), w(230) BUTTON testar CAPTION 'Testar' ACTION verificaConexao()

	 @ h(300), w(340) BUTTON sair CAPTION "Sair" ACTION doMethod( 'telaconfig', 'release' )
  
  END WINDOW
  telaConfig. Activate 
return nil
//------------------------------------------------------------------
static function salvar( tela )

	inicServe 	:= getProperty( tela, 'cServe', 'value' ) 
	inicRoot	:= getProperty( tela, 'cRoot', 'value' )
	inicPass	:= getProperty( tela, 'cPass', 'value' )
	inicPorta 	:= getProperty( tela, 'cPorta', 'value' )
	inicDataBase:= getProperty( tela, 'cDataBase', 'value' )
	// Salva 
	iniSalva()
	
return nil
//---------------------------------------------------------------------
static function ignorar()

   doMethod( "telaConfig", "release" ) 

return nil
//-----------------------------------------------------------------------
