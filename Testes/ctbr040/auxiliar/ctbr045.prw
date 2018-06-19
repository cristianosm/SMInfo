#Include "Ctbr045.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	TAM_VALOR           14

// 17/08/2009 -- Filial com mais de 2 caracteres

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Ctbr045()	� Autor � Cicero J. Silva   	� Data � 21.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Balancete Convertido								 		  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr045()                               			 		  ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � Nenhum       											  ���
�������������������������������������������������������������������������Ĵ��
���Uso 	     � Generico     											  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CTBR045(wnRel)

Local aArea := GetArea()

Local oReport

Local aSetOfBook    
Local aCtbMoeda	  := {}
Local lOk := .T.
Local nDivide	  := 1                 
Local nQuadro

Local lExterno 	:= wnRel <> Nil

PRIVATE aQuadro	:= { "","","","","","","",""}              
PRIVATE cPerg	 	:= "CTR045"
PRIVATE cTipoAnt	:= ""
PRIVATE nomeProg  	:= "CTBR045"
PRIVATE titulo

If TRepInUse()

	If lExterno
		Return CTBR045R3(wnRel) // Executa vers�o anterior do fonte
		lOk := .F. 
	Endif
	
	If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
		lOk := .F. 
	EndIf
	
	For nQuadro :=1 To Len(aQuadro)
		aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
	Next	
	
	CtbCarTxt()
	
	Pergunte("CTR045",.T.) // Precisa ativar as perguntas antes das definicoes.
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano�
	//� Gerencial -> montagem especifica para impressao)				  �
	//����������������������������������������������������������������
	If !ct040Valid(mv_par06)
		lOk := .F.
	Else
	   aSetOfBook := CTBSetOf(mv_par06)
	Endif
	
	If mv_par21 == 2			// Divide por cem
		nDivide := 100
	ElseIf mv_par21 == 3		// Divide por mil
		nDivide := 1000
	ElseIf mv_par21 == 4		// Divide por milhao
		nDivide := 1000000
	EndIf	
	
	If lOk
		aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
		If Empty(aCtbMoeda[1])                       
	      Help(" ",1,"NOMOEDA")
	      lOk := .F.
	   Endif
	Endif
	
	If lOk
		oReport := ReportDef(aSetOfBook,aQuadro,aCtbMoeda,nDivide)
		oReport:PrintDialog()
	EndIf
	
Else
	Return CTBR045R3(wnRel) // Executa vers�o anterior do fonte
Endif

//Limpa os arquivos tempor�rios 
CTBGerClean()

RestArea(aArea)

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportDef � Autor � Cicero J. Silva    � Data �  07/07/06  ���
�������������������������������������������������������������������������͹��
���Descricao � Definicao do objeto do relatorio personalizavel e das      ���
���          � secoes que serao utilizadas                                ���
�������������������������������������������������������������������������͹��
���Parametros� aSetOfBook - Matriz ref. Config. Relatorio                 ���
���          � aQuadro    - Contas para formar os quadros de resultados   ���
���          � aCtbMoeda  - Matriz ref. a moeda                           ���
���          � nDivide    - Valor para divisao de valores                 ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ReportDef(aSetOfBook,aQuadro,aCtbMoeda,nDivide)

Local oReport
Local oPlcontas

Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+mv_par08)) 
Local lRedStorn		:= IIf(cPaisLoc $ "RUS",SuperGetMV("MV_REDSTOR",.F.,.F.),.F.)// Parameter to activate Red Storn

oReport := TReport():New(nomeProg,STR0003,cPerg,{|oReport| ReportPrint(oReport,aSetOfBook,aCtbMoeda,aQuadro,nDivide)},STR0001+STR0002+STR0016)
						        //"Balancete Conversao Moedas"##"Este programa ira imprimir o Balancete Conversao Moedas, a"##"conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"##"os valores impressao sao saldo anterior, debito, credito e saldo atual do periodo."

If lRedStorn
	oReport:SetLandScape(.T.)
	oReport:DisableOrientation()
Endif

