#Include "PROTHEUS.Ch"
#Include "CTBR049.Ch"


#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT    	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO   	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_VLR_CREDITO  	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15
#DEFINE 	TAM_VALOR			20

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณ Ctbr049	ณ Autor ณ Alvaro Camillo Neto  ณ Data ณ 12.09.00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Balancete Analitico Plano de Contas Referencial            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Ctbr049()                               			 		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno	 ณ Nenhum       											  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso    	 ณ Generico     											  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum													  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Function Ctbr049()
Local lImpBalR4		:= TRepInUse()

Private titulo		:= ""
Private nomeprog	:= "CTBR049"
PRIVATE cCvdCodPla:= ""
Private cPlanoRef	:= ""	//utilizado na consulta padrao CVN3 -> Fun็ใo CtbFilVers()
Private cVersao		:= ""	//utilizado na consulta padrao CVN3 -> Fun็ใo CtbFilVers()

If lImpBalR4
	CTBR049R4()
Else
	MsgAlert(STR0001)//"Relatorio disponํvel apenas em TReport"
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณ CTBR049R4 ณ Autorณ Daniel Sakavicius		ณ Data ณ 01/08/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Balancete Analitico Sintetico Modelo 1 - R4                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ CTBR049R4												  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ SIGACTB                                    				  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Function CTBR049R4()
Local oReport := Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInterface de impressao                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aSelFil		:= {}
Private cPerg2		:= "CTBPLREF2"

Pergunte("CTR049A",.F.)

oReport := ReportDef()

If Valtype( oReport ) == 'O'
	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf
	
	oReport:PrintDialog()
Endif

