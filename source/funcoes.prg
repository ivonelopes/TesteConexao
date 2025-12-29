#include "minigui.ch"

// Usado no cobrinha

function W(tamanho)  // calcula a proporção da tela - largura
LOCAL x := getDeskTopWidth()

return (tamanho/800) * x
//------------------------------------------------------------------
function H(tamanho)  // calcula a proporção da tela - altura
LOCAL x := GetDeskTopHeight()

return (tamanho/600) * x
//---------------------------------------------------------------
/*

Function w(tamanho)   // Calcula o proporcao da tela pra objetos
LOCAL x:=1024    // 1366 no meu
//   LOCAL x:=800 
//   LOCAL x:=GetDesktopWidth()

return (tamanho/800)*x
//--------------------------------------------------------------
Function h(tamanho)  // Calcula o proporcao da tela pra objetos
LOCAL x:=768 	// 768 no meu também
//  LOCAL x:=600
//   LOCAL x:=GetDesktopHeight()

return (tamanho/600)*x
//---------------------------------------------------------------
*/
Function NumSerHd()   // Verifica o numero de serie do HD
LOCAL NumHd:="", tam:=0

   NumHd:=str(volSerial())
   NumHD:=subs(NumHd,2,8)
   if len(NumHd)<8
      Numhd:=strZero(val(NumHd),8)
   Endif

return numHd
//------------------------------------------------------------------
function sair( tela )

   var := .f.
   doMethod( tela, "release")

return nil 
//-----------------------------------------------------------------
FUNCTION DateSql( dDate )

   LOCAL cString

   IF Empty( dDate )
      cString := "NULL"
   ELSE
      cString := ['] + Transform( Dtos( dDate ), "@R 9999-99-99" ) + [']
   ENDIF

   RETURN cString
//---------------------------------------------------------------------
function DateTimeSql( dDate, ctime  )
LOCAL cString

	if empty( dDate ) .or. empty( cTime )
		cString := 'NULL'
	else
		cString := ['] + Transform( Dtos( dDate ), "@R 9999-99-99" ) + ' ' + cTime + [']
	endif
	
return cString 
//---------------------------------------------------------------------
FUNCTION SoNumeros( cTxt )

   LOCAL cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      ENDIF
   NEXT

   RETURN cSoNumeros