// Sessao 1
oPlcontas := TRSection():New(oReport,STR0029,{"cArqTmp","CT1"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) // "Periodos"
oPlcontas:SetTotalInLine(.F.)
oPlcontas:SetHeaderPage()

TRCell():New(oPlcontas,"CONTA"		,"cArqTmp",STR0022,/*Picture*/,aTamConta[1]	,/*lPixel*/,/*bCodeBlock*/)// "C O D I G O   D A   C O N T A"
TRCell():New(oPlcontas,"CTARES"		,"cArqTmp",STR0022,/*Picture*/,aTamCtaRes[1],/*lPixel*/,/*bCodeBlock*/)// "C O D I G O   D A   C O N T A"
TRCell():New(oPlcontas,"DESCCTA"	,"cArqTmp",STR0023,/*Picture*/,nTamCta  ,/*lPixel*/,/*bCodeBlock*/)// "D E S C R I C A O  D A  C O N T A"
TRCell():New(oPlcontas,"SALDOANT"	,"cArqTmp",STR0024,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*bCodeBlock*/,/*"RIGHT"*/,,"CENTER")// "SALDO ANTERIOR"
TRCell():New(oPlcontas,"SALDODEB"	,"cArqTmp",STR0025,/*Picture*/,TAM_VALOR,/*lPixel*/,/*bCodeBlock*/,/*"RIGHT"*/,,"CENTER")// "DEBITO"
TRCell():New(oPlcontas,"SALDOCRD"	,"cArqTmp",STR0026,/*Picture*/,TAM_VALOR,/*lPixel*/,/*bCodeBlock*/,/*"RIGHT"*/,,"CENTER")// "CREDITO"
TRCell():New(oPlcontas,"MOVIMENTO"	,"cArqTmp",STR0027,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*bCodeBlock*/,/*"RIGHT"*/,,"CENTER")// "MOVIMENTO PERIODO"
TRCell():New(oPlcontas,"SALDOATU"	,"cArqTmp",STR0028,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*bCodeBlock*/,/*"RIGHT"*/,,"CENTER")// "SALDO ATUAL"

oPlcontas:OnPrintLine( {|| ( IIf( (mv_par18 == 1) .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL),; // mv_par18	-	Salta linha sintetica ?
								 cTipoAnt := cArqTmp->TIPOCONTA	)  })

TRPosition():New(oPlcontas,"CT1",1,{|| xFilial("CT1")+cArqTmp->CONTA })

Return oReport

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint� Autor � Cicero J. Silva    � Data �  14/07/06  ���
�������������������������������������������������������������������������͹��
���Descricao � Definicao do objeto do relatorio personalizavel e das      ���
���          � secoes que serao utilizadas                                ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ReportPrint(oReport,aSetOfBook,aCtbMoeda,aQuadro,nDivide)

Local oPlcontas		:= oReport:Section(1)

Local cArqTmp		:= ""
Local cPicture		:= aSetOfBook[4]
Local cSeparador	:= ""
Local cMascara		:= IIf( Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSeparador))                             
Local lImpSint		:= Iif(mv_par05==1 .Or. mv_par05 ==3,.T.,.F.)// Imprime Contas: Sintet/Analit/Ambas
Local lNormal		:= Iif(mv_par20==1,.T.,.F.)	// Imprimir Codigo? Normal / Reduzido
Local lImpAntLP		:= Iif(mv_par23 == 1,.T.,.F.)	// Posicao Ant. L/P? Sim / Nao
Local dDataLP		:= mv_par24						// Data Lucros/Perdas?
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)	// Saldos Zerados?
Local cMoedConv		:= mv_par09						// Moeda Destino?
Local cConsCrit		:= Str(mv_par26,1)				// Considera Criterio?Plano de Contas/Medio/Mensal/Informada
Local dDataConv		:= mv_par27						// Data de Conversao 
Local nTaxaConv		:= mv_par28						// Taxa de Conversao
Local lPrintZero	:= Iif(mv_par19==1,.T.,.F.)	// Imprime valor 0.00    ?
Local dDataFim	 	:= mv_par02							// Data Final
Local nDigitAte		:= 0
Local cDescMoeda 	:= Alltrim(aCtbMoeda[2])
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)
Local cSegAte   	:= mv_par22						// Imprimir Ate o segmento?
Local lmov			:= Iif(mv_par17==1,.T.,.F.)	// Imprime Coluna Mov ?