oReport := Nil

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportDef ณ Autor ณ Daniel Sakavicius		ณ Data ณ 28/07/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณEsta funcao tem como objetivo definir as secoes, celulas,   ณฑฑ
ฑฑณ          ณtotalizadores do relatorio que poderao ser configurados     ณฑฑ
ฑฑณ          ณpelo relatorio.                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ SIGACTB                                    				  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef()
local aArea	   		:= GetArea()
Local CREPORT		:= "CTBR049"
Local CTITULO		:= STR0002  			//"Emissao do Relat. Plan. Ref. "
Local CDESC			:= OemToAnsi(STR0003) // "Este programa ira imprimir o Balancete baseado na amarra็ใ do plano de contas com o plano de contas referencial"
Local cPerg	   		:= "CTR049A"
Local CCOLBAR		:= "|"
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= {40}
Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Local nDecimais
Local cSeparador	:= ""
Local nTamConta		:= 20
Local nMaskFator 	:= 1
Local oReport 

 
If Pergunte( "CTR049A" , .T. )

	cPlanoRef	:= mv_par03
	cVersao		:= mv_par04
	
	If Empty(cPlanoRef) .Or. Empty(cVersao)
		MsgAlert(STR0023)	//"Plano Referencial e/ou Versใo nใo preenchidos. " 
		Return
	EndIf	
	
	DbSelectArea("CVN")
	DbSetOrder(4) 	//CVN_FILIAL+CVN_CODPLA+CVN_VERSAO+CVN_CTAREF                                                                                                                     
	If !DbSeek(xFilial("CVN")+cPlanoRef+cVersao)	
		MsgAlert(STR0024)	//"Plano Ref. e Versao nใo cadastrados no Cad. Plano Referencial."
		Return
	Endif		 	
	 	
	If mv_par16 == 1 .And. Len( aSelFil ) <= 0  .And. !IsBlind()
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			Return
		EndIf
	EndIf
	
	Pergunte(cPerg2,.T.)	//Exibe a pergunta de Intervalo de Contas
		
	nTamConta := aTamConta[1]
	cPicture := ""
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao do componente de impressao                                      ณ
	//ณ                                                                        ณ
	//ณTReport():New                                                           ณ
	//ณExpC1 : Nome do relatorio                                               ณ
	//ณExpC2 : Titulo                                                          ณ
	//ณExpC3 : Pergunte                                                        ณ
	//ณExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ณ
	//ณExpC5 : Descricao                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	oReport	:= TReport():New( cReport,Capital(CTITULO),cPerg, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC )
	oReport:ParamReadOnly()
	
	IF GETNEWPAR("MV_CTBPOFF",.T.)
		oReport:SetEdit(.F.)
	ENDIF
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao da secao utilizada pelo relatorio                               ณ
	//ณ                                                                        ณ
	//ณTRSection():New                                                         ณ
	//ณExpO1 : Objeto TReport que a secao pertence                             ณ
	//ณExpC2 : Descricao da se็ao                                              ณ
	//ณExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ณ
	//ณ        sera considerada como principal para a se็ใo.                   ณ
	//ณExpA4 : Array com as Ordens do relat๓rio                                ณ
	//ณExpL5 : Carrega campos do SX3 como celulas                              ณ
	//ณ        Default : False                                                 ณ
	//ณExpL6 : Carrega ordens do Sindex                                        ณ
	//ณ        Default : False                                                 ณ
	//ณ                                                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection1  := TRSection():New( oReport, STR0004, {"cArqRef","CT1"},, .F., .F.,,,,,,,,,0 ) //"Plano de contas referencial"
	
	TRCell():New( oSection1, "CONTA"	,,STR0005/*Titulo*/	,/*Picture*/, nTamConta /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"LEFT"*/,,/*"LEFT"*/,,,.F.) //"Conta"
	TRCell():New( oSection1, "DESCCTA"  ,,STR0006/*Titulo*/	,/*Picture*/, aTamDesc[1]/*Tamanho*/, /*lPixel*/,/*CodeBlock*/,  /*"LEFT"*/,.T.,/*"LEFT"*/,,,.F.)//"Descricao"
	TRCell():New( oSection1, "SALDOANT" ,,STR0007/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)//"Saldo anterior"
	TRCell():New( oSection1, "SALDODEB" ,,STR0008/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)//"D้bito"
	TRCell():New( oSection1, "SALDOCRD" ,,STR0009/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)//"Cr้dito"
	TRCell():New( oSection1, "MOVIMENTO",,STR0010/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)//"Mov  periodo"
	TRCell():New( oSection1, "SALDOATU" ,,STR0011/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)//"Saldo atual"
	
	TRPosition():New( oSection1, "CT1", 1, {|| xFilial( "CT1" ) + cArqRef->CONTA })
	
	oSection1:Cell("CONTA"):lHeaderSize		:= .F.
	oSection1:Cell("DESCCTA"):lHeaderSize	:= .F.
	oSection1:Cell("SALDOANT"):lHeaderSize	:= .F.
	oSection1:Cell("SALDODEB"):lHeaderSize	:= .F.
	oSection1:Cell("SALDOCRD"):lHeaderSize	:= .F.
	oSection1:Cell("MOVIMENTO"):lHeaderSize	:= .F.
	oSection1:Cell("SALDOATU"):lHeaderSize	:= .F.
	
	oSection1:SetTotalInLine(.F.)
	oSection1:SetTotalText('')
	oSection1:SetEdit(.F.)
Endif

Return( oReport )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณ Daniel Sakavicius	ณ Data ณ 28/07/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณImprime o relatorio definido pelo usuario de acordo com as  ณฑฑ
ฑฑณ          ณsecoes/celulas criadas na funcao ReportDef definida acima.  ณฑฑ
ฑฑณ          ณNesta funcao deve ser criada a query das secoes se SQL ou   ณฑฑ
ฑฑณ          ณdefinido o relacionamento e filtros das tabelas em CodeBase.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ ReportPrint(oReport)                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณEXPO1: Objeto do relat๓rio                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint( oReport )