//------------------------------------------------------------
FUNCTION StringSql( cString )
   	 
   cString := Trim( cString )
   cString := StrTran( cString, [\], [\\] )
   cString := StrTran( cString, ['], [\'] )
   cString := StrTran( cString, Chr(13), "\" + Chr(13) )
   cString := StrTran( cString, Chr(10), "\" + Chr(10) )
   cString := ['] + cString + [']
   
RETURN cString
//-------------------------------------------------------------
FUNCTION XmlNode( cXml, cNode, lComTag )

   LOCAL nInicio, nFim, cResultado := ""

   hb_Default( @lComTag, .F. )
   nInicio := At( "<" + cNode, cXml )
   // a linha abaixo ? depois de pegar o in?cio, sen?o falha
   IF " " $ cNode
      cNode := Substr( cNode, 1, At( " ", cNode ) - 1 )
   ENDIF
   IF nInicio != 0
      IF ! lComTag
         nInicio := nInicio + Len( cNode ) + 2
         IF nInicio != 1 .AND. Substr( cXml, nInicio - 1, 1 ) != ">" // Quando tem elementos no bloco
            nInicio := hb_At( ">", cXml, nInicio ) + 1
         ENDIF
      ENDIF
      nFim := hb_At( "</" + cNode + ">", cXml, nInicio )
      IF nFim != 0
         nFim -=1
         IF lComTag
            nFim := nFim + Len( cNode ) + 3
         ENDIF
         cResultado := Substr( cXml, nInicio, nFim - nInicio + 1 )
      ENDIF
   ENDIF

   RETURN cResultado
//---------------------------------------------------------------------
function diaSemana( dDt ) 
LOCAL aDias, cRetorno 

	if ! empty( dDt )
		aDias := { "Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado" }
		cRetorno := aDias[ Dow( dDt ) ]  // Exibe o nome do dia da semana
	endif
return cRetorno
//-----------------------------------------------------------------
function Valida_cpf( cpft )
LOCAL acumula, num, nChar


   * Calcula o 1 digito
   ncpf =subs( cpft, 1, 9)
   conta=10
   n=1
   acumula=0
   
   Do while conta>1
      num = val(subs(ncpf, n, 1 ) ) //val(subs(ncpf,n,1))
	  //msginfo( val(subs(ncpf, n, 1 ) ) )
      acumula=acumula+(num*conta)
      n=n+1
      conta=conta-1
   Enddo
   
   /*
	conta := 9
	for each nChar IN nCpf
		acumula += val( nChar ) * conta
		conta--
	next
	*/
	//msginfo( acumula )

   resto=mod(acumula,11)
   //msginfo( resto )
   if resto<2
      dig1=0
   else
      dig1=11-resto
   endif

   * Calcula o 2 digito
   ncpf=subs(cpft,1,9)+str(dig1,1)
   conta=11
   n=1
   acumula=0
   Do while conta>1
      num=val(subs(ncpf,n,1))
      acumula=acumula+(num*conta)
      n=n+1
      conta=conta-1
   Enddo
   resto=mod(acumula,11)
   if resto<2
      dig2=0
   else
      dig2=11-resto
   endif
   digver=str(dig1,1)+str(dig2,1)
//   msginfo(digver)

return(digver)
//------------------------------------------------------------------
Function Valida_cnpj(cnpjt)
LOCAL ncnpjt, conta, numcal, acumula, resto, dig1, dig2, digver, num

   ncnpjt:=subs(cnpjt,1,12)
   // Calcula 1º Digito
   conta:=12     // variavel q controla a repetição - loop
   numcal:=2     // variavel para multiplicação
   acumula:=0    // acumula os valores da multiplicação
   do While conta>=1
      num=val(subs(ncnpjt,conta,1))
	  acumula=acumUla+(num*numcal)
	  numcal=numcal+1
	  if numcal>9
	     numcal=2
	  endif
	  conta=conta-1
   enddo
   resto:=mod(acumula,11)
   if resto<2
      dig1:=0
   else
      dig1:=11-resto
   endif
   
   // Calcula o 2º Digito Verificador
   ncnpjt:=ncnpjt+str(dig1,1)
       
   conta:=13     // variavel q controla a repetição - loop
   numcal:=2     // variavel para multiplicação
   acumula:=0    // acumula os valores da multiplicação
   do While conta>=1
      num=val(subs(ncnpjt,conta,1))
	  acumula=acumUla+(num*numcal)
	  numcal=numcal+1
	  if numcal>9
	     numcal=2
	  endif
	  conta=conta-1
   enddo
   resto:=mod(acumula,11)
   if resto<2
      dig2:=0
   else
      dig2:=11-resto
   endif
   digver:=str(dig1,1)+str(dig2,1)
return(digver)
//-----------------------------------------------------------
function ajustaNumeroTelefone( cfone )
LOCAL nTam, nEspac, cMostraNumero, cChar, nCont

	nTam := len( cFone ) 
	
	if nTam == 9
	   cMostraNumero := transform( cfone, "@R 99999-9999" )
	else
		nEspac := 9 - nTam
		cMostraNumero:= ""
		ncont := 0
		for each cChar IN cfone //DESCEND
			ncont ++
			if nCont == 5
			   cMostraNumero += "-"
			endif
			cMostraNumero += cChar
		next
	
	endif

return cMostraNumero
//--------------------------------------------------------------
/*
function AjustaRg( cRG )
LOCAL cDig, nTam, cMostraRg

msginfo( right( cRg, 1 ) )
	if right( cRG, 1 ) == 'A'
		cDig := " "
	else
		cDig := Right( cRg, 1 ) 
	endif

	nTam := len( cRg ) - 1
	
	cRg := subs( cRg, 1, nTam ) 
	
	msginfo( cRg, 'rg para mostrar' )
	
	
msginfo( cDig, 'digito'  )	
	cMostraRg := transform( cRg + cDig, '@R !!.999.999-!' )

msginfo( cMostraRg, 'cMostraRg' )

return cMostraRG
*/
//-------------------------------------------------------------
function buscaCep( cCep )
LOCAL oWebService, oXmlDoc, cUrl, cBuffer, lSuccess 
LOCAL cuf, cCid, cBai, cLog, cRua, aRet, cResp, cXml 

	// faltou verificar se tem conex?o com internet

	//cUrl :=  "http://cep.republicavirtual.com.br/web_cep.php?cep='" + cCep + "'&formato=xml"

	cUrl := 'https://viacep.com.br/ws/' +cCep+'/xml/'
	//cUrl := 'https://viacep.com.br/ws/' + cCep + '/json/' //JSON
	
	// basilapi.com.br - só retorna json
	//cUrl  := "https://brasilapi.com.br/api/cep/v1/" + cCep
	
	//oWebService := win_oleCreateObject("MSXML2.XMLHTTP")
	//oXMLDoc := win_oleCreateObject("Microsoft.XMLDOM")
	//oXmlDoc:async := .t.

	//oWebService := CreateObject("Microsoft.XMLHTTP" )     pode ser esse ou
	oWebService := win_oleCreateObject("Microsoft.XMLHTTP")   // esse
	oWebService:Open("GET", cUrl, .F. )
	oWebService:Send()

	//cBuffer := oWebService:responseXml
	cBuffer := oWebService:responseBody
	cResp := xmlNode( cBuffer, 'erro' )
	//msginfo( cBuffer, cResp  )

	if cResp == 'true'
		cUrl  := "https://brasilapi.com.br/api/cep/v1/" + cCep
		oWebService := win_oleCreateObject("Microsoft.XMLHTTP")   // esse
		oWebService:Open("GET", cUrl, .F. )
		oWebService:Send()

		//cBuffer := oWebService:responseXml
		cBuffer := oWebService:responseBody
		cResp := cBuffer 
		if ! empty( cResp )
			cREsp := hb_jsonDecode( cResp )
			
			if valtype( cResp ) == 'H' .AND. hb_HHasKey( cResp, "street" )
			    //msginfo( "BrasilAPI (JSON) OK ->", cResp[ "street" ], "-", cResp[ "neighborhood" ], "-", cResp[ "city" ], "-", cResp[ "state" ] ))

				//msginfo( cBuffer, cResp  )
				
				cXml := '<?xml version="1.0" encoding= "UTF-8"? > '
				cXml += '<xmlcep> '
				cXml += '<cep>' + cResp[ "cep" ] + '</cep>'
				cXml += '<logradouro>' + cResp[ "street" ] + '</logradouro>'
				cXml += '</complemento>'
				cXml += '</unidade>'
				cXml += '<bairro>' + cResp[ "neighborhood" ] + '</bairro>'
				cXml += '<localidade>' + cResp[ "city" ] + '</localidade>'
				cXml += '<uf>' + cResp[ "state" ] + '</uf>'
				cXml += '</estado>'
				cXml += '</regiao>'
				cXml += '</ibge>'
				cXml += '</gia>'
				cXml += '</ddd>'
				cXml += '</siafi>'
				cXml += '</xmlcep>'
				//msginfo( cXml )
				//cBuffer := cXml
			else
				cXml := '<?xml version="1.0" encoding= "UTF-8"? > '
				cXml += '<xmlcep> '
				cXml += '<erro>' + 'true' + '</erro>'
				cXml += '</xmlcep>'

				//msgExclamation( cResp[ 'message' ] )
			endif
			cBuffer := cXml
		endif
		
	endif
/*
  // 2) Se não encontrou, tenta BrasilAPI (JSON)
   cUrl  := "https://brasilapi.com.br/api/cep/v1/" + cCep
   cResp := HttpGet( cUrl )

   IF !Empty( cResp )
      hData := hb_jsonDecode( cResp )
      IF ValType( hData ) == "H" .AND. hb_HHasKey( hData, "street" )
         ? "BrasilAPI (JSON) OK ->", hData[ "street" ], "-", hData[ "neighborhood" ], "-", hData[ "city" ], "-", hData[ "state" ]
         RETURN NIL
      ENDIF
   ENDIF

   ? "CEP não encontrado em nenhum serviço."	
*/
	//msginfo( cBuffer )
	//lSuccess := oXmlDoc:load( cBuffer )
	/*
	if at("cep inv?lido", cBuffer) > 0 
		msgExclamation("CEP Inv?lido!", "Aten??o")
		return nil 
	endif

	msginfo( cBuffer )
	cUF := xmlNode( cBuffer, "uf")

	cCid := XmlNode( cBuffer, "cidade")
	cBai := XmlNode( cBuffer, "bairro")
	cLog := XmlNode( cBuffer, "tipo_logradouro")
	cRua := XmlNode( cBuffer, "logradouro")
	msginfo( cuf+ cCid+cbai+clog+cRua )
	aRet := { cUf, cCid, cBai, cLog, cRua}
   */
//return aRet
// esse é o xml retornado do viaCep
/*
<xmlcep>
<cep>13871-110</cep>
<logradouro>Rua Dom Duarte Leopoldo e Silva</logradouro>
<complemento/>
<unidade/>
<bairro>Jardim Bela Vista</bairro>
<localidade>São João da Boa Vista</localidade>
<uf>SP</uf>
<estado>São Paulo</estado>
<regiao>Sudeste</regiao>
<ibge>3549102</ibge>
<gia>6397</gia>
<ddd>19</ddd>
<siafi>7083</siafi>
</xmlcep>
*/
return cBuffer
//-------------------------------------------------------------------------
********************* Retira Acentos e Letras de uma String ********************
Function fRetiraAcento(cStr)   // funcao do Malcarli
 cStr:= strtran(cStr, [á], [a]) ; cStr:= strtran(cStr, [à], [a]) ; cStr:= strtran(cStr, [â], [a])
 cStr:= strtran(cStr, [ã], [a]) ; cStr:= strtran(cStr, [Á], [A]) ; cStr:= strtran(cStr, [À], [A])
 cStr:= strtran(cStr, [Â], [A]) ; cStr:= strtran(cStr, [Ã], [A]) ; cStr:= strtran(cStr, [É], [E])
 cStr:= strtran(cStr, [Ê], [E]) ; cStr:= strtran(cStr, [é], [e]) ; cStr:= strtran(cStr, [è], [e])
 cStr:= strtran(cStr, [È], [e]) ; cStr:= strtran(cStr, [ê], [e]) ; cStr:= strtran(cStr, [í], [i])
 cStr:= strtran(cStr, [ì], [i]) ; cStr:= strtran(cStr, [Í], [I]) ; cStr:= strtran(cStr, [Ì], [I])
 cStr:= strtran(cStr, [õ], [o]) ; cStr:= strtran(cStr, [ô], [o]) ; cStr:= strtran(cStr, [ó], [o])
 cStr:= strtran(cStr, [ò], [o]) ; cStr:= strtran(cStr, [ö], [o]) ; cStr:= strtran(cStr, [Ö], [O])
 cStr:= strtran(cStr, [Ò], [O]) ; cStr:= strtran(cStr, [Ó], [O]) ; cStr:= strtran(cStr, [Ô], [O])
 cStr:= strtran(cStr, [Õ], [O]) ; cStr:= strtran(cStr, [ü], [u]) ; cStr:= strtran(cStr, [ú], [u])
 cStr:= strtran(cStr, [ù], [u]) ; cStr:= strtran(cStr, [Ú], [U]) ; cStr:= strtran(cStr, [Ù], [U])
 cStr:= strtran(cStr, [Ü], [U]) ; cStr:= strtran(cStr, [ç], [c]) ; cStr:= strtran(cStr, [Ç], [C])
 cStr:= strtran(cStr, [ÿ], [y]) ; cStr:= strtran(cStr, [ñ], [n]) ; cStr:= strtran(cStr, [Ñ], [N])
 cStr:= strtran(cStr, [º], [o.]) ; cStr:= strtran(cStr, [°], [o.]) ; cStr:= strtran(cStr, [ª], [a.])
 cStr:= strtran(cStr, [´], [ ]); strtran(cStr, [Æ], [a])
Return (cStr)
********************* Fim da Função Retira Acentos e Letras de uma String *******
//-----------------------------------------------------------------------------------
function fatorVencto(datvent)
LOCAL nFatorVen, fator_ven 

	//Fator vencimento a partir de 22/02/2025
	// Código do Quintas 

	nFatorVen   := datvent - Stod( "19971007" )
	DO WHILE nFatorVen > 9999
		nFatorVen -= 9000
	ENDDO
		 
	fator_ven := strzero( nFatorVen, 4 )

return fator_ven
//-----------------------------------------------------------------------------
function Caldvg(nume)

   nnume=0
   soma=0
   n=len(nume)
   control=2
   do while n>0
      nnume=val(subs(nume,n,1))*control
      soma=soma+nnume
      control=control+1
      if control>9
         control=2
      endif
      n=n-1
   enddo
   soma=soma*10       // santander  , mas dá o mesmo valor do soma=11-soma 
   soma=mod(soma,11)
//   soma=11-soma
   if soma=0 .or. soma=1 .or. soma>9
      dvgt="1"
   else
      dvgt=str(soma,1)
   endif

Return(dvgt)
//------------------------------------------------------------------------------------------
Function Caldac(campo)

   nnume=0
   soma=0
   n=len(campo)
   control=1
   do while n>0
      if control=1
         nnume=val(subs(campo,n,1))*2
      endif
      if control=2
         nnume=val(subs(campo,n,1))*1
      endif
      if nnume<10
         soma=soma+nnume
      else
         soma=soma+val(subs(str(nnume,2),1,1))+val(subs(str(nnume,2),2,1))
      endif
      control=control+1
      n=n-1
      if control>2
         control=1
      endif
   enddo
   soma=mod(soma,10)
   if soma>0
      soma=str(10-soma,1)
   else
      soma="0"
   endif

Return(soma)
*--------------------------------------------------------------------
function Calc_Nossonu(nume)

   nnume=0
   soma=0
   n=len(nume)
   control=2
   do while n>0
      nnume=val(subs(nume,n,1))*control
      soma=soma+nnume
      control=control+1
      if control>9
         control=2
      endif
      n=n-1
   enddo
   soma=mod(soma,11)
//   soma=11-soma
   if soma=0 .or. soma=1 .or. soma=10
      if soma=10
	     dvgt="1"
	  endif
	  if soma =0 .or. soma=1
	     dvgt="0"
	  endif
   else
      soma=11-soma
      dvgt=str(soma,1)
   endif
Return(dvgt)
*-----------------------------------------------------------------------
function dataVenc( dData ) 
LOCAL cDia, cMes, cAno, cNovaData

	cDia := '10'
	cMes := strZero( month( dData ) +1 , 2 ) 
	if month( dData ) == 12
		cMes := '01'
		cAno := str( year( dData ) + 1, 4 )
	else
	   cAno := str( year( dData ), 4 ) 
	endif

	cNovaData := cTod( cDia + '/' + cMes + '/' + cAno ) 
	//cTod( '10/' + strzero( month( ::dDatVen ) + 1, 2) + '/' + str( year( ::dDatVen ), 4 ) )


return cNovaData
//-----------------------------------------------------------------
function Ligaimp()

   Set Console Off
   Set Printer to &imp
   Set Printer On
   Set Device To Printer

return nil
//----------------------------------------------------------------
function Desimp()

   Set Printer To
   Set Printer Off
   Set Device to Screen
   Set Console On                  

return nil
//-----------------------------------------------------------------
/*
#include "inkey.ch"

FUNCTION RgValidoSP( cRG )

   LOCAL cDigitoVerificador := ""
   LOCAL cRG_ := ""
   LOCAL nPeso := 2
   LOCAL nSoma := 0
   LOCAL nResto := 0
   LOCAL lRet := .F.
   LOCAL i

   // Remove caracteres não numéricos (pontos, traços, etc.)
   cRG := Alltrim( cRG )
   cRG_ := ""
   FOR i := 1 TO Len( cRG )
      IF IsDigit( Substr( cRG, i, 1 ) )
         cRG_ += Substr( cRG, i, 1 )
      ENDIF
   NEXT
   cRG := cRG_

   // O RG de SP tem 9 dígitos, sendo o último o dígito verificador.
   IF Len( cRG ) != 9
      RETURN .F.
   ENDIF

   // Extrai o dígito verificador, que pode ser o último ou 'X'
   cDigitoVerificador := Upper( Substr( cRG, 9, 1 ) )
   cRG := Substr( cRG, 1, 8 )

   // Realiza a soma ponderada dos 8 primeiros dígitos
   FOR i := 8 TO 1 STEP -1
      nSoma += Val( Substr( cRG, i, 1 ) ) * nPeso
      nPeso++
   NEXT

   // Calcula o resto da divisão por 11
   nResto := nSoma % 11

   // Converte o resto em dígito verificador
   IF nResto == 1
      cDigitoVerificadorCalculado := "X"
   ELSEIF nResto == 0
      cDigitoVerificadorCalculado := "0"
   ELSE
      cDigitoVerificadorCalculado := Alltrim( Str( 11 - nResto ) )
   ENDIF

   // Compara o dígito verificador calculado com o fornecido
   lRet := ( cDigitoVerificador == cDigitoVerificadorCalculado )

   RETURN lRet

// Exemplo de uso
FUNCTION Main()

   LOCAL cRgTeste := "341511255" // RG válido (SP)
   LOCAL cRgTesteInvalido := "123456789" // RG inválido

   IF RgValidoSP( cRgTeste )
      Alert( "RG válido!" )
   ELSE
      Alert( "RG inválido!" )
   ENDIF

   IF RgValidoSP( cRgTesteInvalido )
      Alert( "RG válido!" )
   ELSE
      Alert( "RG inválido!" )
   ENDIF

   RETURN NIL
*/