// verificar necessidade
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cGrupoAnt		:= ""
Local cFiltro		:= oPlcontas:GetAdvplExp()
Local lColDbCr 		:= If(cPaisLoc $ "RUS",.T.,.F.) // Disconsider cTipo in ValorCTB function, setting cTipo to empty
Local lRedStorn		:= If(cPaisLoc $ "RUS",SuperGetMV("MV_REDSTOR",.F.,.F.),.F.)// Parameter to activate Red Storn
Local nGrpSalRS		:= 0
Local nTotSalRS		:= 0

//��������������������������������������������������������������Ŀ
//� Carrega titulo do relatorio: Analitico / Sintetico			  �
//����������������������������������������������������������������
IF mv_par05 == 1      
	titulo := STR0009  //"BALANCETE CONVERSAO MOEDAS SINTETICO DE "
ElseIf mv_par05 == 2
	titulo := STR0006  //"BALANCETE CONVERSAO MOEDAS SINTETICO DE "
ElseIf mv_par05 == 3
	titulo := STR0017  //"BALANCETE CONVERSAO MOEDAS DE "
EndIf
titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par11)
			
If nDivide > 1			
	titulo += " (" + OemToAnsi(STR0021) + Alltrim(Str(nDivide)) + ")"
EndIf	

If lNormal
	oPlcontas:Cell("CTARES"):Disable()
Else
	oPlcontas:Cell("CONTA" ):Disable()
EndIf

If !lMov
	oPlcontas:Cell("MOVIMENTO"):Disable()
	oReport:SetPortrait(.T.)
Else
	oReport:SetLandScape(.T.)
EndIf

oPlcontas:Cell("CONTA"):SetBlock( { || Iif(cArqTmp->TIPOCONTA=="2","  ","")+EntidadeCTB(cArqTmp->CONTA ,0,0,70,.F.,cMascara,cSeparador,,,,,.F.) } )

If mv_par12 == 2 
	oBreak:= TRBreak():New( oPlcontas, {|| Substr(cArqTmp->CONTA,1,1) } )
	oBreak:SetPageBreak(.T.)
EndIf

oPlcontas:Cell("CTARES"):SetBlock( { || Iif(cArqTmp->TIPOCONTA=="2","  ","")+EntidadeCTB(cArqTmp->CTARES,0,0,70,.F.,cMascara,cSeparador,,,,,.F.) } )

oPlcontas:Cell("SALDOANT" ):SetBlock( { || ValorCTB(cArqTmp->SALDOANT ,,,TAM_VALOR,2,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) })
oPlcontas:Cell("SALDODEB" ):SetBlock( { || ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR,2,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F., lColDbCr) })
oPlcontas:Cell("SALDOCRD" ):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR,2,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F., lColDbCr) })
oPlcontas:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR,2,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) })
oPlcontas:Cell("SALDOATU" ):SetBlock( { || ValorCTB(cArqTmp->SALDOATU ,,,TAM_VALOR,2,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) })

oReport:SetCustomText( { || CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

oReport:SetPageNumber(mv_par10)

//��������������������������������������������������������������Ŀ
//� Monta Arquivo Temporario para Impressao					     �
//����������������������������������������������������������������
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			 CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
			  mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
			   mv_par11,aSetOfBook,mv_par13,mv_par14,mv_par14,mv_par16,;
			    .F.,.F.,mv_par12,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,.T.,cMoedConv,;
				 cConsCrit,dDataConv,nTaxaConv,,,lImpSint,cFiltro)},;
				  OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor�rio..."
				   OemToAnsi(STR0003))  				//"Balancete Verificacao"

oReport:NoUserFilter()