Local oSection1 	:= oReport:Section(1)
Local lExterno		:= .F.
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lRet			:= .T.
Local lPrintZero	:= (mv_par11==1)
Local lVlrZerado	:= (mv_par06==1)
Local l132			:= .T.
Local nDecimais
Local nDivide		:= 1
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local nDigitAte		:= 0
Local lImpAntLP		:= (mv_par13 == 1)
Local dDataLP		:= mv_par14
Local lImpMov		:= (mv_par10== 1)
Local n
Local oMeter
Local oText
Local oDlg
Local oBreak
Local lImpPaisgm	:= .F.
Local nMaxLin   	:= mv_par15
Local cMoedaDsc		:= mv_par05
Local aCtbMoeda		:= {}
Local aCtbMoedadsc	:= {}
Local CCOLBAR		:= "|"
Local cTipoAnt		:= ""
Local cGrupoAnt		:= ""
Local cArqRef		:= "cArqRef"
Local Tamanho		:= "M"
Local cSeparador	:= ""
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local oTotGerDeb
Local oTotGerCrd
Local cPicture
Local cContaSint
Local cBreak		:= "2"
Local cGrupo		:= ""
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerMov	:= 0
Local nCont			:= 0
Local nMasc			:= 0
Local cMasc			:= ""
Local lEnd
Local aSetOfBook := CTBSetOf("")
Local cFilTit		:= ""
Local nX


Private nLinReport    := 9

If oReport:nDevice == 5 .OR. oReport:nDevice == 3
	oSection1:Cell("SALDOANT"):SetAlign("RIGHT")
	oSection1:Cell("SALDODEB"):SetAlign("RIGHT")
	oSection1:Cell("SALDOCRD"):SetAlign("RIGHT")
	oSection1:Cell("MOVIMENTO"):SetAlign("RIGHT")
	oSection1:Cell("SALDOATU"):SetAlign("RIGHT")
Endif

VldPlanRef(mv_par03)

If mv_par12 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par12 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par12 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda := CtbMoeda( mv_par07 , nDivide )
	
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
		Return lRet
	Endif
	
	// valida็ใo da descri็ใo da moeda
	if lRet .And. ! Empty( mv_par05 ) 
		aCtbMoedadsc := CtbMoeda( mv_par05 , nDivide )
		
		If Empty( aCtbMoedadsc[1] )
			Help( " " , 1 , "NOMOEDA")
			lRet := .F.
			Return lRet
		Endif
	Endif
Endif

aCtbMoeda  	:= CtbMoeda(mv_par07,nDivide)

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par07)
cPicture 	:= ""

lPrintZero	:= Iif(mv_par11==1,.T.,.F.)

cDescPlan := GetAdvFval("CVN","CVN_DSCPLA",xFilial("CVN") + mv_par03 ,2 )
If oReport:Title() == oReport:cRealTitle
	Titulo:=	OemToAnsi(STR0012) + " " + Alltrim(cDescPlan) + CRLF 	//"BALANCETE PLANO REFERENCIAL: "
	Titulo += 	STR0013 + DTOC(mv_par01) + OemToAnsi(STR0014) + Dtoc(mv_par02) + ;//" DE "##" ATE "
	OemToAnsi(STR0015) + cDescMoeda + CtbTitSaldo(mv_par09)//" EM "
Else
	Titulo := oReport:Title()
Endif

If Len(aSelFil) > 0
	For nX := 1 to Len(aSelFil)
		cFilTit += Alltrim(aSelFil[nX]) + If( nX<Len(aSelFil),If(nX+1 == Len(aSelFil),STR0016,",")," ")//" E "
	Next nX
	Titulo += If(Len(aSelFil)>1,STR0017,STR0018)+cFilTit //" - FILIAIS: "##" - FILIAL: "
EndIf

oReport:SetPageNumber( mv_par08 )
oReport:SetCustomText( {|| nCtCGCCabTR(dDataFim,titulo,oReport)})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Arquivo Temporario para Impressao			  		     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
CtSalPlanRef(oMeter, oText, oDlg, @lEnd,@cArqRef,mv_par01,mv_par02,mv_par03,mv_par04,;
mv_par07,mv_par09,lImpAntLP,dDataLP,nDivide,lVlrZerado,aSelfil)},;
OemToAnsi(OemToAnsi(STR0019)),;  //"Criando Arquivo Temporario..."
OemToAnsi(STR0020))  				//"Balancete Verificacao"

