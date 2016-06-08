#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Ap5Mail.ch"
#Include "RWMake.ch"
#Include "Colors.ch"
#Include "DbTree.ch"
#Include "Totvs.ch"
#Include "Fileio.ch"


#Define _ENTER chr(13) + Chr(10)


/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNฬO   : NomeProg    | AUTOR : Cristiano Machado  | DATA : 07/10/2015   **
**---------------------------------------------------------------------------**
** DESCRIฬO:  Executa Qualquer Funcao e mantem as ultimas 10 execucoes      **
**          :  ordenandas                                                    **
**---------------------------------------------------------------------------**
** USO      : Funcao de Propriedade Sad Global                               **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
**            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.              **
**---------------------------------------------------------------------------**
**   PROGRAMADOR   |   DATA   |            MOTIVO DA ALTERACAO               **
**---------------------------------------------------------------------------**
**                 |          |                                              **
**                 |          |                                              **
\*---------------------------------------------------------------------------*/
*******************************************************************************
User Function ExecMyFunc()//| Executa Qualquer Funo   Autor: Cristiano Machado   Data: 10/05/2011
*******************************************************************************

Private lContinua 	:= .T.
Private cLastRun 	:= GetProfString( Lower("ExecMy_"+ GetComputerName()), "LastRun"		, "undefined", .T.)

If cLastRun == "undefined"
	cLastRun := ""
EndIf

While lContinua

	WriteProfString( Lower("ExecMy_"+ GetComputerName()), "LastRun"		,cLastRun	,.T.)

	MontaTela()

EndDo

Return()
*******************************************************************************
Static Function MontaTela()
*******************************************************************************

Static oJanela
Static oButton
Static oGet
Static oGroup
Static oRadOpc
Static oSay

Private cAuxRun 	:= cLastRun
Private lTrue 		:= .T.

Private  nRadOpc := 1
Private  cFunc 	 := Space(20)


DEFINE MSDIALOG oJanela TITLE "New Dialog" FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL

@ 004, 003 GROUP oGroup TO 050, 147 PROMPT "Executa Funes " 		   									OF oJanela COLOR  0, 16777215 	PIXEL
@ 023, 047 MSGET oGet VAR cFunc SIZE 094, 016 	PICTURE "@E"							   				OF oJanela COLORS 0, 16777215 	PIXEL
@ 023, 007 RADIO oRadOpc VAR nRadOpc ITEMS "Usuario","Sistema" SIZE 031, 019 							OF oJanela COLOR  0, 16777215 	PIXEL
@ 013, 003 SAY oSay PROMPT "Tipo Funo" 	SIZE 034, 007 												OF oJanela COLORS 0, 16777215 	PIXEL
@ 013, 046 SAY oSay PROMPT "Funo" 		SIZE 021, 007 												OF oJanela COLORS 0, 16777215 	PIXEL

fDBTree()

@ 055, 004 BUTTON oButton PROMPT "Executa" 	ACTION (oJanela:End() , Executa()       ) SIZE 046,012	OF oJanela 				   		PIXEL
@ 055, 099 BUTTON oButton PROMPT "Sair" 	ACTION (oJanela:End() , lContinua := .F.) SIZE 046,012	OF oJanela 				   		PIXEL

ACTIVATE MSDIALOG oJanela CENTERED


Return()

*******************************************************************************
Static Function fDBTree()
*******************************************************************************

Static oRunTree
True 	:= .T.
nCount 	:= 1

oRunTree := DbTree():New(004,155,068,245,oJanela,,,.T.)//fDBTree()
oRunTree:AddItem(PadR("Ultimas Exec",15," "),"001", "FOLDER5" ,,,,1)

While lTrue

	nPos := At(',',cAuxRun)
	nCount	+= 1
	If nPos <= 0
		lTrue := .F.
		Loop
	Endif

	cAuxFunc	:= 	PadR(Substr(cAuxRun,1,nPos - 1),15," ")
	cAuxCont	:= 	StrZero(nCount,3)

	oRunTree:AddItem(cAuxFunc ,cAuxCont, "FOLDER6",,,,2)

	cAuxRun	:= Substr(cAuxRun,nPos + 1)