dbSelectArea("cArqTmp")	
dbSetOrder(1)
dbGoTop()
oReport:SetMeter( RecCount() )

//******************************
// Totalizadores do relatorio  *
//******************************

If mv_par12 == 1 // mv_par11 - Quebra por Grupo Contabil? 
	// Totais por grupo
	oBrkGrp 	:= TRBreak():New( oPlcontas, { || cArqTmp->GRUPO	}, "" , )
	oBrkGrp:OnBreak( {|cGrupo| oBrkGrp:SetTitle(OemToAnsi(STR0020) + cGrupo + " )") } )

	oTotGrpDe 	:= TRFunction():New( oPlcontas:Cell("SALDODEB")	, ,"ONPRINT", oBrkGrp,/*Titulo*/,cPicture,;
	{|| ValorCTB(nGrpDeb,,,TAM_VALOR,2,.F.,cPicture,"1",,,,,,lPrintZero,.F., lColDbCr) },.F.,.F.,.F.,oPlcontas)

	oTotGrpCr	:= TRFunction():New( oPlcontas:Cell("SALDOCRD")	, ,"ONPRINT", oBrkGrp,/*Titulo*/,cPicture,;
	{ || ValorCTB(nGrpCrd,,,TAM_VALOR,2,.F.,cPicture,"2",,,,,,lPrintZero,.F., lColDbCr) },.F.,.F.,.F.,oPlcontas)

	if lMov
		If lRedStorn
			oTotGrpCr	:= TRFunction():New( oPlcontas:Cell("MOVIMENTO")	, ,"ONPRINT", oBrkGrp,/*Titulo*/,cPicture,;
			{ || ValorCTB(nGrpSalRS,,,TAM_VALOR,2,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oPlcontas)
		Else
			oTotGrpCr	:= TRFunction():New( oPlcontas:Cell("MOVIMENTO")	, ,"ONPRINT", oBrkGrp,/*Titulo*/,cPicture,;
			{ || ValorCTB(nGrpCrd - nGrpDeb,,,TAM_VALOR,2,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oPlcontas)
		Endif
	EndIf

Endif

oBrkEnd 	:= TRBreak():New( oPlcontas, { || cArqTmp->(Eof())	}, OemToAnsi(STR0011), )//"T O T A I S  D O  M E S : "

oTotDeb 	:= TRFunction():New( oPlcontas:Cell("SALDODEB")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
{ || ValorCTB(nTotDeb,,,TAM_VALOR,2,.F.,cPicture,"1",,,,,,lPrintZero,.F., lColDbCr) },.F.,.F.,.F.,oPlcontas)

oTotCred	:= TRFunction():New( oPlcontas:Cell("SALDOCRD")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
{ || ValorCTB(nTotCrd,,,TAM_VALOR,2,.F.,cPicture,"2",,,,,,lPrintZero,.F., lColDbCr) },.F.,.F.,.F.,oPlcontas)

	if lMov
		If lRedStorn
			oTotGrpMv	:= TRFunction():New( oPlcontas:Cell("MOVIMENTO")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
			{ || ValorCTB(nTotSalRS,,,TAM_VALOR,2,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oPlcontas)
		Else
			oTotGrpMv	:= TRFunction():New( oPlcontas:Cell("MOVIMENTO")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
			{ || ValorCTB(nTotCrd - nTotDeb,,,TAM_VALOR,2,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oPlcontas)
		Endif
	EndIf

//*********************************
// Fim Totalizadores do relatorio *
//*********************************

oPlcontas:Init()

Do While !Eof() .And. !oReport:Cancel()

	oReport:IncMeter()

    If oReport:Cancel()
    	Exit
    EndIf       
    
	If R45Fil(cSegAte, nDigitAte,cMascara)
		dbSkip()
		Loop
	EndIf     
	
	oPlcontas:PrintLine() //Section(1)
	
	nTotDeb += R45Soma("D",cSegAte)
	nGrpDeb += R45Soma("D",cSegAte)
	nTotCrd += R45Soma("C",cSegAte)
	nGrpCrd += R45Soma("C",cSegAte)

    dbSkip()

EndDo

If cPaisLoc $ "RUS"
	nGrpSalRS := RedStorTt(nGrpDeb,nGrpCrd,cArqTmp->TIPOCONTA,cArqTmp->NORMAL,"T")
	nTotSalRS := RedStorTt(nTotDeb,nTotCrd,cArqTmp->TIPOCONTA,cArqTmp->NORMAL,"T")
Endif

oPlContas:Finish()

oReport:SkipLine()
	
If mv_par25 ==1
	oReport:Section(1):SetHeaderSection(.F.)
	ImpQuadro(0,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,oReport:ClassName(),(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par11,oReport)
EndIf	

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

Return                                                                          

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �R45Soma   �Autor  �Cicero J. Silva     � Data �  24/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CTBR045                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function R45Soma(cTipo,cSegAte)

Local nRetValor := 0

If mv_par05 == 1	// So imprime Sinteticas - Soma Sinteticas
	If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1            
		If cTipo == "D"
			nRetValor := cArqTmp->SALDODEB                             	
		ElseIf cTipo == "C"
			nRetValor := cArqTmp->SALDOCRD
		EndIf
	EndIf
Else	// Soma Analiticas
	If Empty(cSegAte)	//Se nao tiver filtragem ate o nivel
		If cArqTmp->TIPOCONTA == "2"
			If cTipo == "D"
				nRetValor := cArqTmp->SALDODEB
			ElseIf cTipo == "C"
				nRetValor := cArqTmp->SALDOCRD
			EndIf
		EndIf
	Else							//Se tiver filtragem, somo somente as sinteticas
		If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1
			If cTipo == "D"
				nRetValor := cArqTmp->SALDODEB
			ElseIf cTipo == "C"
				nRetValor := cArqTmp->SALDOCRD
			EndIf
		EndIf	
    Endif			
EndIf

Return nRetValor                                                                         


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �R45Fil    �Autor  �Cicero J. Silva     � Data �  24/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CTBR045                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function R45Fil(cSegAte, nDigitAte,cMascara)

Local lDeixa := .F.

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
If !Empty(cSegAte)
	nDigitAte := CtbRelDig(cSegAte,cMascara) 	
EndIf		
	
//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
If !Empty(cSegAte)
	If Len(Alltrim(cArqTmp->CONTA)) > nDigitAte
		lDeixa := .T.
	Endif
EndIf

dbSelectArea("cArqTmp")

Return (lDeixa)
/*
--------------------------------------------------------V RELESE 3 V---------------------------------------------------------------- 
*/

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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Ctbr045R3� Autor � Lucimara Soares   	� Data � 06.03.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Balancete Convertido								 		  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr045()                               			 		  ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � Nenhum       											  ���
�������������������������������������������������������������������������Ĵ��
���Uso    	 � Generico     											  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function CtbR045R3(wnRel)

Local aSetOfBook
Local aCtbMoeda	:= {}
LOCAL cDesc1 		:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Balancete Conversao Moedas, a"
LOCAL cDesc2 		:= OemToansi(STR0002)   //"conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"
LOCAL cDesc3		:= OemToansi(STR0016)   //"os valores impressao sao saldo anterior, debito, credito e saldo atual do periodo."
LOCAL cString		:= "CT1"
Local titulo 		:= OemToAnsi(STR0003) 	//"Balancete Conversao Moedas"
Local lRet			:= .T.
Local nDivide		:= 1
Local lExterno 	:= wnRel <> Nil
Local nQuadro		:= 0

PRIVATE Tamanho		:="M"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR045"
PRIVATE aReturn 	:= { OemToAnsi(STR0013), 1,OemToAnsi(STR0014), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR045"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li	:= 80 

Private aQuadro := { "","","","","","","",""}              

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next	

CtbCarTxt()

Pergunte("CTR045",.F.)

//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros								  	�
//� mv_par01	// Data Inicial                  	  		  			  	�
//� mv_par02	// Data Final                        		  			  	�
//� mv_par03	// Conta Inicial                         	  			  	�
//� mv_par04	// Conta Final  							  			  	�	
//� mv_par05	// Imprime Contas: Sintet/Analit/Ambas   	  			  	�
//� mv_par06	// Set Of Books				    		      			  	�
//� mv_par07	// Saldos Zerados?			     		      			  	�
//� mv_par08	// Moeda Origem?          			 	      			  	� 
//� mv_par09	// Moeda Destino?          			 	      			  	�
//� mv_par10	// Pagina Inicial  		     		    	  			  	�
//� mv_par11	// Saldos? Reais / Orcados	/Gerenciais   	  			  	�
//� mv_par12	// Quebra por Grupo Contabil?		    	 			  	�
//� mv_par13	// Filtra Segmento?					    	  			  	�
//� mv_par14	// Conteudo Inicial Segmento?		   		 			 	�
//� mv_par15	// Conteudo Final Segmento?		    		  				�
//� mv_par16	// Conteudo Contido em?				    	  				�
//� mv_par17	// Imprime Coluna Mov ?				    	  				�
//� mv_par18	// Salta linha sintetica ?			    	  				�
//� mv_par19	// Imprime valor 0.00    ?			    	  				�
//� mv_par20	// Imprimir Codigo? Normal / Reduzido  		  				�
//� mv_par21	// Divide por ?                   			 				�
//� mv_par22	// Imprimir Ate o segmento?			   					  	�
//� mv_par23	// Posicao Ant. L/P? Sim / Nao        						�
//� mv_par24	// Data Lucros/Perdas?                 		  				�
//� mv_par25	// Imprime Quadros Cont�beis?				  			  	�  
//� mv_par26	// Considera Criterio?Plano de Contas/Medio/Mensal/Informada�
//� mv_par27	// Data de Conversao          				  				� 
//� mv_par28	// Taxa de Conversao          				  				� 
//���������������������������������������������������������������������������

If ! lExterno
	wnrel	:= "CTBR045"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,"CTR045",@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Endif
    
If nLastKey == 27
	Set Filter To
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano�
//� Gerencial -> montagem especifica para impressao)				  �
//����������������������������������������������������������������
If !ct040Valid(mv_par06)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par21 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par21 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par21 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet
	Set Filter To
	Return
EndIf

If mv_par17 == 1 .And. ! lExterno	// Se imprime saldo movimento do periodo -> tamanho relatorio = 220
	tamanho := "G"
EndIf	

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR045Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno)})

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �CTR045IMP � Autor � Lucimara Soares	    � Data � 06.03.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime relatorio -> Balancete Verificacao Modelo 1        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CTR045Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd       - A�ao do Codeblock                             ���
���          � WnRel      - T�tulo do relat�rio                           ���
���          � cString    - Mensagem                                      ���
���          � aSetOfBook - Matriz ref. Config. Relatorio                 ���
���          � aCtbMoeda  - Matriz ref. a moeda                           ���
���          � nDivide    - Valor para divisao de valores                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CTR045Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno)

Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 132
Local cabec1   	:= ""
Local cabec2   	:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 	:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par19==1,.T.,.F.)
Local lPula			:= Iif(mv_par18==1,.T.,.F.) 
Local lNormal		:= Iif(mv_par20==1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
Local l132			:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= mv_par22
Local nDigitAte	:= 0
Local lImpAntLP	:= Iif(mv_par23 == 1,.T.,.F.)
Local dDataLP		:= mv_par24
Local cMoedConv		:= mv_par09
Local cConsCrit		:= Str(mv_par26,1)
Local dDataConv		:= mv_par27
Local nTaxaConv		:= mv_par28
Local nCont			:= 0
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

//��������������������������������������������������������������Ŀ
//� Carrega titulo do relatorio: Analitico / Sintetico			  �
//����������������������������������������������������������������
IF mv_par05 == 1
	Titulo:=	OemToAnsi(STR0009)	//"BALANCETE CONVERSAO MOEDAS SINTETICO DE "
ElseIf mv_par05 == 2
	Titulo:=	OemToAnsi(STR0006)	//"BALANCETE CONVERSAO MOEDAS ANALITICO DE "
ElseIf mv_par05 == 3
	Titulo:=	OemToAnsi(STR0017)	//"BALANCETE CONVERSAO MOEDAS DE "
EndIf

Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par11)
			
If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0021) + Alltrim(Str(nDivide)) + ")"
EndIf	

If mv_par17 == 1 .And. ! lExterno		// Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220        
	l132	:= .F.
Else	
	cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif

If ! lExterno
	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))
Endif

If l132
	aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

If ! lExterno
	m_pag := mv_par10
Endif

//��������������������������������������������������������������Ŀ
//� Monta Arquivo Temporario para Impressao						 �
//����������������������������������������������������������������
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par11,aSetOfBook,mv_par13,mv_par14,mv_par14,mv_par16,;
				.F.,.F.,mv_par12,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,.T.,cMoedConv,;
				cConsCrit,dDataConv,nTaxaConv,,,lImpSint,aReturn[7])},;
				OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor�rio..."
				OemToAnsi(STR0003))  				//"Balancete Verificacao"
// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	nDigitAte := CtbRelDig(cSegAte,cMascara) 	
EndIf		
				

dbSelectArea("cArqTmp")
//dbSetOrder(1)
dbGoTop()

SetRegua(RecCount())

cGrupo := GRUPO

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0010)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	// ******************** "FILTRAGEM" PARA IMPRESSAO *************************

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

	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	

	// ************************* ROTINA DE IMPRESSAO *************************

	If mv_par12 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "       
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			@li,aColunas[COL_SEPARA8] PSAY "|"
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

	IF li > 58 
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	End

	@ li,aColunas[COL_SEPARA1] 		PSAY "|"
	If lNormal
		If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,21,.F.,cMascara,cSeparador)
		Else	
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA],23,.F.,cMascara,cSeparador)
		EndIf	
	Else
		If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		Else
			@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
		EndIf						
	EndIf	
	@ li,aColunas[COL_SEPARA2] 		PSAY "|"
	@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,31)
	@ li,aColunas[COL_SEPARA3]		PSAY "|"		
	                                                        
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"	
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132  
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		EndIf
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf			

	// ************************* FIM   DA  IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"
			If NIVEL1
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			EndIf	
    	Endif			
	EndIf

	dbSkip()       
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132  
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf	
			li++
		EndIf	
	EndIf		