nCount := (cArqRef)->(RecCount())

oReport:SetMeter(nCont)

If nCount > 0
	
	(cArqRef)->(dbGoTop())
	
	oSection1:Cell("CONTA"):SetBlock( {|| (cArqRef)->CONTA } )
	
	oSection1:Cell("DESCCTA"):SetBlock( { || (cArqRef)->DESCCTA } )
	
	oSection1:Cell("SALDOANT"):SetBlock( { || ValorCTB((cArqRef)->SALDOANT,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDODEB"):SetBlock( { || ValorCTB((cArqRef)->SALDODEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOCRD"):SetBlock( { || ValorCTB((cArqRef)->SALDOCRD,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATU"):SetBlock( { || ValorCTB((cArqRef)->SALDOATU,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
	
	//	 Imprime Movimento
	If !lImpMov
		oSection1:Cell("MOVIMENTO"):SetSize(0)
		oSection1:Cell("MOVIMENTO"):Disable()
	Else
		oSection1:Cell("MOVIMENTO"):SetBlock( { || ValorCTB((cArqRef)->MOVIMENTO,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,, lPrintZero,.F.) } )
	EndIf
	
	//******************************
	// Total Geral do relatorio    *
	//******************************
	oBrkGeral := TRBreak():New(oSection1, { || (cArqRef)->(!Eof()) },{|| STR0021 },,,.F.)	//	" T O T A I S "
	
	// Totaliza
	oTotGerDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || (cArqRef)->SALDODEB },.F.,.F.,.F.,oSection1)
	oTotGerDeb:Disable()
	
	oTotGerCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || (cArqRef)->SALDOCRD },.F.,.F.,.F.,oSection1)
	oTotGerCrd:Disable()
	
	
	TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotGerDeb:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
	
	
	// Imprime
	TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotGerCrd:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},.F.,.F.,.F.,oSection1)
	
	oSection1:OnPrintLine( {|| 	CTR049OnPrint( nMaxLin, @nLinReport,oReport ) } )
	
	oSection1:Print()
	
EndIf

dbSelectArea(cArqRef)
Set Filter To
dbCloseArea()
If Select(cArqRef) == 0
	FErase(cArqRef+GetDBExtension())
	FErase(cArqRef+OrdBagExt())
EndIF

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtSalPlanRefบAutorณAlvaro Camillo Neto บ Data ณ  28/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o arquivo de trabalho com os saldos do plano       บฑฑ
ฑฑบ          ณ de contas referencial                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtSalPlanRef(oMeter, oText, oDlg,lEnd,cArqTrab,dDataIni,dDataFim,cPlanRef,cVersao,cMoeda,cTpSald,lImpAntLP,dDataLP,nDivide,lVlrZerado,aSelfil)
Local cQuery 		:= ""
Local cAliasCVD		:= ""
Local cArqCVD		:= ""
Local aCampos		:= {}
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local aTamClasse	:= TAMSX3("CVD_CLASSE")
Local aTamCtaSup	:= TAMSX3("CVD_CTASUP")
Local aCtbMoeda 	:= CTbMoeda(cMoeda)
Local nDecimais 	:= aCtbMoeda[5]
Local aSaldoAnt		:= {}
Local aSaldoAtu		:= {}
Local cWhere		:= ""

Local nRegSupTmp 	:= 0
Local nSldSupAnt	:= 0 
Local nSldSupAtu	:= 0 
Local nSldSupDeb	:= 0
Local nSldSupCrd 	:= 0
Local nMovSup		:= 0
Local cSuperior		:= ''

Local nCont			:= 0
		
Default cArqTrab		:= "cArqRef"
Default nDivide			:= 1


Pergunte(cPerg2,.F.)

MakeSqlExpr(cPerg2)

