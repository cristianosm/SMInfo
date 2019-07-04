#Include "CTBR160.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR	17


// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr160	³ Autor ³ Cicero J. Silva	    ³ Data ³ 02.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balanco Geral Modelo 2				 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR160(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum        											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum         											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr160C(wnRel)

Local oReport

Local aArea := GetArea()
Local lOk := .T.

// Externo
If wnRel <> Nil
	U_Ctbr160R3(wnRel) // Executa versão anterior do fonteEndif
Else
	If TRepInUse()
		If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
			lOk := .F.
		EndIf
		If lOk
			oReport := ReportDef("CTR160")
			oReport:PrintDialog()
		EndIf
	Else
		U_Ctbr160R3(wnRel) // Executa versão anterior do fonte
	Endif
EndIf

//Limpa os arquivos temporários 
CTBGerClean()
	
RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Cicero J. Silva    º Data ³  07/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda  - Matriz ref. a moeda                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef(cPerg)

Local oReport
Local oTotais                                               

Local cDesc1		:= STR0001	//"Este programa ira imprimir o Balanco Geral Modelo 1 (132) Colunas."
Local cDesc2		:= STR0002	//"A conta eh impressa limitando-se a 30 caracteres e sua descricao 40 caracteres,"
Local cDesc3		:= STR0003	//"sao tambem impressos colunas do saldo a debito e a credito do periodo."

Local aTamConta		:= TamSX3("CT1_CONTA")
Local aTamCtaRes	:= TamSX3("CT1_RES")

oReport := TReport():New("CTBR160",STR0004,cPerg,{|oReport| Pergunte(cPerg,.F.),;
						Iif( ReportPrint(oReport), .T., oReport:CancelPrint() ) },cDesc1+cDesc2+cDesc3)
		
oReport:SetLandscape(.T.)

