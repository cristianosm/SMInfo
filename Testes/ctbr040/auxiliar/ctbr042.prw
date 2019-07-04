#Include "ctbr042.ch"


// 17/08/2009 -- Filial com mais de 2 caracteres

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ctbr042   ºAutor  ³Renato F. Campos    º Data ³  18/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Balancete de Escrituração                                  º±±
±±º          ³ Impresso somente em modo Grafico (R4) e Paisagem           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ sigactb                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ctbr042()
Private titulo		:= ""
Private nomeprog	:= "CTBR042"
Private oReport		:= Nil
                                                                                     
If ! FindFunction( "TRepInUse" ) .And. TRepInUse() 
	MsgAlert( STR0004 ) // Relatorio Impresso somente em modo grafico
	Return .F.
EndIf

// efetua o ajuste do sx1 para as perguntas do novo relatorio
AjustSx1()

Pergunte( "CTR042" , .T. ) // efetuo o pergunte antes para a definição do modelo a ser impresso 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao (intervalo) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr( "CTR042" )	  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a montagem do relatorio                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()

If Valtype( oReport ) == 'O'

	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf	
	
	oReport:PrintDialog()      
Endif
	
oReport := Nil

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Renato F. Campos    º Data ³  18/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Balancete de Escrituração                                  º±±
±±º          ³ Impresso somente em modo Grafico (R4) e Paisagem           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ sigactb                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
Function ReportDef()
Local aGetArea	   	:= GetArea()   
Local cReport		:= "CTBR042"
Local cDesc			:= OemToAnsi(STR0001) + OemToAnsi(STR0002) + OemToAnsi(STR0003)
Local cPerg	   		:= "CTR042" 
Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Local nDecimais
Local cMascara		:= ""
Local cSeparador	:= ""
Local aSetOfBook

cTitulo	:= STR0003

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua a pergunta antes de montar a configuração do      ³
//³ relatorio, afim de poder definir o layout a ser impresso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( "CTR042" , .F. )
      
makesqlexpr("CTR042")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! Ct040Valid( mv_par07 )
	Return .F.
Else
   aSetOfBook := CTBSetOf( mv_par07 )
Endif
                                                                          
cMascara := RetMasCtb( aSetOfBook[2], @cSeparador )

cPicture := aSetOfBook[4]

oReport	 := TReport():New( cReport,Capital( cTitulo ),cPerg, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, cDesc )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apos a definicao do relatorio, nao sera possivel alterar |
//| os parametros.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:ParamReadOnly()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Relatorio impresso somente em modo paisagem              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetLandScape(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da estrutura do relatorio                       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1  := TRSection():New( oReport, STR0004, { "cArqTmp" , "CT1" } ,, .F., .F. ) //"Plano de contas"

TRCell():New( oSection1, "CONTA"      ,,STR0007							 /*Titulo*/	,/*Picture*/, 20/*Tamanho*/, /*lPixel*/, /*CodeBlock*/)
TRCell():New( oSection1, "DESCCTA"    ,,STR0008							 /*Titulo*/	,/*Picture*/, 40/*Tamanho*/, /*lPixel*/, /*CodeBlock*/)
TRCell():New( oSection1, "SALDODEB"   ,,STR0009+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOCRD"   ,,STR0009+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOANTDB" ,,STR0010+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOANTCR" ,,STR0010+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOATUDB" ,,STR0011+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOATUCR" ,,STR0011+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "MOVIMENTOD" ,,STR0012+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "MOVIMENTOC" ,,STR0012+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
                                                                                 
TRPosition():New( oSection1, "CT1", 1, {|| xFilial( "CT1" ) + cArqTMP->CONTA })

oSection1:SetTotalInLine(.T.)          
oSection1:SetTotalText( '' )

Return( oReport )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³Renato F. Campos   º Data ³  18/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a impressao do relatorio							  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaCTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint( oReport )
Local oSection1 	:= oReport:Section(1) 
Local aSetOfBook
Local dDataFim 		:= mv_par02
Local lRet			:= .T.
Local lPrintZero	:= (mv_par14==1)
Local lPula			:= (mv_par13==1) 
Local lNormal		:= .T.
Local lVlrZerado	:= (mv_par08==1)
Local lQbGrupo		:= (mv_par11==1) 
Local lQbConta		:= (mv_par11==2)
Local nDecimais
Local nDivide		:= 1
Local lImpAntLP		:= (mv_par16 == 1)
Local dDataLP		:= mv_par17
Local lImpSint		:= Iif(mv_par06=1 .Or. mv_par06 ==3,.T.,.F.)
Local lRecDesp0		:= (mv_par18 == 1)
Local cRecDesp		:= mv_par19
Local dDtZeraRD		:= mv_par20
Local oMeter
Local oText
Local oDlg
Local aCtbMoeda		:= {}
Local cArqTmp		:= ""
Local cSeparador	:= ""
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local cPicture
Local nCont			:= 0
Local cFilUser		:= ""
Local cRngFil	 // range de filiais para a impressão do relatorio
Local dDtCorte	 	:= mv_par03 //If ( cPaisLoc == "PTG" , mv_par03 , CTOD("  /  /  ") ) // data de corte - usado em Portugal

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratativa para os parametros que irão funcionar somente para ³
//³ TOPCONN                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF TOP
	cRngFil	   		:= xFilial( "CT7" )
	dDtCorte	 	:= CTOD("  /  /  ")
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! ct040Valid( mv_par07 )
	Return .F.
Else
   aSetOfBook := CTBSetOf(mv_par07)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validação das moedas do CTB                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCtbMoeda := CtbMoeda( mv_par09 , nDivide )

If Empty(aCtbMoeda[1])                       
	Help(" ",1,"NOMOEDA")
	Return .F.
Endif

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par09)