cWhere	:= MV_PAR01 //SUBSTRING(MV_PAR01,13,LEN(ALLTRIM(MV_PAR01))-13)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ(ฟ
//ณMonta a estrutura do arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ(ู
aAdd(aCampos, { "CONTA"		, "C", aTamConta[1]	, 0 })
aAdd(aCampos, { "DESCCTA"	, "C", nTamCta		, 0 })
aAdd(aCampos, { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais })
aAdd(aCampos, { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais })
aAdd(aCampos, { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais })
aAdd(aCampos, { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais })
aAdd(aCampos, { "MOVIMENTO"	, "N", aTamVal[1]+1	, nDecimais })
aAdd(aCampos, { "CLASSE"	, "C", aTamClasse[1], 0 })
aAdd(aCampos, { "SUPERIOR"	, "C", aTamCtaSup[1], 0 })
cChave := "CONTA"

cArqAux := CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cArqAux, cArqTrab , .F., .F. )
cArqInd	:= CriaTrab(Nil, .F.)
IndRegua(cArqTrab,cArqInd,cChave,,,OemToAnsi(STR0022))  //"Selecionando Registros..."
dbSelectArea(cArqTrab)
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona o arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAliasCVD := GetNextAlias()
cQuery 	+= " SELECT "
cQuery 	+= " 	CVD_CONTA, "
cQuery 	+= " 	CVD_ENTREF, "
cQuery 	+= " 	CVD_CODPLA, "
cQuery 	+= " 	CVD_CTAREF, "
cQuery 	+= " 	CVD_CUSTO "
cQuery 	+= " 	CVD_CLASSE,	"
cQuery 	+= " 	CVD_CTASUP  "
cQuery 	+= " FROM  "
cQuery 	+= RetSQLTab("CVD")
cQuery 	+= " WHERE  "
cQuery 	+= " 	CVD_CODPLA = '"+cPlanRef+"' AND "
cQuery 	+= " 	CVD_VERSAO = '"+cVersao+"' AND "
cQuery	+= "    CVD_CTAREF <> '' AND "
If !Empty(cWhere)
	cQuery  += cWhere
	cQuery	+= " AND " 