// Sessao 1
oPlcontas := TRSection():New(oReport,STR0004,{"cArqTmp","CT1"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	// "Balanco Geral"
oPlcontas:SetTotalInLine(.F.)

TRCell():New(oPlcontas,"CONTA"  , "cArqTmp"	, STR0023,/*Picture*/,aTamConta[1],/*lPixel*/,/*{|| code-block de impressao }*/)	// "C O N T A"
TRCell():New(oPlcontas,"DESCCTA", "cArqTmp"	, STR0024,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)	// "D E N O M I N A C A O"
TRCell():New(oPlcontas,"COL_DEB", ""		, STR0029+CRLF+STR0026,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// "D E B I T O"
TRCell():New(oPlcontas,"COL_CRD", ""		, STR0029+CRLF+STR0027,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// "C R E D I T O"

oTotais := TRSection():New( oReport,STR0028,,, .F., .F. )	// "Totais"
TRCell():New( oTotais, "TOT",, STR0024,/*Picture*/,61,/*lPixel*/,/*{|| code-block de impressao }*/)	//"D E N O M I N A C A O"
TRCell():New( oTotais, "TOT_DEBITO"	,, STR0026,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	//"D E B I T O"
TRCell():New( oTotais, "TOT_CREDITO",, STR0027,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	//"C R E D I T O"

Return oReport				 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintº Autor ³ Cicero J. Silva    º Data ³  14/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function	ReportPrint(oReport)

Local oPlcontas		:= oReport:Section(1)
Local oTotais		:= oReport:Section(2)

Local aSetOfBook	:= CTBSetOf(mv_par06)
Local aCtbMoeda		:= {}

Local cArqTmp		:=	""
LOCAL limite		:= 132
Local lImpLivro		:=.T.
Local lImpTermos	:=.F.
Local lImpAntLP		:= (mv_par21 == 1)
Local dDataLP		:= mv_par22
Local lVlrZerado	:= (mv_par07 == 1)
Local lImpSint		:= (mv_par05=1 .Or. mv_par05 ==3)
Local lTotGSint		:= (mv_par24 == 2)	//Define se ira imprimir o total geral pelas contas analiticas ou sinteticas
Local lPrintZero	:= (mv_par17 == 1)
Local cSegAte   	:= mv_par20
Local dDataFim 		:= mv_par02
Local lImpRes		:= (mv_par18 # 1)
Local lPula			:= (mv_par16 == 1) 

Local nDivide		:= 1
Local nDigitAte		:= 0
Local cFiltro		:= oPlcontas:GetAdvplExp()
Local cSepara		:= ""
Local cDescMoeda 	:= ""
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)
Local cMascara		:= IIf(Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSepara))
Local cPicture 		:= aSetOfBook[4]

Local nGrpDeb 		:= 0
Local nTotDeb 		:= 0
Local nGrpCrd 		:= 0
Local nTotCrd 		:= 0              
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+mv_par08))
Local lColDbCr 		:= IIf(cPaisLoc $ "RUS",.T.,.F.) // Disconsider cTipo in ValorCTB function, setting cTipo to empty
Local lRedStorn		:= IIf(cPaisLoc $ "RUS",SuperGetMV("MV_REDSTOR",.F.,.F.),.F.)

Private cTipoAnt	:= ""
Private nomeprog	:= "CTBR160"

If mv_par19 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par19 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par19 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par06)
	Return .F.
EndIf 

aCtbMoeda := CtbMoeda(mv_par08,nDivide)
If Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	Return .F.
Endif
                          
cDescMoeda := aCtbMoeda[2]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par05 == 1
	titulo:=	OemToAnsi(STR0009)	//"BALANCO GERAL SINTETICO DE "
ElseIf mv_par05 == 2
	titulo:=	OemToAnsi(STR0010)	//"BALANCO GERAL ANALITICO DE "
ElseIf mv_par05 == 3
	titulo:=	OemToAnsi(STR0011)	//"BALANCO GERAL DE "
EndIf

titulo += 	DTOC(mv_par01) + OemToAnsi(STR0012) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0013) + cDescMoeda + CtbTitSaldo(mv_par10)

oReport:SetCustomText( { || CtCGCCabTR(,,,,,dDataBase,titulo,,,,,oReport) } )

oReport:SetPageNumber(mv_par09) //mv_par08	-	Pagina Inicial

#IFNDEF TOP
	If !Empty(cFiltro)
		CT1->( dbSetFilter( { || &cFiltro }, cFiltro ) )
	EndIf
#ENDIF

If lImpRes 
	oPlContas:Cell("CONTA"):SetBlock( { || EntidadeCTB(cArqTmp->(Iif(TIPOCONTA=="2",CTARES,CONTA)),0,0,70,.F.,cMascara,cSepara,,,,,.F.) } )
Else
	oPlContas:Cell("CONTA"):SetBlock( { || EntidadeCTB(cArqTmp->CONTA,0,0,70,.F.,cMascara,cSepara,,,,,.F.) } )
EndIf	

If lRedStorn
	oPlContas:Cell("COL_DEB"):SetBlock({|| ValorCTB(Iif(cArqTmp->NORMAL=="1",cArqTmp->SALDOATUDB - cArqTmp->SALDOATUCR,0),,,TAM_VALOR,nDecimais,.F.,cPicture," ",,,,,,lPrintZero,.F.,lColDbCr) })
	oPlContas:Cell("COL_CRD"):SetBlock({|| ValorCTB(Iif(cArqTmp->NORMAL=="2",cArqTmp->SALDOATUCR - cArqTmp->SALDOATUDB,0),,,TAM_VALOR,nDecimais,.F.,cPicture," ",,,,,,lPrintZero,.F.,lColDbCr) })
Else
	oPlContas:Cell("COL_DEB"):SetBlock({|| ValorCTB(IIF( cArqTmp->(SALDOATUCR - SALDOATUDB) < 0,ABS(cArqTmp->(SALDOATUCR - SALDOATUDB)),0),,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->TIPOCONTA,,,,,,lPrintZero,.F.,lColDbCr) })
	oPlContas:Cell("COL_CRD"):SetBlock({|| ValorCTB(IIF( cArqTmp->(SALDOATUCR - SALDOATUDB) > 0,ABS(cArqTmp->(SALDOATUCR - SALDOATUDB)),0),,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->TIPOCONTA,,,,,,lPrintZero,.F.,lColDbCr) })
Endif	
oPlContas:Cell("DESCCTA"):SetSize(nTamCta)

oPlcontas:OnPrintLine( {|| ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")),oReport:SkipLine(),NIL),;//Salta linha sintetica ?
								 cTipoAnt := cArqTmp->TIPOCONTA	)  })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par23==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par23==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par23==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase

If lImpLivro
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
			  mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
				  .F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFiltro )},;	
					OemToAnsi(OemToAnsi(STR0016)),;  //"Criando Arquivo Tempor rio..."
					  OemToAnsi(STR0004))  				//"Balanco Geral"				
		   
	oReport:NoUserFilter()
						
	dbSelectArea("cArqTmp")
	dbGoTop()

	cGrupoAnt := AllTrim(cArqTmp->GRUPO)
	
	oReport:SetMeter( RecCount() )
	oPlcontas:Init()
	
	// Verifica Se existe filtragem Ate o Segmento
	If !Empty(cSegAte)
		nDigitAte := CtbRelDig(cSegAte,cMascara) 	
	EndIf		
	
	
    Do While !Eof() .And. !oReport:Cancel()
    
        If oReport:Cancel()
	    	Exit
    	EndIf      

	    oReport:IncMeter() 

		If R160Fil(cSegAte, nDigitAte,cMascara)
			dbSkip()
			Loop
		EndIf

    	oPlcontas:Printline()

		If lRedStorn
			nTotDeb += f160RSsum("D",cSegAte,lTotGSint)
			nGrpDeb += f160RSsum("D",cSegAte,lTotGSint)
			nTotCrd += f160RSsum("C",cSegAte,lTotGSint)
			nGrpCrd += f160RSsum("C",cSegAte,lTotGSint)
		Else
			nTotDeb += f160Soma("D",cSegAte,lTotGSint)
			nGrpDeb += f160Soma("D",cSegAte,lTotGSint)
			nTotCrd += f160Soma("C",cSegAte,lTotGSint)
			nGrpCrd += f160Soma("C",cSegAte,lTotGSint)
		Endif
		
    	dbSkip()

   		If mv_par11 == 1 // mv_par11 - Quebra por Grupo Contabil? 
			If cGrupoAnt <> AllTrim(cArqTmp->GRUPO)

				oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0021) + cGrupoAnt + " )")
				oTotais:Cell( "TOT_DEBITO"	):SetBlock( { || ValorCTB(nGrpDeb,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr) } )
				oTotais:Cell( "TOT_CREDITO"	):SetBlock( { || ValorCTB(nGrpCrd,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr) } )

				oTotais:Init()
					oTotais:PrintLine()
				oTotais:Finish()
				oReport:SkipLine()
				
				oReport:EndPage()
				
				nGrpDeb	:= 0
				nGrpCrd	:= 0		
				cGrupoAnt := AllTrim(cArqTmp->GRUPO)
			EndIf
		Else
			If cArqTmp->NIVEL1				// Sintetica de 1o. grupo
				oReport:EndPage()
			EndIf
		EndIf

	EndDo       
	
	oPlcontas:Finish()

	If Round(nTotDeb,nDecimais) != Round(nTotCrd,nDecimais)

		nDifer := Round(nTotDeb,nDecimais)-Round(nTotCrd,nDecimais)
		
		If nDifer > 0
			oTotais:Cell("TOT"):Hide()
			oTotais:Cell("TOT"):HideHeader()
			oTotais:Cell("TOT_CREDITO"):Hide()
			oTotais:Cell("TOT_CREDITO"):HideHeader()
			oTotais:Cell("TOT_DEBITO"):SetTitle(SUBS(STR0019,1,14))//"DEBITO A MAIOR:"
			oTotais:Cell("TOT_DEBITO"):SetBlock( { || ValorCTB(Abs(nDifer),,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->TIPOCONTA,,,,,,lPrintZero,.F.,lColDbCr) } )
		ElseIf nDifer < 0
			oTotais:Cell("TOT"):Hide()
			oTotais:Cell("TOT"):HideHeader()
			oTotais:Cell("TOT_DEBITO"):Hide()
			oTotais:Cell("TOT_DEBITO"):HideHeader()
			oTotais:Cell("TOT_CREDITO"):SetTitle(SUBS(STR0020,1,15))//"CREDITO A MAIOR:"
			oTotais:Cell("TOT_CREDITO"):SetBlock( { || ValorCTB(Abs(nDifer),,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->TIPOCONTA,,,,,,lPrintZero,.F.,lColDbCr) } )
		EndIF

		oTotais:Init()
		oTotais:PrintLine()
		oTotais:Finish()

		If nDifer > 0
			oTotais:Cell("TOT"):Show()
			oTotais:Cell("TOT"):ShowHeader()
			oTotais:Cell("TOT_CREDITO"):Show()
			oTotais:Cell("TOT_CREDITO"):ShowHeader()
			oTotais:Cell("TOT_DEBITO"):SetTitle(STR0026)
		Else                                        
			oTotais:Cell("TOT"):Show()
			oTotais:Cell("TOT"):ShowHeader()
			oTotais:Cell("TOT_DEBITO"):Show()
			oTotais:Cell("TOT_DEBITO"):ShowHeader()
			oTotais:Cell("TOT_CREDITO"):SetTitle(STR0027)			
		EndIf

	EndIf	
	
	oTotais:SetLineStyle(.F.)
	oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0022))//"T O T A I S : "
	oTotais:Cell("TOT_DEBITO"):SetBlock( { || ValorCTB(nTotDeb,,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->TIPOCONTA,,,,,,lPrintZero,.F.,lColDbCr) } )
	oTotais:Cell("TOT_CREDITO"):SetBlock( { || ValorCTB(nTotCrd,,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->TIPOCONTA,,,,,,lPrintZero,.F.,lColDbCr) } )

	oTotais:Init()
	oTotais:PrintLine()
	oTotais:Finish()

	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIF	
	dbselectArea("CT2")