EndDO

IF li != 80 .And. !lEnd
	IF li > 58 
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	If mv_par12 == 1							// Grupo Diferente - Totaliza e Quebra
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
				If Round(NoRound(nTotMov,3),2) < 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
				ElseIf Round(NoRound(nTotMov,3),2) > 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
                EndIf
				@ li,aColunas[COL_SEPARA7] PSAY "|"	
			Endif
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
	EndIf

	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,39 PSAY OemToAnsi(STR0011)  		//"T O T A I S  D O  M E S : "
	@li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] PSAY "|"
 	If !l132	
		nTotMov := nTotMov + (nTotCrd - nTotDeb)
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) > 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		@li,aColunas[COL_SEPARA7] PSAY "|"	
	EndIf		
	@li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	If ! lExterno
		roda(cbcont,cbtxt,"M")
	Endif
	Set Filter To
EndIF

If mv_par25 ==1
	ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,nomeprog,(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par11)
EndIf	
	
If aReturn[5] = 1 .And. ! lExterno
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

If ! lExterno
	MS_FLUSH()
Endif

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CTR045CT1 � Autor � Simone Mie Sato	    � Data � 10.03.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica o criterio de conversao da conta                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CTR045CT1()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T./.F.                                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Ctr045Med(cMoedConv)

Local aSaveArea	:= GetArea()
Local cCritConv	:= ""

dbSelectArea("CT1")
dbSetOrder(1)
If MsSeek(xFilial()+ cArqTmp->CONTA)    
	cCritConv	:= &("CT1->CT1_CVD"+cMoedConv)
EndIf

RestArea(aSaveArea)

Return(cCritConv)