EndDo

oRunTree:EndTree()

Return()

*******************************************************************************
Static Function Executa()
*******************************************************************************
cFunc :=  Alltrim(cFunc)

If Empty(cFunc)
	cFunc := Alltrim(oRunTree:GetPrompt(.T.))
EndIf

If nRadOpc == 1
	cFunc :=  "U_" + cFunc
EndIf

If At("(",cFunc) <= 0
	cFunc := cFunc + "()"
EndIF

&cFunc.

Alert( " Fim da Execuo da Rotina "+ cFunc )

AtuUltFun() //| Atualiza Ultimas Funcoes Executadas

Return()
*********************************************************************
Static Function AtuUltFun()
*********************************************************************
	nVir := 0
	nPos := At("U_", cFunc )
	If nPos > 0
		cFunc :=  Substr(cFunc,3)
	EndIf

	nPos := At("(",	cFunc )
	If nPos > 0
		cFunc := Substr(cFunc,1,nPos-1)
	EndIF

	nPos := At(cFunc, cLastRun )


	If nPos <= 0
		cLastRun := cFunc + "," + cLastRun
	Else
		cLastRun := cFunc+ "," + Substr(cLastRun,1,nPos - 1) + Substr(cLastRun,nPos + Len(cFunc) + 1)
	EndIf

	nPos := 0
	For N := 1 To Len(cLastRun)

		If Substr(cLastRun,N,1) == ","
			nVir += 1
		Endif

		If nVir == 11
			nPos := N
			Exit
		EndIf

	Next

	If nPos <> 0
		cLastRun := Substr(cLastRun,1,nPos - 1)
	EndIf

	cFunc := ""

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecMySql บAutor  ณCristiano Machado   บ Data ณ  07/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPar: 	cSql    = Texto Sql,                                  บฑฑ
ฑฑบ			 ณ	  	cAlias  = Alias a ser usado no caso de Query          บฑฑ
ฑฑบ          ณ      lModo   = "E"-Execucao ou "Q"-Query)                  บฑฑ
ฑฑบ          ณ      lMostra = Se deve Apresentar a Query para captura     บฑฑ
ฑฑบ          ณ      lChange = Se deve executar o ChangeQuery              บฑฑ
ฑฑบ          ณObs.: Execucao(Drop, Update, Delete e etc..                 บฑฑ
ฑฑบ          ณRetorno: No modo Execucao retorna o Status caracter, em     บฑฑ
ฑฑบ          ณmodo Query nใo tem retorno.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*********************************************************************
User Function ExecMySql( cSql , cCursor , lModo, lMostra, lChange )
*********************************************************************
	Local nRet := 0
	Local cRet := "Executado Com Sucesso"

	Default lModo   := "Q"
	Default lMostra := .F.
	Default lChange := .T.

	If lMostra
		U_MostraTxt(cSql)
	EndIf

	If lModo == "Q" //| Query

		If lChange
			cSql := ChangeQuery(cSql)
		Else
			cSql := Upper(cSql)
		EndIf

		If( Select(cCursor) <> 0 )
			DbSelectArea(cCursor)
			DbCloseArea()
		EndIf

		TCQUERY cSql NEW ALIAS &cCursor.

	ElseIf lModo == "E" //| Comandos

		cSql := Upper(cSql)

		nRet := TCSQLExec(cSql)

		If nRet <> 0
			cRet := TCSQLError()
			If lmostra
				Iw_MsgBox(cRet)
			Endif
		Endif
	Return(cRet)

	ElseIf lModo == "P" //Procedure

		cSql := Upper(cSql)

		TCSQLExec("BEGIN")

		nRet := TCSPExec(cSql)

		If Empty(nRet)
			cRet := TCSQLError()

			If lmostra
				Iw_MsgBox(cRet)
			Endif
		Endif

		TCSQLExec("END")

	Return(cRet)

	Endif


Return()
/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNฬO   : MostraTxt    | AUTOR : Cristiano Machado  | DATA : 07/10/2015   **
**---------------------------------------------------------------------------**
** DESCRIฬO:  Apresenta Memo editavel com Texto recebido via Parametro      **
**          :                                                                **
**---------------------------------------------------------------------------**
** USO      : Funcao de Propriedade Sad Global                               **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
**            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.              **
**---------------------------------------------------------------------------**
**   PROGRAMADOR   |   DATA   |            MOTIVO DA ALTERACAO               **
**---------------------------------------------------------------------------**
**                 |          |                                              **
**                 |          |                                              **
\*---------------------------------------------------------------------------*/
*********************************************************************
User Function MostraTxt( cTxt )
*********************************************************************
	__cFileLog := MemoWrite(Criatrab(,.F.)+".log",cTxt)

	Define FONT oFont NAME "Tahoma" Size 6,12
	Define MsDialog oDlgMemo Title "Leitura Concluida." From 3,0 to 340,550 Pixel

	@ 5,5 Get oMemo  Var cTxt MEMO Size 265,145 Of oDlgMemo Pixel
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	Define SButton  From 153,235 Type 1 Action oDlgMemo:End() Enable Of oDlgMemo Pixel

	Activate MsDialog oDlgMemo Center

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadBmp   บAutor  ณCristiano Machado   บ Data ณ  08/22/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que cria tabela local..                            	บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ aStruFile		-> 	Extrutura Padrao para Campos da tabela 		บฑฑ
ฑฑบ          ณ Ex.: = {	{ "FILIAL" , "C",  2, 0	},{	"TOTAL" , "N", 12, 0	}}บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ [aStruIndex]	-> 	Extrutura contendo os indices desejados.. 	บฑฑ
ฑฑบ          ณ                  caso nao informado nao cria indices...   	บฑฑ
ฑฑบ          ณ                  Ex.: = { "FILIAL+PERIODO","FILIAL+TOTAL" }บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ [cPath] 		-> 	NIl  system ou informar outro caminho   	  บฑฑ
ฑฑบ          ณ                  apartir do rootpath                      	บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ [cNameFile] 	-> 	Informar o Nome do arquivo   	             บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ [cAliasFile] -> 	Informar o Apelido que deve ser utilizado 	บฑฑ
ฑฑบ          ณ                  ou caso nao informar sera utilizado TAUX 	บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ [cDriver]		-> 	.T. Substitui o Arquivo caso j exista....	บฑฑ
ฑฑบ          ณ              		.F. Abre o arquivo caso exista...        	บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑบ          ณ [lReplace]		-> 	.T. Substitui o Arquivo caso j exista....	บฑฑ
ฑฑบ          ณ              		.F. Abre o arquivo caso exista...        	บฑฑ
ฑฑบ          ณ                                                           	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ cRetorno 		-> 	ALIAS do arquivo caso tenha sucesso na    	บฑฑ
ฑฑบ          ณ									criacao ou vazio em caso de erro...        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Exemplos 		-> 	Nome do arquivo caso tenha sucesso na    	บฑฑ
ฑฑบ          ณ                                                 						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
********************************************************************
User Function MyFile( aStruFile, aStruIndex, cPath, cNameFile, cAliasFile, cDriver, lReplace )
********************************************************************
	Local cFileFull		:= ""
	Local cFileExt			:= GetDbExtension()
	Local cRetorno			:= ""
	Local cIndexExt		:= ""
	Local cIndexFull		:= ""

	Default aStruFile	:= {}
	Default aStruIndex	:= {}
	Default cNameFile 	:= CriaTrab(,.f.)
	Default cPath 			:= "\system\"
	Default cAliasFile := "TAUX"
	Default cDriver		:= RealRDD()
	Default lReplace		:= .F.


	//| Preenche as Variaveis Vazias...
	If Len(aStruFile) < 1
		Return(cRetorno)
	EndIf
	If Empty(cNameFile)
		cNameFile 	:= CriaTrab(,.f.)
	EndIf
	If Empty(cPath)
		cPath 			:= "\system\"
	EndIf
	If Empty(cAliasFile)
		cAliasFile := "TAUX"
	EndIf
	If Empty(cDriver)
		cDriver		:= RealRDD()
	EndIf

	// Monta Caminho e nome do Arquivo Completo...
	cFileFull := Lower(cPath + cNameFile + cFileExt)

	// Monta Extensao do indice da Tabela...
	cIndexExt	:= IIf(AT("CTREE",cDriver)>0,"cdx","idx")

	// Monta Caminho e nome do Arquivo Indice Completo...
	cIndexFull := Lower(cPath + cNameFile + "." + cIndexExt)

	// Varifica se alias alias esta aberto....
	If ( Select(cAliasFile) > 0 ) .And. lReplace
		DbSelectArea(cAliasFile)
		DbCloseArea(cAliasFile) // Fecha Alias
	EndIf

	// Verifica se Arquivo existe...
	If ( File( cFileFull ) )
		If lReplace
			If FErase(cFileFull)
				DbCreate( cFileFull, aStruFile, cDriver )
			//	Alert("Criou o Arquivo de Tabela..."+ cFileFull)
			Else
				Return()
			EndIf
		EndIf
	Else
		DbCreate( cFileFull, aStruFile, cDriver )
		lReplace := .T.
	//	Alert("Criou o Arquivo de Tabela..."+ cFileFull)
	EndIf


	// Apaga o arquivo index
	If lReplace
		If File( cIndexFull )
			FErase(cIndexFull)
		EndIf
	EndIf

	// Cria o Alias de Trabalho
	If ( Select(cAliasFile) <= 0 )
		DbUseArea( lReplace, cDriver	, cFileFull		, cAliasFile	, .T. 	,	.F.	)
	EndIf

	// Cria indices...
	If lReplace

		For i := 1 To Len(aStruIndex)
			OrdCreate( cIndexFull , cValToChar(i), aStruIndex[i], { || aStruIndex[i] }, )
		Next

	EndIf

	// Define o indice que deve ser usado... //| DBOI_ORDERCOUNT

	DbSelectArea(cAliasFile)
	DbSetIndex(cIndexFull)

	If ( Select(cAliasFile) > 0 )
		cRetorno := cAliasFile
		DbSelectArea(cAliasFile)
		DbGotop()
		lReplace := .F.

	EndIf

Return(cRetorno)
/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNฬO   : MostraTxt    | AUTOR : Cristiano Machado  | DATA : 07/10/2015   **
**---------------------------------------------------------------------------**
** DESCRIฬO:  Apresenta Memo editavel com Texto recebido via Parametro      **
**          :                                                                **
**---------------------------------------------------------------------------**
** USO      : Funcao de Propriedade Sad Global                               **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
**            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.              **
**---------------------------------------------------------------------------**
**   PROGRAMADOR   |   DATA   |            MOTIVO DA ALTERACAO               **
**---------------------------------------------------------------------------**
**                 |          |                                              **
**                 |          |                                              **
\*---------------------------------------------------------------------------*/
*******************************************************************************
User Function TabToArray(_cAlias, _lHeader )// Joga o conteudo da tabela em array...
*******************************************************************************

	Local aStru 			:= {}
	Local aAux				:= {}
	Local aVaz				:= {}
	Local aRet				:= {}
	Local aLine			:= {}
	Static CAMPO			:= 1

	Default _cAlias 	:= ""
	Default _lHeader := .F.

	_cAlias := Alltrim( _cAlias )

// Obtem Estrutura da Tabela...
	DbSelectArea(_cAlias)
	aStru := DbStruct()

// Cria Array com nome dos campos que compoe a tabela
	For i:= 1 To Len(aStru)

		Aadd( aAux, aStru[i][CAMPO] )

	Next

	If _lHeader
		aadd( aRet ,  aAux  )
	EndIf

	lPri := .T.
	DbSelectArea(_cAlias);DbGotop()
	While !Eof()

		aLine := {}
		aEval( aAux, { |aCampo| cCampo:= _cAlias+"->"+Alltrim(aCampo) , Aadd( aLine, &cCampo ) } )

		aadd( aRet ,  aLine  )

		DbSelectArea(_cAlias)
		DbSkip()

	EndDo


	// Caso a tabela esteja vazia... cria uma linha vazia no array
	If ( Len(aRet) == 0 )

		aLine := {}
		For i := 1 To Len(aStru)

			If ( aStru[i][2] == "N" )
				cConteudo := 0
			ElseIf ( aStru[i][2] == "B" )
				cConteudo := .F.
			ElseIf ( aStru[i][2] == "D" )
				cConteudo := CToD("  /  /  ")
			Else
				cConteudo := Space(aStru[i][3])
			EndIf

			Aadd( aLine, cConteudo )

		Next

		aadd( aRet ,  aLine  )

	EndIf


Return ( aRet )
/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNฬO   : MostraTxt    | AUTOR : Cristiano Machado  | DATA : 07/10/2015   **
**---------------------------------------------------------------------------**
** DESCRIฬO:  Apresenta Memo editavel com Texto recebido via Parametro      **
**          :                                                                **
**---------------------------------------------------------------------------**
** USO      : Funcao de Propriedade Sad Global                               **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
**            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.              **
**---------------------------------------------------------------------------**
**   PROGRAMADOR   |   DATA   |            MOTIVO DA ALTERACAO               **
**---------------------------------------------------------------------------**
**                 |          |                                              **
**                 |          |                                              **
\*---------------------------------------------------------------------------*/
*******************************************************************************
User Function XToC(xVar) // Converte Qualquer Tipo de Variavel para Caracter
*******************************************************************************

Return(Alltrim(cValToChar(xVar)))


//|Funcao	: ArrayToCsv -> Converte um Array em Arquivo texto tipo .CSV
//|Autor		: Cristiano Machado												Data: 02/12/2104
//|
//|Parametros:
//|		aArray				: Array contendo os dados (Obrigatorio)
//|		cNameFile 		: Nome do Arquivo [Opcional] Padrao: Aleatorio
//|		cDelimitador	: Define o delimitador de campos [Opcional].. Padrao: ";"
//|
//|Retorno: Nome do Arquivo Criado... com caminho completo...e extensao...
/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNฬO   : MostraTxt    | AUTOR : Cristiano Machado  | DATA : 07/10/2015   **
**---------------------------------------------------------------------------**
** DESCRIฬO:  Apresenta Memo editavel com Texto recebido via Parametro      **
**          :                                                                **
**---------------------------------------------------------------------------**
** USO      : Funcao de Propriedade Sad Global                               **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
**            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.              **
**---------------------------------------------------------------------------**
**   PROGRAMADOR   |   DATA   |            MOTIVO DA ALTERACAO               **
**---------------------------------------------------------------------------**
**                 |          |                                              **
**                 |          |                                              **
\*---------------------------------------------------------------------------*/
*******************************************************************************
User Function ArrayToFCsv( aArray , cNameFile, cDelimitador )
*******************************************************************************
	Local aHeader				:= {}
	Local nHandle				:= {}
	Local cExt						:= ".csv"
	Local cLin						:= ""
	Local aArrLin				:= {}

	Static  POSCAB				:= 1

	Default	aArray				:=	 {}
	Default 	cNameFile 		:= LOWER(CriaTrab(,.f.))
	Default	cDelimitador	:= ";"

	If Len( aArray ) == 0
		Return("")
	EndIf

	nHandle	:= FCreate ( "\"+cNameFile+cExt, FC_NORMAL , Nil , .T. )

	For nLin := 1 To Len(aArray)

		aArrLin := aArray[nLin]

		For nCol := 1 To Len(aArrLin)

			cLin += U_xToC(aArrLin[nCol]) + cDelimitador

		Next
		cLin += _ENTER

		FWrite ( nHandle, cLin, Len(cLin) )

		cLin := ""

	Next

	FClose( nHandle )


Return(cNameFile + cExt)