Endif

If lImpTermos 							// Impressao dos Termos
	Ctr150Termos("CTR160", Limite, oReport)
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f160soma  ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR160                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f160soma(cTipo,cSegAte,lTotGSint)

Local nRetValor		:= 0
Local nValor		:= 0

	nValor := cArqTmp->SALDOATUCR - cArqTmp->SALDOATUDB

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1  
				If nValor < 0 .And. cTipo == "D"					
					nRetValor := Abs(nValor)
				ElseIf  nValor > 0 .And. cTipo == "C"					
					nRetValor := Abs(nValor)
				EndIf
		EndIf
	Else	// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel	
			If mv_par05 == 2		//Se imprime so as analiticas
				If cArqTmp->TIPOCONTA == "2"
					If nValor < 0 .And. cTipo == "D" 								
						nRetValor := Abs(nValor)
					ElseIf nValor > 0 .And. cTipo == "C" 								
						nRetValor := Abs(nValor)
					EndIf
				EndIf
			ElseIf mv_par05 == 3		//Se imprime as analiticas e sinteticas
				If lTotGSint		//Se totaliza pelas sinteticas
					If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1  
						If (nValor) < 0 .And. cTipo == "D"  					
							nRetValor := Abs(nValor)
						ElseIf  nValor > 0 .And. cTipo == "C"  					
							nRetValor := Abs(nValor)
						EndIf
					EndIf				
				Else				//Se totaliza pelas analiticas
					If cArqTmp->TIPOCONTA == "2"
						If (nValor) < 0 .And. cTipo == "D"
							nRetValor := Abs(nValor)
						ElseIf nValor > 0 .And. cTipo == "C" 
							nRetValor := Abs(nValor)
						EndIf
					EndIf
			    EndIf
			EndIf
		Else	//Se tiver filtragem, somo somente as sinteticas
			If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1                                                       
				If nValor < 0 .And. cTipo == "D"
					nRetValor := Abs(nValor)
				ElseIf  nValor > 0 .And. cTipo == "C"
					nRetValor := Abs(nValor)
				EndIf
			EndIf
    	Endif
	EndIf

Return nRetValor                                                                         


//-------------------------------------------------------------------
/*{Protheus.doc} f160RSsum()

Totalize moviment value according to CT1->CT1_NORMAL if RedStorn 
is activated

@author Fabio Cazarini
   
@version P12
@since   11/05/2017
@return  nRetValor
@obs	 
*/
//-------------------------------------------------------------------
Static Function f160RSsum(cTipo,cSegAte,lTotGSint)
Local nRetValor		:= 0
Local nValor		:= 0

If cTipo == "D" .and. cArqTmp->NORMAL == "1" 
	nValor := cArqTmp->SALDOATUDB - cArqTmp->SALDOATUCR