EndIf	
cQuery 	+= RetSQLCond("CVD")
cQuery 	+= "ORDER BY CVD_CODPLA,CVD_CTAREF, CVD_CTASUP "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCVD,.T.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa o saldo das contasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (cAliasCVD)->(!Eof())
	While  (cAliasCVD)->(!Eof()) 
		lCusto := !Empty((cAliasCVD)->CVD_CUSTO )
		
		If lCusto
			aSaldoAnt	:= SaldoCT3Fil((cAliasCVD)->CVD_CONTA,(cAliasCVD)->CVD_CUSTO,dDataIni,cMoeda,cTpSald,'CTBXFUN',lImpAntLP,dDataLP,aSelFil)
			aSaldoAtu	:= SaldoCT3Fil((cAliasCVD)->CVD_CONTA,(cAliasCVD)->CVD_CUSTO,dDataFim,cMoeda,cTpSald,'CTBXFUN',lImpAntLP,dDataLP,aSelFil)
		Else
			aSaldoAnt	:= SaldoCT7Fil((cAliasCVD)->CVD_CONTA,dDataIni,cMoeda,cTpSald,'CTBXFUN',lImpAntLP,dDataLP,aSelFil)
			aSaldoAtu	:= SaldoCT7Fil((cAliasCVD)->CVD_CONTA,dDataFim,cMoeda,cTpSald,'CTBXFUN',lImpAntLP,dDataLP,aSelFil)
		EndIf
		
		nSaldoAntD 	:= aSaldoAnt[7]
		nSaldoAntC 	:= aSaldoAnt[8]
		
		nSldAnt		:= nSaldoAntC - nSaldoAntD
		
		nSaldoAtuD 	:= aSaldoAtu[4]
		nSaldoAtuC 	:= aSaldoAtu[5]
		nSldAtu		:= nSaldoAtuC - nSaldoAtuD
		
		nSaldoDeb  := nSaldoAtuD - nSaldoAntD
		nSaldoCrd  := nSaldoAtuC - nSaldoAntC
		
		If nDivide > 1
			nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)
			nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
		EndIf
		
		nMovimento	:= nSaldoCrd-nSaldoDeb
		
		If nDivide > 1
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont
		EndIf
		
		
		If lVlrZerado .Or. (  aSaldoAnt[6] <> 0 .Or. aSaldoAtu[1] <> 0 )
			If (cArqTrab)->(MsSeek( (cAliasCVD)->CVD_CTAREF ) )
				RecLock(cArqTrab,.F.)
				
				(cArqTrab)->SALDOANT 	+= aSaldoAnt[6]				// Saldo anterior
				(cArqTrab)->SALDOATU 	+= aSaldoAtu[1]	   			// Saldo Atual
				(cArqTrab)->SALDODEB	+= nSaldoDeb				// Saldo Debito
				(cArqTrab)->SALDOCRD	+= nSaldoCrd				// Saldo Credito
				(cArqTrab)->MOVIMENTO 	+= (cArqTrab)->(SALDOCRD-SALDODEB)        // Movimento
				
				MsUnlock()
			Else
				RecLock(cArqTrab,.T.)
				(cArqTrab)->CONTA		:= (cAliasCVD)->CVD_CTAREF
				(cArqTrab)->DESCCTA		:= GetAdvFval("CVN","CVN_DSCCTA",xFilial("CVN") + (cAliasCVD)->(CVD_CODPLA + CVD_CTAREF),2 )
				(cArqTrab)->SALDOANT 	:= aSaldoAnt[6]			   				// Saldo anterior
				(cArqTrab)->SALDOATU 	:= aSaldoAtu[1]	   		   				// Saldo Atual
				(cArqTrab)->SALDODEB	:= nSaldoDeb			   				// Saldo Debito
				(cArqTrab)->SALDOCRD	:= nSaldoCrd			   				// Saldo Credito
				(cArqTrab)->MOVIMENTO 	:= (cArqTrab)->(SALDOCRD-SALDODEB)		// Movimento
				(cArqTrab)->CLASSE		:= (cAliasCVD)->CVD_CLASSE
				(cArqTrab)->SUPERIOR	:= (cAliasCVD)->CVD_CTASUP
				MsUnlock()
			EndIf
		EndIf
		(cAliasCVD)->(dbSkip())
	EndDo
	
EndIf

//-----------------------------------------
// Atualiza o saldo das Contas Sint้ticas
// Somente serใo impresso o saldo das contas 
//   sinteticas, caso o parametros Imprime
//   Contas Zeradas esteja igual a SIM.
// Isso porque as contas sinteticas nao 
//   possuem valores;
//-----------------------------------------
If lVlrZerado
	dbSelectArea(cArqTrab)
	(cArqTrab)->(dbGoTop())
	
	While ( (cArqTrab)->( !Eof() ) )
		If (cArqTrab)->CLASSE == '2'
			nRegSupTmp 	:= Recno()
			nSldSupAnt	:= (cArqTrab)->SALDOANT 
			nSldSupAtu	:= (cArqTrab)->SALDOATU 
			nSldSupDeb	:= (cArqTrab)->SALDODEB
			nSldSupCrd 	:= (cArqTrab)->SALDOCRD
			nMovSup		:= (cArqTrab)->MOVIMENTO
			cSuperior	:= (cArqTrab)->SUPERIOR
	
			lRet := .F.
			
			While ( (cArqTrab)->( !Eof() ) ) .AND. !lRet
				If (cArqTrab)->(MsSeek(cSuperior) )
					RecLock(cArqTrab,.F.)
					(cArqTrab)->SALDOANT 	+= nSldSupAnt	// Saldo anterior
					(cArqTrab)->SALDOATU 	+= nSldSupAtu	// Saldo Atual
					(cArqTrab)->SALDODEB	+= nSldSupDeb	// Saldo Debito
					(cArqTrab)->SALDOCRD	+= nSldSupCrd	// Saldo Credito
					(cArqTrab)->MOVIMENTO 	+= nMovSup      // Movimento
					MsUnlock()
					cSuperior	:= (cArqTrab)->SUPERIOR
				EndIf
				
				//Verifica se chegou at้ a conta de maior nํvel
				If AllTrim(cSuperior) = ''
					lRet := .T.
				EndIf
			EndDo
	
			//Zera o saldo das contas
			nSldSupAnt 	:= 0	//Saldo anterior
			nSldSupAtu 	:= 0	//Saldo Atual
			nSldSupDeb	:= 0	//Saldo Debito
			nSldSupCrd	:= 0	//Saldo Credito
			nMovSup 	:= 0	//Movimento
			
			dbGoto(nRegSupTmp)
		EndIf
		
		(cArqTrab)->(dbSkip())
		Loop
	EndDo