If Empty( aSetOfBook[2] )
	cMascara := GetMv( "MV_MASCARA" )
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta o numero da pagina                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetPageNumber( mv_par12 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo += 	STR0003 + STR0005 + DTOC(MV_PAR01) +;	// "DE"
			STR0006 + DTOC(MV_PAR02) + " " + CtbTitSaldo(mv_par10)	+ " " + cDescMoeda // "ATE"

oReport:SetTitle(Titulo)

oReport:SetCustomText( {|| CtCGCCabTR(,,,,,MV_PAR02,oReport:Title(),,,,,oReport) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilUser := oSection1:GetAdvplExpr( "CT1" )

If Empty(cFilUser)
	cFilUser := ".T."
EndIf	

MakeSqlExpr( "CTR042" )	  
cRngFil		:= mv_par21

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao			  		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			CTGerPlan(	oMeter, oText, oDlg, @lEnd,@cArqTmp,mv_par01,mv_par02,"CT7","",mv_par04,;
						mv_par05,,,,,,,mv_par09,mv_par10,aSetOfBook,,,,,;
						.F.,.F.,mv_par12,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
						cRecDesp,dDtZeraRD,,,,,,,,,cRngFil,dDtCorte)},;
						OemToAnsi(OemToAnsi(STR0020)),;//"Criando Arquivo Tempor rio..."
						OemToAnsi(STR0004))  			//"Balancete de Escrituração"
                
nCount := cArqTmp->( RecCount() )

oReport:SetMeter( nCont )

lRet := !( nCount == 0 .And. !Empty(aSetOfBook[5]))

If lRet
	cArqTmp->(dbGoTop())
	
	// define se ao imprimir uma linha a proxima é pulada
	oSection1:OnPrintLine( {|| IIf( lPula , oReport:SkipLine(),NIL) } )
	
	If lNormal
		oSection1:Cell("CONTA"):SetBlock( {|| EntidadeCTB(cArqTmp->CONTA,000,000,030,.F.,cMascara,cSeparador,,,.F.,,.F.)} )
	Else
		oSection1:Cell("CONTA"):SetBlock( {|| cArqTmp->CTARES } )
	EndIf	
	
	oSection1:Cell("DESCCTA"):SetBlock( { || cArqTMp->DESCCTA } )
	
	oSection1:Cell("SALDODEB"  ):SetBlock( { || ValorCTB(cArqTmp->SALDODEB  ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOCRD"  ):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD  ,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOANTDB"):SetBlock( { || ValorCTB(cArqTmp->SALDOANTDB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOANTCR"):SetBlock( { || ValorCTB(cArqTmp->SALDOANTCR,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATUDB"):SetBlock( { || ValorCTB(cArqTmp->SALDOATUDB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATUCR"):SetBlock( { || ValorCTB(cArqTmp->SALDOATUCR,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("MOVIMENTOD"):SetBlock( { || ValorCTB(IIF( (cArqTmp->SALDOATUDB - cArqTmp->SALDOATUCR) > 0 , cArqTmp->SALDOATUDB - cArqTmp->SALDOATUCR,0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("MOVIMENTOC"):SetBlock( { || ValorCTB(IIF( (cArqTmp->SALDOATUDB - cArqTmp->SALDOATUCR) < 0 , cArqTmp->SALDOATUDB - cArqTmp->SALDOATUCR,0 ),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )


	oSection1:Print()
EndIf

dbSelectArea( "cArqTmp" )
Set Filter TO
dbCloseArea()

If Select( "cArqTmp" ) == 0
	FErase( cArqTmp + GetDBExtension())
	FErase( cArqTmp + OrdBagExt())
EndIF	

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSx1 ºAutor  ³Renato F. Campos    º Data ³  05/18/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria os perguntes do relatorio                              º±±
±±º          ³Apos o termino do relatorio, adaptar ao ctbxfuna            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ctbr042                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function AjustSx1()
Local aPergs 	:= {}    
Local aHelpPor	:= {} 
Local aHelpEng	:= {}	
Local aHelpSpa	:= {}

Aadd(aHelpPor,"")			
Aadd(aHelpEng,"")
Aadd(aHelpSpa,"")

aadd(aPergs,{"Data Inicial ?"					,	"¿Fecha Inicial ?"				,	"Initial Date ?"				,	"mv_ch1",	"D",	8	,0	,0	,"G",,	"mv_par01",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Data Final ?"						,	"¿Fecha Final ?"				,	"Final Date ?"					,	"mv_ch2",	"D",	8	,0	,0	,"G",,	"mv_par02",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Data de calculo de saldo?"		,	"¿Fecha del calculo de saldos?"	,	"Math Balances Date ?"			,	"mv_ch3",	"D",	8	,0	,0	,"G",,	"mv_par03",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Conta Inicial ?"					,	"¿De Cuenta ?"					,	"Initial Account ?"				,	"mv_ch4",	"C",	20	,0	,0	,"G",,	"mv_par04",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","","CT1"	,"003"	,"S"})
aadd(aPergs,{"Conta Final ?"					,	"¿A Cuenta ?"					,	"Final Account ?"				,	"mv_ch5",	"C",	20	,0	,0	,"G",,	"mv_par05",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","","CT1"	,"003"	,"S"})
aadd(aPergs,{"Imprime Contas ?"					,	"¿Imprime Cuentas ?"			,	"Print Accounts ?"				,	"mv_ch6",	"N",	1	,0	,3	,"C",,	"mv_par06",	"Sinteticas"	,"Sinteticas"		,"Summarized"		,""			,""			,"Analiticas"		,"Analiticas"		,"Detailed"			,""			,""					,"Ambas"		,"Ambas"		,"Both"			,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Cod. Config. Livros ?"			,	"¿Cod Config Libros ?"			,	"T.Recs.Conf.Code ?"			,	"mv_ch7",	"C",	3	,0	,0	,"G",,	"mv_par07",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","","CTN"	,""		,"S"})
aadd(aPergs,{"Saldos Zerados ?"					,	"¿Saldos en Cero ?"				,	"Balances Zeroed ?"				,	"mv_ch8",	"N",	1	,0	,1	,"C",,	"mv_par08",	"Sim"			,"Si"				,"Yes"			 	,""		 	,""			,"Nao"				,"No"				,"No"				,""		 	,""					,""				,""				,""				,""		 	,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Moeda ?"							,	"¿Moneda ?"						,	"Currency ?"					,	"mv_ch9",	"C",	2	,0	,0	,"G",,	"mv_par09",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","","CTO"	,""		,"S"})
aadd(aPergs,{"Tipo de Saldo ?"					,	"¿Tipo de Saldo ?"				,	"Balance Type ?"				,	"mv_cha",	"C",	1	,0	,1	,"G",,	"mv_par10",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","","SLD"	,""		,"S"})
aadd(aPergs,{"Quebra por Grupo ?"				,	"¿Divide por Grupo ?"			,	"Skip by Group ?"				,	"mv_chb",	"N",	1	,0	,2	,"C",,	"mv_par11",	"por Grupo"		,"por Grupo"		,"by group"		 	,""		 	,""			,"por Código"		,"por Codigo"		,"by code"			,""		 	,""					,"Não Quebra"	,"No Divide"	,"Do not break"	,""		 	,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Folha  Inicial ?"					,	"¿Pagina Inicial ?"				,	"Initial Page ?"				,	"mv_chc",	"N",	6	,0	,0	,"G",,	"mv_par12",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Salta Linha Sintet. ?"			,	"¿Salta Linea Sintetic ?"		,	"Skip Summ.Line ?"				,	"mv_chd",	"N",	1	,0	,1	,"C",,	"mv_par13",	"Sim"			,"Si"				,"Yes"			 	,""		 	,""			,"Nao"				,"No"				,"No"				,""		 	,""					,""				,""				,""				,""		 	,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Imprime Valor 0.00 ?"				,	"¿Imprime Valor 0.00 ?"			,	"Print Value 0.00 ?"			,	"mv_che",	"N",	1	,0	,1	,"C",,	"mv_par14",	"Sim"			,"Si"				,"Yes"			 	,""		 	,""			,"Nao"				,"No"				,"No"				,""		 	,""					,""				,""				,""				,""		 	,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Imprime Codigo ?"					,	"¿Imprime Codigo ?"				,	"Print Code ?"					,	"mv_chf",	"N",	1	,0	,1	,"C",,	"mv_par15",	"Normal"		,"Normal"			,"Normal"			,""			,""			,"Reduzido"			,"Reducido"			,"Reduced"			,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Posicao Ant. L/P ?"				,	"¿Situacion Anterior Gan/Per ?"	,	"P/L Previous Status ?"			,	"mv_chg",	"N",	1	,0	,2	,"C",,	"mv_par16",	"Sim"			,"Si"				,"Yes"			 	,""		 	,""			,"Nao"				,"No"				,"No"				,""		 	,""					,""				,""				,""				,""		 	,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"N"})
aadd(aPergs,{"Data Lucros/Perdas ?"				,	"¿Fecha Ganancias/ Perdidas ?"	,	"Profit/Losses Date ?"			,	"mv_chh",	"D",	8	,0	,0	,"G",,	"mv_par17",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","","CTZ"	,""		,"N"})
aadd(aPergs,{"Ignora Sl Ant.Rec/Des ?"			,	"¿Ignora Sl Ant.Ing/Gas ?"		,	"Ignore Revenue/Exps Prev Bal ?",	"mv_chi",	"N",	1	,0	,0	,"C",,	"mv_par18",	"Sim"			,"Si"				,"Yes"			 	,""		 	,""			,"Nao"				,"No"				,"No"				,""		 	,""					,""				,""				,""				,""		 	,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Grupos Receitas/Despesas ?"		,	"¿Grupos Ingresos/Gastos ?"		,	"Revenues/Expenses Groups ?	"	,	"mv_chj",	"C",	9	,0	,0	,"G",,	"mv_par19",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})
aadd(aPergs,{"Data Sld Ant. Receitas/Desp. ?"	,	"¿Fcha Sld Ant. Ingresos/Gast."	,	"Revenues/Exps Prev Bal Dt. ?"	,	"mv_chk",	"D",	8	,0	,0	,"G",,	"mv_par20",	""				,""					,""					,""			,""			,""					,""					,""					,""			,""					,""				,""				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})

#IFDEF TOP        
	Aadd(aPergs,{"Filial  ?" , "Filial ?" , "subsidiary  ?" ,"mv_chl","C",99,0,1,"R",,"mv_par21","","","","CT7_FILIAL","","","","","CT7_FILIAL","","","","","CT7_FILIAL","","","","","","","","","","","","XM0","S",""})	
#ENDIF      

AjustaSx1( "CTR042" , aPergs )                                                                                                                                         
                                                             
return

/*  
Modelo do relatorio a ser impresso                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             e
+---------------------------------------------------+-----------------------------+-----------------------------------------------------------+-----------------------------+
|                                                   |           Diário            |                             Razão                         |          Balancete          |
|                                                   +-----------------------------+-----------------------------+-----------------------------+-----------------------------+
|                                                   |       Movimento do Mês      |      Movimento Anterior     |     Movimento Geral         |           Saldos            |
+--------------------+------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+
|    Cod. Conta      |    Descrição da Conta        |   Débito     |   Crédito    |    Débito    |   Crédito    |   Débito     |   Crédito    |   Débito     |   Crédito    |
+--------------------+------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+
|x.x.x.xxx.xxxx      |Descrição da Conta x          |         0,00 |         0,00 |         0,00 |         0,00 |         0,00 |         0,00 |         0,00 |         0,00 |
+--------------------+------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+
|x.x.x.xxx.xxxx      |Descrição da Conta x          |    100000,00 |    100000,00 |       500,00 |         0,00 |    100500,00 |    100000,00 |       500,00 |         0,00 |
+--------------------+------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+
|Conta		20   	 |Descricao   40   				|Debito      14|Credito     14|Debito      14|Credito     14|Debito      14|Credito     14|Debito      14|Credito     14|
+--------------------+------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+
*/