Elseif cTipo == "C" .and. cArqTmp->NORMAL == "2" 
	nValor := cArqTmp->SALDOATUCR - cArqTmp->SALDOATUDB
Endif

If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
	If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1  
		nRetValor := nValor
	EndIf
Else	// Soma Analiticas
	If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel	
		If mv_par05 == 2		//Se imprime so as analiticas
			If cArqTmp->TIPOCONTA == "2"
				nRetValor := nValor
			EndIf
		ElseIf mv_par05 == 3		//Se imprime as analiticas e sinteticas
			If lTotGSint		//Se totaliza pelas sinteticas
				If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1  
					nRetValor := nValor
				EndIf				
			Else				//Se totaliza pelas analiticas
				If cArqTmp->TIPOCONTA == "2"
					nRetValor := nValor
				EndIf
		    EndIf
		EndIf
	Else	//Se tiver filtragem, somo somente as sinteticas
		If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1                                                       
			nRetValor := nValor
		EndIf
	Endif
EndIf

Return nRetValor                                                                         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R160Fil   ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR160                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R160Fil(cSegAte, nDigitAte,cMascara)

Local lDeixa	:= .F.

	If mv_par05 == 1					// So imprime Sinteticas
		If cArqTmp->TIPOCONTA == "2"
			lDeixa := .T.
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If cArqTmp->TIPOCONTA == "1"
			lDeixa := .T.
		EndIf
	EndIf

	// Verifica Se existe filtragem Ate o Segmento
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(cArqTmp->CONTA)) > nDigitAte
			lDeixa := .T.
		Endif
	EndIf
	If mv_par07 == 2						// Saldos Zerados nao serao impressos
		If ( cArqTmp->SALDOATUCR - cArqTmp->SALDOATUDB ) == 0
			lDeixa := .T.
		EndIf
	EndIf

dbSelectArea("cArqTmp")

Return (lDeixa)

