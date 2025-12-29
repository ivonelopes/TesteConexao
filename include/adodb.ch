*
* Adodb.CH - Arquivo de Definição de Constantes do Sistema
*
//Tipo do Cursor
#Define adOpenForwardOnly     0  //adOpenForwardOnly = 0 # permite somente que você avance aos registros posteriores,perdendo-se os anteriores
#Define adOpenKeyset          1  //adOpenKeyset      = 1 # leitura e escrita (não permite ver alterações ou exclusões feitas por outros usuários)
#Define adOpenDynamic         2  //adOpenDynamic     = 2 # leitura e escrita (permite ver alterações ou exclusões feitas por outros usuários)
#Define adOpenStatic          3  //adOpenStatic      = 3 # permite somente leitura

//Tipo de travamento de Registros - LockType
#Define adLockReadOnly        1  //adLockReadOnly        = 1 somente leitura
#Define adLockPessimistic     2  //adLockPessimistic     = 2 Impede que outras sessões alterem o registro que estiver alocado pelo usuário
#Define adLockOptimistic      3  //adLockOptimistic      = 3 Todos podem alterar o mesmo registro
#Define adLockBatchOptimistic 4  //adLockBatchOptimistic = 4  Impede que outras sessões quando estiver em modo update batch

//Localização do Cursor - CursorLocation
#Define adUseServer  2
#Define adUseClient  3

//Estados dos RecordSets
#Define adEditNone       0
#Define adEditInProgress 1
#Define adEditAdd        2
#Define adEditDelete     4

//Tipos de dados retornados pelo DB
#Define RS_Empty              0     //Padrao Dbase C
#Define RS_TinyInt           16     //Padrao Dbase N
#Define RS_SmallInt           2     //Padrao Dbase N
#Define RS_integer            3     //Padrao Dbase N
#Define RS_BigInt            20     //Padrao Dbase N
#Define RS_UnsignedTinyInt   17     //Padrao Dbase N
#Define RS_UnsignedSmallInt  18     //Padrao Dbase N
#Define RS_UnsignedInt       19     //Padrao Dbase N
#Define RS_UnsignedBigInt    21     //Padrao Dbase N
#Define RS_Single             4     //Padrao Dbase N
#Define RS_Double             5     //Padrao Dbase N
#Define RS_currency           6     //Padrao Dbase N
#Define RS_Decimal           14     //Padrao Dbase N
#Define RS_Numeric          131     //Padrao Dbase N
#Define RS_Boolean           11     //Padrao Dbase N
#Define RS_Error             10     //Padrao Dbase C
#Define RS_UserDefined      132     //Padrao Dbase C
#Define RS_Variant           12     //Padrao Dbase C
#Define RS_IDispatch          9     //Padrao Dbase C
#Define RS_IUnknown          13     //Padrao Dbase C
#Define RS_GUID              72     //Padrao Dbase C
#Define RS_Date               7     //Padrao Dbase D
#Define RS_DBDate           133     //Padrao Dbase D
#Define RS_DBTime           134     //Padrao Dbase D
#Define RS_DBTimeStamp      135     //Padrao Dbase D
#Define RS_BSTR               8     //Padrao Dbase C
#Define RS_Char             129     //Padrao Dbase C
#Define RS_VarChar          200     //Padrao Dbase C
#Define RS_LongVarChar      201     //Padrao Dbase C
#Define RS_WChar            130     //Padrao Dbase C
#Define RS_VarWChar         202     //Padrao Dbase C
#Define RS_LongVarWChar     203     //Padrao Dbase C
#Define RS_Binary           128     //Padrao Dbase C
#Define RS_VarBinary        204     //Padrao Dbase C
#Define RS_LongVarBinary    205     //Padrao Dbase C
#Define RS_Chapter          136     //Padrao Dbase C
#Define RS_FileTime          64     //Padrao Dbase C
#Define RS_DBFileTime       137     //Padrao Dbase C
#Define RS_PropVariant      138     //Padrao Dbase C
#Define RS_VarNumeric       139     //Padrao Dbase C

#xcommand DECLARE CONNECTION <w> ;
   =>;
   #xtranslate <w>.\<p:BeginTrans,RollbackTrans,CommitTrans,close,execute\> => <w>:\<p\>;;

#xcommand DECLARE RECORDSET <w> ;
   =>;
   #xtranslate <w>.\<p:MoveNext,MovePrevious,MoveFirst,MoveLast,Find,AddNew,Update,Eof,Bof,close,CancelUpdate,Delete,Requery\> => <w>:\<p\>;;
   #xtranslate <w>->\<c>\.\<p:Value,Name,type\> => <w>:Fields\[\<(c)\>]:\<p\>;;
   #xtranslate <w>.\<c\>.\<p:Value,Name,type\> => YKKRETVALUE <w> \<(c)\> \<p\> 

   #xtranslate YKKRETVALUE <a> <b> <c> => <a>:Fields\[\<b>]:<c>

#xTranslate NEW RECORDSET <a>  => <a>:=CreateObject("ADODB.Recordset")
#xTranslate NEW CONNECTION <a> => <a>:=CreateObject("ADODB.Connection")
#command CLOSE CONNECTION <a> => <a>:close()
#command CLOSE RECORDSET <a> => <a>:close()
#xtranslate OPEN CONNECTION <b> STRING <(a)> => <b>:Open(<(a)>)
#command OPEN RECORDSET <a> CONNECTION <b> CURSORTYPE <d> LOCKTYPE <e> SQL <f> => <a>:Open(<f>,<b>,<d>,<e>)
#command ERROR CONNECTION <a> =>  if(<a>:Errors:Count>0,MsgStop("Erro Nativo: "+alltrim(Str(<a>:Errors\[0\]:NativeError))+chr(13)+chr(10)+"Descrição..: "+<a>:Errors\[0\]:Description),Nil)

/********************** Com estas linhas funciona com Harbour
*********************/
#ifdef __HARBOUR__
//ANNOUNCE HB_GTSYS
REQUEST HB_GT_GUI_DEFAULT
#xcommand TRY => BEGIN SEQUENCE WITH s_bBreak
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS
static s_bBreak := { |oErr| break( oErr ) }
#endif
/********************* Com estas linhas funciona com Harbour
*********************/
