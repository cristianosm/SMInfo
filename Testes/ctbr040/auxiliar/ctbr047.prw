#Include "ctbr047.ch"


// 17/08/2009 -- Filial com mais de 2 caracteres

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ctbr047   ºAutor  ³Patricia Ikari      º Data ³  18/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Balancete de Verificacao                                   º±±
±±º          ³ Impresso somente em modo Grafico (R4) e Paisagem           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ sigactb                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ctbr047()
Private titulo		:= ""
Private nomeprog	:= "CTBR047"
Private oReport		:= Nil
Private aSelFil		:= {}
                                                                                     
If ! FindFunction( "TRepInUse" ) .And. TRepInUse() 
	MsgAlert( STR0004 ) // Relatorio Impresso somente em modo grafico
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao (intervalo) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr( "CTR047" )	  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a montagem do relatorio                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDf()

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
±±ºPrograma  ³ReportDf  ºAutor  ³Patricia Ikari      º Data ³  18/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Balancete de Verificacao                                   º±±
±±º          ³ Impresso somente em modo Grafico (R4) e Paisagem           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ sigactb                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
Function ReportDf()
Local aGetArea	   	:= GetArea()   
Local cReport		:= "CTBR047"
Local cDesc			:= OemToAnsi(STR0001) + OemToAnsi(STR0002) + OemToAnsi(STR0003)
Local cPerg	   		:= "CTR047" 
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
Pergunte( "CTR047" , .f. )
makesqlexpr("CTR047")
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
//oReport:ParamReadOnly()

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
TRCell():New( oSection1, "SALDOANTDB" ,,STR0009+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOANTCR" ,,STR0009+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDODEB"   ,,STR0010+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOCRD"   ,,STR0010+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")    
TRCell():New( oSection1, "SALDOATUDB" ,,STR0011+Chr(13)+Chr(10)+STR0013/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOATUCR" ,,STR0011+Chr(13)+Chr(10)+STR0014/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOBALAC" ,,STR0021+Chr(13)+Chr(10)+STR0023/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOBALPA" ,,STR0021+Chr(13)+Chr(10)+STR0024/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOFUCPE" ,,STR0022+Chr(13)+Chr(10)+STR0025/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection1, "SALDOFUCGA" ,,STR0022+Chr(13)+Chr(10)+STR0026/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")

oSection2  := TRSection():New( oReport, STR0021, { "" } ,, .F., .F. ) //

TRCell():New( oSection2, "TOTAL"     ,,/*Titulo*/	,/*Picture*/, 58/*Tamanho*/, /*lPixel*/, {|| STR0015}/*CodeBlock*/)
TRCell():New( oSection2, "SOMAANTDB" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMAANTCR" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMADEB"   ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMACRD"   ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMAATUDB" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMAATUCR" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMABALAC" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMABALPA" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMAFUCPE" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection2, "SOMAFUCGA" ,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
oSection2:SetHeaderSection(.F.)

oSection3  := TRSection():New( oReport, STR0021, { "" } ,, .F., .F. ) //

TRCell():New( oSection3, "RESULTADO"   ,,/*Titulo*/		,/*Picture*/, 58/*Tamanho*/, /*lPixel*/, {|| STR0016}/*CodeBlock*/)
TRCell():New( oSection3, "INIBIR1" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR2" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR3" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR4" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR5" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR6" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "RESULAT" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR9" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "INIBIR0" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection3, "RESULGA" 		,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")

oSection3:SetHeaderSection(.F.)
oSection3:Cell("INIBIR1"):hide()
oSection3:Cell("INIBIR2"):hide()
oSection3:Cell("INIBIR3"):hide()
oSection3:Cell("INIBIR4"):hide()
oSection3:Cell("INIBIR5"):hide()
oSection3:Cell("INIBIR6"):hide()
oSection3:Cell("INIBIR9"):hide()
oSection3:Cell("INIBIR0"):hide()

oSection4  := TRSection():New( oReport, STR0021, { "" } ,, .F., .F. ) //

TRCell():New( oSection4, "TOTAL" 	,,/*Titulo*/	,/*Picture*/, 58/*Tamanho*/, /*lPixel*/, {|| STR0015}/*CodeBlock*/) 
TRCell():New( oSection4, "INIBIR1" 	,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "INIBIR2" 	,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "INIBIR3" 	,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "INIBIR4" 	,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "INIBIR5" 	,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "INIBIR6" 	,,/*Titulo*/	,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "TOTALAT" ,,/*Titulo*/		,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "TOTALPA" ,,/*Titulo*/		,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "TOTALPE" ,,/*Titulo*/		,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
TRCell():New( oSection4, "TOTALGA" ,,/*Titulo*/		,/*Picture*/, 17/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"CENTER")
oSection4:SetHeaderSection(.F.)
oSection4:Cell("INIBIR1"):hide()
oSection4:Cell("INIBIR2"):hide()
oSection4:Cell("INIBIR3"):hide()
oSection4:Cell("INIBIR4"):hide()
oSection4:Cell("INIBIR5"):hide()
oSection4:Cell("INIBIR6"):hide()
                                                                            
TRPosition():New( oSection1, "CT1", 1, {|| xFilial( "CT1" ) + cArqTMP->CONTA })

oSection1:SetTotalInLine(.F.)          
oSection1:SetTotalText( '' )

Return( oReport )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ReportPrintºAutor  ³Patricia Ikari     º Data ³  18/05/08   º±±
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
Local oSection2 	:= oReport:Section(2) 
Local oSection3 	:= oReport:Section(3) 
Local oSection4 	:= oReport:Section(4) 
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
Local nSomaAntDB	:= 0
Local nSomaAntCR	:= 0
Local nSomaDB		:= 0
Local nSomaCR		:= 0
Local nSomaAtuDB	:= 0
Local nSomaAtuCR	:= 0  
Local nSomaBalAc	:= 0
Local nSomaBalPa	:= 0
Local nSomaFucPe	:= 0
Local nSomaFucGa	:= 0
Local nResulAt      := 0
Local nResulGa      := 0
Local nTotalAt      := 0
Local nTotalPa      := 0
Local nTotalPe      := 0
Local nTotalGa      := 0

If mv_par21 == 1 .And. Len( aSelFil ) <= 0  .And. !IsBlind()
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		Return
	EndIf 
EndIf

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
If cPaisLoc == "PER"
	Titulo += 	STR0027
Else
	Titulo += 	STR0003 + STR0005 + DTOC(MV_PAR01) +;	// "DE"
				STR0006 + DTOC(MV_PAR02) + " " + CtbTitSaldo(mv_par10)	+ " " + cDescMoeda // "ATE"  
EndIf

oReport:SetTitle(Titulo)

oReport:SetCustomText( {|| CtCGCCabTR(,,,,,MV_PAR02,oReport:Title(),,,,,oReport) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilUser := oSection1:GetAdvplExpr( "CT1" )

If Empty(cFilUser)
	cFilUser := ".T."
EndIf	

MakeSqlExpr( "CTR047" )	  
cRngFil		:= mv_par21

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao			  		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			CTGerPlan(	oMeter, oText, oDlg, @lEnd,@cArqTmp,mv_par01,mv_par02,"CT7","",mv_par04,;
						mv_par05,,,,,,,mv_par09,mv_par10,aSetOfBook,,,,,;
						.F.,.F.,mv_par12,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
						cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,dDtCorte)},;
						OemToAnsi(OemToAnsi(STR0003)),;//"Criando Arquivo Tempor rio..."
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
	
	oSection1:Cell("SALDOANTDB"):SetBlock( { || ValorCTB(cArqTmp->SALDOANTDB  ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOANTCR"):SetBlock( { || ValorCTB(cArqTmp->SALDOANTCR  ,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDODEB")  :SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOCRD")  :SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATUDB"):SetBlock( { || ValorCTB(cArqTmp->SALDOATUDB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATUCR"):SetBlock( { || ValorCTB(cArqTmp->SALDOATUCR,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
   	oSection1:Cell("SALDOBALAC"):SetBlock( { || ValorCTB(IIF( cArqTmp->NATCTA == '01' , cArqTmp->SALDOATUDB ,0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
    oSection1:Cell("SALDOBALPA"):SetBlock( { || ValorCTB(IIF( cArqTmp->NATCTA == '02' , cArqTmp->SALDOATUCR ,0 ),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
    oSection1:Cell("SALDOFUCPE"):SetBlock( { || ValorCTB(IIF( cArqTmp->NATCTA == '05' , cArqTmp->SALDOATUDB ,0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOFUCGA"):SetBlock( { || ValorCTB(IIF( cArqTmp->NATCTA == '04' , cArqTmp->SALDOATUCR ,0 ),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
    
	oSection2:Cell("SOMAANTDB"):SetBlock( { || ValorCTB(nSomaAntDB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMAANTCR"):SetBlock( { || ValorCTB(nSomaAntCR,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMADEB"  ):SetBlock( { || ValorCTB(nSomaDB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMACRD"  ):SetBlock( { || ValorCTB(nSomaCR,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMAATUDB"):SetBlock( { || ValorCTB(nSomaAtuDB ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMAATUCR"):SetBlock( { || ValorCTB(nSomaAtuCR,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMABALAC"):SetBlock( { || ValorCTB(nSomaBalAc,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMABALPA"):SetBlock( { || ValorCTB(nSomaBalPa,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMAFUCPE"):SetBlock( { || ValorCTB(nSomaFucPe ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SOMAFUCGA"):SetBlock( { || ValorCTB(nSomaFucGa,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )

    oSection3:Cell("RESULAT"):SetBlock( { || ValorCTB(nResulAt ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
    oSection3:Cell("RESULGA"):SetBlock( { || ValorCTB(nResulGa,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	
	oSection4:Cell("TOTALAT"):SetBlock( { || ValorCTB(nTotalAt ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
    oSection4:Cell("TOTALPA"):SetBlock( { || ValorCTB(nTotalPa,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
    oSection4:Cell("TOTALPE"):SetBlock( { || ValorCTB(nTotalPe ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
    oSection4:Cell("TOTALGA"):SetBlock( { || ValorCTB(nTotalGa,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
    
    
   //	oSection1:Print()
   
   oSection1:Init()
                            
	cArqTmp->(dbGoTop()) 
	
	While cArqTmp->(!Eof())
	
		If (lImpSint .AND. cArqTmp->NIVEL1) .OR. (!lImpSint .AND. cArqTmp->TIPOCONTA == "2")
			nSomaAntDB	+= cArqTmp->SALDOANTDB
			nSomaAntCR	+= cArqTmp->SALDOANTCR
			nSomaDB 	+= cArqTmp->SALDODEB
			nSomaCR		+= cArqTmp->SALDOCRD 
		    nSomaAtuDB	+= cArqTmp->SALDOATUDB
			nSomaAtuCR	+= cArqTmp->SALDOATUCR
			
			If cArqTmp->NATCTA == '01'
				nSomaBalAc += cArqTmp->SALDOATUDB
	        Endif
        
		 	If cArqTmp->NATCTA == '02'  
		 		nSomaBalPa += cArqTmp->SALDOATUCR
		 	Endif
		 	
		 	If cArqTmp->NATCTA == '05'
				nSomaFucPe += cArqTmp->SALDOATUDB
	        Endif
        
		 	If cArqTmp->NATCTA == '04'  
		 		nSomaFucGa += cArqTmp->SALDOATUCR
		 	Endif
		 	
		Endif
		
		oSection1:PrintLine()
		
		cArqTmp->(dbSkip())  
		
	EndDo
	
	oSection1:Finish() 
	
	oSection2:Init()
	oReport:SkipLine()   
	
	nResulAt := nSomaBalPa - nSomaBalAc
	nResulGa := nSomaFucPe - nSomaFucGa
	
	oSection2:PrintLine()
	oSection2:Finish()
	
	oSection3:Init()
	oReport:SkipLine()    
	
	nTotalAt := nSomaBalAc + nResulAt
	nTotalPa := nSomaBalPa
	nTotalPe := nSomaFucPe
	nTotalGa := nSomaFucGa + nResulGa 
	
	oSection3:PrintLine()
	oSection3:Finish()
	
	oSection4:Init()
	oReport:SkipLine()
	oSection4:PrintLine()
	oSection4:Finish()
EndIf                                                   

dbSelectArea( "cArqTmp" )
Set Filter TO
dbCloseArea()

If Select( "cArqTmp" ) == 0
	FErase( cArqTmp + GetDBExtension())
	FErase( cArqTmp + OrdBagExt())
EndIF	

Return .T.