/*

------------------------------------ RELESE 4 -------------------------------------------------------------

*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³CTBR160R3³Autor³ Pilar Sanchez/Gustavo H. ³ Data ³ 20.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balanco Geral Modelo 2									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR160R3(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr160R3(wnRel)

Local aSetOfBook
Local aCtbMoeda	 	:= {}
LOCAL cDesc1 	 	:= OemToAnsi(STR0001)	 //"Este programa ira imprimir o Balanco Geral Modelo 2 (220) Colunas."
LOCAL cDesc2 	 	:= OemToansi(STR0002)   //"A conta eh impressa limitando-se a 70 caracteres e sua descricao 70 caracteres,"
LOCAL cDesc3	 	:= OemToansi(STR0003)   //"sao tambem impressos colunas do saldo a debito e a credito do periodo."
LOCAL cString	 	:= "CT1"
Local titulo 	 	:= OemToAnsi(STR0004) 	//"Balanco Geral"
Local lRet		 	:= .T.
Local lExterno 		:= wnRel <> Nil

PRIVATE Tamanho	 	:="G"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR160"
PRIVATE aReturn  	:= { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha	 	:= {}
PRIVATE nomeProg 	:= "CTBR160"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 		:= 80
Pergunte("CTR160",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01		// Data Inicial                  		  	³
//³ mv_par02		// Data Final                        	  	³
//³ mv_par03		// Conta Inicial                         	³
//³ mv_par04		// Conta Final  							³
//³ mv_par05		// Imprime Contas: Sintet/Analit/Ambas   	³
//³ mv_par06		// Set Of Books				    		    ³
//³ mv_par07		// Saldos Zerados?			     		    ³
//³ mv_par08		// Moeda?          			     		    ³
//³ mv_par09		// Pagina Inicial  		     		    	³
//³ mv_par10		// Saldos? Reais / Orcados	/Gerenciais   	³
//³ mv_par11		// Quebra por Grupo Contabil?		    	³
//³ mv_par12		// Filtra Segmento?					    	³
//³ mv_par13		// Conteudo Inicial Segmento?		   	  	³
//³ mv_par14		// Conteudo Final Segmento?		    	  	³
//³ mv_par15		// Conteudo Contido em?		   	 		  	³

//³ mv_par16		// Salta linha sintetica ?			    	³
//³ mv_par17		// Imprime valor 0.00    ?			    	³
//³ mv_par18		// Imprimir Codigo? Normal / Reduzido  		³
//³ mv_par19		// Divide por ?                   			³

//³ mv_par20		// Imprimir Ate o segmento?			   		³
//³ mv_par21		// Posicao Ant. L/P? Sim / Nao        		³
//³ mv_par22		// Data Lucros/Perdas?                 		³
//³ mv_par23		// So Livro/Livro e Termos/So Termos     	³
//³ mv_par24		// Total Geral sera:Analiticas/Sinteticas	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ! lExterno
	wnrel := "CTBR160"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par06)
	lRet := .F.
EndIf
aSetOfBook := CTBSetOf(mv_par06)

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08)
   If Empty(aCtbMoeda[1])
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet	
	Set Filter To
	Return
EndIf

If ! lExterno
	SetDefault(aReturn,cString)
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR160Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,lExterno)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o	  ³ CTR160Imp³ Autor ³ Pilar Sanchez/ Gustavo³ Data ³ 22/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Balanco Geral								   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ CTR160Imp(lEnd,wnRel,cString,aSetofBook,aCtbMoeda)		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³ SIGACTB 												   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³           ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³           ³ ExpC2   - Mensagem                                         ³±±
±±³           ³ ExpA1   - Matriz ref. Config. Relatorio                    ³±±
±±³           ³ ExpA2   - Matriz ref. a moeda                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR160Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,lExterno)

LOCAL CbTxt		:= Space(10)
Local CbCont	:= 0
LOCAL limite	:= 220
Local cabec1 	:= OemToAnsi(STR0007)	//*         C O N T A             *        D E N O M I N A C A O                     *              S  A  L  D  O  S                 *"
Local cabec2	:= OemToAnsi(STR0008)	//*                               *                                                  *      D E B I T O      *    C R E D I T O      *"
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local lFirstPage	:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nDifer		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local dDataFim		:= mv_par02
Local cSegAte   	:= mv_par20
Local nDigitAte		:= 0
Local lImpRes		:= Iif(mv_par18 == 1,.F.,.T.)	
Local lImpAntLP		:= Iif(mv_par21 == 1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par17==1,.T.,.F.)
Local lJaPulou		:= .F.
Local lPula			:= Iif(mv_par16==1,.T.,.F.) 
Local dDataLP		:= mv_par22
Local nDivide		:= 1
Local nSaldo		:= 0
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
Local n
Local lTotGSint		:= Iif(mv_par24==2,.T.,.F.)	//Define se ira imprimir o total geral pelas contas analiticas ou sinteticas

/*
*         C O N T A                                                     *        D E N O M I N A C A O                     *              S  A  L  D  O  S                 *"
*                                                                       *                                                  *      D E B I T O      *    C R E D I T O      *"
*2345678901234567890123456789012345678901234567890123456789012345678901 *  1111111111111111111111111111111111111111111111  *  111111111111111111   *  111111111111111111   *"
*/

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par05 == 1
	Titulo:=	OemToAnsi(STR0009)	//"BALANCO GERAL SINTETICO DE "
ElseIf mv_par05 == 2
	Titulo:=	OemToAnsi(STR0010)	//"BALANCO GERAL ANALITICO DE "
ElseIf mv_par05 == 3
	Titulo:=	OemToAnsi(STR0011)	//"BALANCO GERAL DE "
EndIf

Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0012) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0013) + cDescMoeda + CtbTitSaldo(mv_par10)
			
			
If mv_par19 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par19 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par19 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	
			

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par23==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par23==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par23==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase

If ! lExterno
	m_pag := mv_par09
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lImpLivro
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
				.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7])},;				
				OemToAnsi(OemToAnsi(STR0016)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0004))  				//"Balanco Geral"				
                        
	// Verifica Se existe filtragem Ate o Segmento
	If !Empty(cSegAte)
		nDigitAte := CtbRelDig(cSegAte,cMascara) 	
	EndIf		

	dbSelectArea("cArqTmp")
	//dbSetOrder(1)
	dbGoTop()

	SetRegua(RecCount())

	cGrupo := GRUPO
Endif