EndIf

dbSelectArea(cAliasCVD)
dbCloseArea()
dbSelectArea("CVD")

Pergunte("CTR049A",.F.)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหออออออัออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณCTR049OnPrint บAutor ณ Gustavo Henrique บ Data ณ 07/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออออออสออออออฯออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Executa acoes especificadas nos parametros do relatorio,   บฑฑ
ฑฑบ          ณ antes de imprimir cada linha.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ EXPL1 - Indicar se deve saltar linha entre conta sintetica บฑฑ
ฑฑบ          ณ EXPL2 - Indicar se deve quebrar pagina por conta           บฑฑ
ฑฑบ          ณ EXPN3 - Informar o total de linhas por pagina do balancete บฑฑ
ฑฑบ          ณ EXPC4 - Guardar o tipo da conta impressa (sint./analitica) บฑฑ
ฑฑบ          ณ EXPN5 - Guardar linha atual do relatorio para validacao    บฑฑ
ฑฑบ          ณ         com o valor do parametro EXPN3.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ EXPL1 - Indicar se deve imprimir a linha (.T.)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Contabilidade Gerencial                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTR049OnPrint(  nMaxLin, nLinReport,oReport )

Local lRet := .T.

If ! Empty(nMaxLin)
	CTR049MaxL(nMaxLin,@nLinReport,oReport)
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ CTR049MAXL บAutor ณ Eduardo Nunes Cirqueira บ Data ณ  31/01/07 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Baseado no parametro MV_PAR15 ("Num.linhas p/ o Balancete      บฑฑ
ฑฑบ          ณ Modelo 1"), cujo conteudo esta na variavel "nMaxLin", controla บฑฑ
ฑฑบ          ณ a quebra de pagina no TReport                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTR049MaxL(nMaxLin,nLinReport,oReport)

nLinReport++

If nLinReport > nMaxLin
	oReport:EndPage()
	nLinReport := 10
EndIf

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัอออออออออออออออออออออออออหออออออัอออออออออปฑฑ
ฑฑบPrograma  ณ nCtCGCCabTR  บ Autor ณ Fabio Jadao Caires      บ Data ณ 31/01/07บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯอออออออออนฑฑ
ฑฑบDesc.     ณ Chama a funcao padrao CtCGCCabTR reiniciando o contador de      บฑฑ
ฑฑบ          ณ linhas para o controle do relatorio.                            บฑฑ
ฑฑบ          ณ                                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION nCtCGCCabTR(dDataFim,titulo,oReport)

nLinReport := 10

RETURN CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldPlanRefบAutor  ณAlvaro Camillo Neto บ Data ณ  05/31/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo do plano de contas referencial                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function VldPlanRef(cCodPlan)
Local lRet := .T.

If !Empty( AllTrim(cCodPlan) )
	lRet := ExistCpo("CVN",AllTrim(cCodPlan))
	
	If lRet
		cCvdCodPla := AllTrim(cCodPlan)
	Else
		cCvdCodPla := ""
	EndIf
Else
	cCvdCodPla := ""
Endif

Return lRet