While lImpLivro .And. !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0017)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	If mv_par07 == 2						// Saldos Zerados nao serao impressos
		If ( SALDOATUCR - SALDOATUDB ) == 0
			dbSkip()
			Loop
		EndIf
	EndIf
	
		//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf


	************************* ROTINA DE IMPRESSAO *************************

	If mv_par11 == 1				// Grupo Diferente
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,	0 PSAY "|"
			@li, 29 PSAY OemToAnsi(STR0021) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,143 PSAY "|"
			ValorCTB(nGrpDeb,li,145,33,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,181 PSAY "|"
			ValorCTB(nGrpCrd,li,183,33,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,219 PSAY "|"
			li++						
			li			:= 60
			cGrupo	:= GRUPO
			nGrpDeb	:= 0
			nGrpCrd	:= 0		
		EndIf		
	Else
		If NIVEL1				// Sintetica de 1o. grupo
			li 	:= 60
		EndIf
	EndIf

	IF ( li >= 53 ) .or. ( li >= 49 .and. mv_par11==1) // Limite de linhas para Grupo e totalizador
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)			
		lFirstPage := .F.
	End
	
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,000 	PSAY "|"    
			@ li,072 	PSAY "|"					
			@ li,143 	PSAY "|"
			@ li,181 	PSAY "|"	
			@ li,219	PSAY "|"
			li++
		EndIf	
	EndIf		

	@ li,000 PSAY "|"
	If lImpRes .and. TIPOCONTA == "2"
	    EntidadeCTB(CTARES,li,02,70,.F.,cMascara,cSeparador)
	else
		EntidadeCTB(CONTA,li,02,70,.F.,cMascara,cSeparador)
	Endif
	@ li,072 PSAY "|"
	@ li,075 PSAY Substr(DESCCTA,1,66)	
	nSaldo	:= 	SALDOATUCR - SALDOATUDB
	                                                                                           
	If nSaldo < 0
		@ li,143 PSAY "|"
		ValorCTB(ABS(nSaldo),li,145,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)	
		@ li,181 PSAY "|"
		ValorCTB(0,li,183,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)		
		@ li,219 PSAY "|"
	ElseIf nSaldo > 0
		@ li,143 PSAY "|"
		ValorCTB(0,li,145,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)	
		@ li,181 PSAY "|"
		ValorCTB(ABS(nSaldo),li,183,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)		
		@ li,219 PSAY "|"
	ElseIf nSaldo = 0 
		@ li,143 PSAY "|"
		ValorCTB(0,li,145,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)	
		@ li,181 PSAY "|"
		ValorCTB(0,li,183,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)		
		@ li,219 PSAY "|"
	EndIf	
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,  00 PSAY "|"
		@ li,  72 PSAY "|"
		@ li, 143 PSAY "|"
		@ li, 181 PSAY "|"
		@ li, 219 PSAY "|" 
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf			

	************************* FIM   DA  IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"
			If NIVEL1  
				If (SALDOATUCR - SALDOATUDB) < 0 	
					nTotDeb +=  Abs(SALDOATUCR - SALDOATUDB)
					nGrpDeb +=  Abs(SALDOATUCR - SALDOATUDB)
				ElseIf (SALDOATUCR - SALDOATUDB) > 0 					
					nTotCrd +=  Abs(SALDOATUCR - SALDOATUDB)
					nGrpCrd +=  Abs(SALDOATUCR - SALDOATUDB)
				EndIf
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel	
			If mv_par05 == 2			//Se imprime so as analiticas
				If TIPOCONTA == "2"
					If (SALDOATUCR - SALDOATUDB) < 0 				
						nTotDeb += Abs(SALDOATUCR - SALDOATUDB)
						nGrpDeb += Abs(SALDOATUCR - SALDOATUDB)
					ElseIf  (SALDOATUCR - SALDOATUDB) > 0 					
						nTotCrd += Abs(SALDOATUCR - SALDOATUDB)
						nGrpCrd += Abs(SALDOATUCR - SALDOATUDB)
					EndIf
				EndIf
			ElseIf mv_par05 == 3		//Se imprime as analiticas e sinteticas
				If lTotGSint		//Se totaliza pelas sinteticas
					If TIPOCONTA == "1"
						If NIVEL1  
							If (SALDOATUCR - SALDOATUDB) < 0 	
								nTotDeb +=  Abs(SALDOATUCR - SALDOATUDB)
								nGrpDeb +=  Abs(SALDOATUCR - SALDOATUDB)
							ElseIf (SALDOATUCR - SALDOATUDB) > 0 					
								nTotCrd +=  Abs(SALDOATUCR - SALDOATUDB)
								nGrpCrd +=  Abs(SALDOATUCR - SALDOATUDB)
							EndIf
						EndIf
					EndIf
				Else
					If TIPOCONTA == "2"
						If (SALDOATUCR - SALDOATUDB) < 0 				
							nTotDeb += Abs(SALDOATUCR - SALDOATUDB)
							nGrpDeb += Abs(SALDOATUCR - SALDOATUDB)
						ElseIf  (SALDOATUCR - SALDOATUDB) > 0 					
							nTotCrd += Abs(SALDOATUCR - SALDOATUDB)
							nGrpCrd += Abs(SALDOATUCR - SALDOATUDB)
						EndIf
					EndIf									
				EndIf					
			EndIf
		Else 	//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					If (SALDOATUCR - SALDOATUDB) < 0
						nTotDeb += Abs(SALDOATUCR - SALDOATUDB)
					ElseIf (SALDOATUCR - SALDOATUDB) > 0 
						nTotCrd += Abs(SALDOATUCR - SALDOATUDB)
					EndIf
				EndIf
			EndIf
    	Endif								                                      	
	EndIf                                                                     
	
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			li++
			@ li,  00 PSAY "|"
			@ li,  72 PSAY "|"
			@ li, 143 PSAY "|"
			@ li, 181 PSAY "|"
			@ li, 219 PSAY "|" 
			li++
		EndIf	
	EndIf		
	dbSkip()          
	
EndDO

IF li != 80 .And. !lEnd             
          
	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,	0 PSAY "|"
			@li, 29 PSAY OemToAnsi(STR0021) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,143 PSAY "|"
			ValorCTB(nGrpDeb,li,145,33,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,181 PSAY "|"
			ValorCTB(nGrpCrd,li,183,33,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,219 PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)			
			li++			
		EndIf
	EndIf

	If (Int(nTotDeb*100)/100) != (Int(nTotCrd*100)/100)
		@ li,  00 PSAY "|"
		@ li,  72 PSAY "|"
		@ li, 143 PSAY "|"
		@ li, 181 PSAY "|"
		@ li, 219 PSAY "|" 
		li++
		@Prow()+1,00 PSAY	Replicate("-",limite)		
		li++
		@ li,  00 PSAY "|"
		@ li,  72 PSAY "|"
		
		nDifer := nTotDeb-nTotCrd

		If nDifer > 0
			@ li, 075 PSAY OemToAnsi(STR0019)  //"DEBITO A MAIOR:"
			ValorCTB(Abs(nDifer),li,145,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)
		 ElseIf nDifer < 0
			@ li, 145  PSAY OemToAnsi(STR0020)  //"CREDITO A MAIOR:"
			ValorCTB(Abs(nDifer),li,183,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)
		EndIF
		@ li, 219 PSAY "|" 
		@Prow()+1,00 PSAY	Replicate("-",limite)
	Else
		@Prow()+1,00 PSAY	Replicate("-",limite)
	EndIf	          
	
	If !lEnd          	             
		If nDifer <> 0
			li++    				
			@li,00 PSAY	Replicate("-",limite)		                 	
		EndIf		
		li++
		@ li, 0 PSAY "|" 		
		@ li,02 PSAY STR0022  //"T O T A I S : "
		@ li,143 PSAY "|"		
		ValorCTB(nTotDeb,li,145,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)			
		@ li,181 PSAY "|"		
		ValorCTB(nTotCrd,li,183,33,nDecimais,.F.,cPicture,TIPOCONTA, , , , , ,lPrintZero)					
		@ li,219 PSAY "|" 				
		li++    				
		@li,00 PSAY	Replicate("-",limite)		                 
	EndIf
	

	If ! lExterno	
		roda(cbcont,cbtxt,Tamanho)
    Endif
EndIF

If lImpTermos 							// Impressao dos Termos
	Ctr150Termos("CTR160", Limite)
Endif

If aReturn[5] = 1 .And. ! lExterno
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

If lImpLivro
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIF	
Endif
dbselectArea("CT2")

If ! lExterno
	MS_FLUSH()
Endif

Return
