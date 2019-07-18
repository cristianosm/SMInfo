#Include "Totvs.ch"
#Include 'VKey.ch'
#Include 'InKey.ch'

/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNÇÃO   : LibCustos		 | AUTOR : Cristiano Machado | DATA : 24/06/2019 **
**---------------------------------------------------------------------------**
** DESCRIÇÃO: Todas as Funções de calculo de Custos devem Ficar Aqui.        **
**			: Nenhum Calculo que envolva custo deve ser feito em outro Fonte.**
**          : Sempre criar função com Parametros aqui.                       **
**---------------------------------------------------------------------------**
** USO : Especifico para  Imdepa Rolamentos                                  **
**---------------------------------------------------------------------------**
\*****************************************************************************/

*******************************************************************************
User Function FCalcIMC( P_cFilial , P_cArmazem , P_cB1origer , cB1origem , P_nAliqIPI )
	*******************************************************************************
	Local nValFator 	:= 0
	Local _aArea 		:= GetArea()
	Local cIPI  	    := ""

	Private  USAFATOR  := SuperGetMv("MV_USAFATOR" , , "N")

	Default P_cArmazem := "01"

	DbSelectArea('MCR');DbSetOrder(1)

	cIPI := Alltrim(Str(P_nAliqIPI))

	If DbSeek( xFilial("MCR")+P_cFilial+P_cB1origer + cIPI, .F. )
		nValFator := MCR->MCR_FATOR
	EndIf

	RestArea(_aArea)

	Return nValFator

	//| Calculo BASE de Custos Pedido e NF
	*******************************************************************************
User Function CalCusBase(lVerST, _nItem, _oProcess, _nMC, _nMCR, _nIMC, _nIMCg, _nIMCR, _nIMCUC, _nCusMC, _nCusMCg, _nCusMCR, _nCusMCUC,  _nMCTot, _nMCRTot, _nCOEFC, _nCOEFF, _nCOEFI, _nQxITotal, _nQtdITotal, _nTISIPI, _nIdadeSC6 )
	*******************************************************************************
	
	Local ljaCPIMC		:= 	Iif(Type("_ljaCPIMC") == "U" , .F., _ljaCPIMC ) // Caso Variavel Publica não exista cria uma local como .F., senão pega valor da Publica.
	
	Local lGeralog 		:= .F.

	Local lTmkVFIM		:= IIf(ljaCPIMC, .F., FUNNAME() == 'TMKA271' )
	Local lTmkOnLi		:= ljaCPIMC
	
	Local cMVFILFRT		:= GETMV('MV_FILFRT')	//| Filiais que entram no calculo do novo frete       
	Local nImdPerFrt 	:= SuperGetMv("IMD_PERFRT",,0.7463) //| Indice frete MC 
	
	Local nDecVLRITEM 	:= Iif ( lTmkVFIM , TamSx3("UB_VLRITEM")[2] , TamSx3("D2_PRCVEN")[2] )
	Local cTabCab		:= Iif ( lTmkVFIM , 'SUA'			, Iif( lTmkOnLi , 'SUA' 		, 'SC5' 			) )
	Local nDespesa 		:= Iif ( lTmkVFIM , SUA->UA_DESPESA	, Iif( lTmkOnLi , AVALORES[5] 	, SF2->F2_DESPESA 	) )
	Local cTabPreco		:= Iif ( lTmkVFIM , SUA->UA_TABELA	, Iif( lTmkOnLi , M->UA_TABELA	, SC5->C5_TABELA 	) )
	Local cMoeda		:= Iif ( lTmkVFIM , SUA->UA_MOEDA	, Iif( lTmkOnLi , M->UA_MOEDA 	, SC5->C5_MOEDA 	) )
	Local cTpFrete		:= Iif ( lTmkVFIM , SUA->UA_TPFRETE	, Iif( lTmkOnLi , M->UA_TPFRETE , SUA->UA_TPFRETE 	) )
	Local nValBrut		:= Iif ( lTmkVFIM , SUA->UA_VALBRUT	, Iif( lTmkOnLi , AVALORES[1]	, SUA->UA_VALBRUT 	) )
	Local nValMerc		:= Iif ( lTmkVFIM , SUA->UA_VALMERC	, Iif( lTmkOnLi , AVALORES[1]   , SUA->UA_VALMERC 	) )
	Local cCodRota		:= Iif ( lTmkVFIM , SUA->UA_CODROTA	, Iif( lTmkOnLi , M->UA_CODROTA , SUA->UA_CODROTA 	) )
	Local nCFrete		:= Iif ( lTmkVFIM , SUA->UA_FRETE	, Iif( lTmkOnLi , M->UA_FRETE   , SUA->UA_FRETE 	) )
	Local nFretCal		:= Iif ( lTmkVFIM , SUA->UA_FRETCAL	, Iif( lTmkOnLi , M->UA_FRETCAL , SUA->UA_FRETCAL 	) )
	Local cFretran		:= Iif ( lTmkVFIM , SUA->UA_FRETRAN	, Iif( lTmkOnLi , M->UA_FRETRAN , SUA->UA_FRETRAN 	) )
	Local nFreteFob   	:= Iif ( lTmkVFIM , SUA->UA_FRETFOB , Iif( lTmkOnLi , M->UA_FRETFOB , SUA->UA_FRETFOB	) )

	Local cProduto		:= Iif ( lTmkVFIM , SUB->UB_PRODUTO	, Iif( lTmkOnLi , "" , SD2->D2_COD 		) )
	Local nQtdItem 		:= Iif ( lTmkVFIM , SUB->UB_QUANT	, Iif( lTmkOnLi , 0	 , SD2->D2_QUANT 	) )
	Local nVrcAcre 		:= Iif ( lTmkVFIM , SUB->UB_VRCACRE	, Iif( lTmkOnLi , 0  , SD2->D2_BASEICM 	) )
	Local nVlrItem		:= Iif ( lTmkVFIM , SUB->UB_VLRITEM	, Iif( lTmkOnLi , 0  , SC6->C6_VALOR 	) )
	Local nTotAcre		:= Iif ( lTmkVFIM , SUB->UB_TOTACRE	, Iif( lTmkOnLi , 0  , SC6->C6_PRCACRE 	) )
	Local cLocalB2		:= Iif ( lTmkVFIM , SUB->UB_LOCAL	, Iif( lTmkOnLi , '' , SC6->C6_LOCAL 	) )

	Local n_COMIS1		:= Iif ( lTmkVFIM , SUB->UB_COMIS1	, Iif( lTmkOnLi , 0, SC6->C6_COMIS1	) )
	Local n_COMIS2		:= Iif ( lTmkVFIM , SUB->UB_COMIS2	, Iif( lTmkOnLi , 0, SC6->C6_COMIS2	) )
	Local n_COMIS3		:= Iif ( lTmkVFIM , SUB->UB_COMIS3	, Iif( lTmkOnLi , 0, SC6->C6_COMIS3	) )
	Local n_COMIS4		:= Iif ( lTmkVFIM , SUB->UB_COMIS4	, Iif( lTmkOnLi , 0, SC6->C6_COMIS4	) )
	Local n_COMIS5		:= Iif ( lTmkVFIM , SUB->UB_COMIS5	, Iif( lTmkOnLi , 0, SC6->C6_COMIS5	) )

	Local nAcrsFin		:= Iif ( lTmkVFIM , SE4->E4_ACRSFIN	, Iif( lTmkOnLi , SE4->E4_ACRSFIN , SE4->E4_ACRSFIN	) ) 
	Local cVinculo 		:= Iif ( lTmkVFIM , SA1->A1_VINCULO	, Iif( lTmkOnLi , SA1->A1_VINCULO , SA1->A1_VINCULO	) ) 
	Local cCliFrte		:= Iif ( lTmkVFIM , SA1->A1_CLIFRTE	, Iif( lTmkOnLi , SA1->A1_CLIFRTE , SA1->A1_CLIFRTE	) ) 

	Local cTpCust		:= ""
	Local nAlicIcm 		:= 0
	Local nValDesp 		:= 0
	Local nAcreCon 		:= 0
	Local nValFret 		:= 0
	Local nCalcIcm 		:= 0 // Base ICMS
	Local nAlicIpi 		:= 0
	Local nMVA 			:= 0
	Local nValIcmSt 	:= 0 
	Local nIcmRetido 	:= 0
	Local nValFrtA 		:= 0
//	Local nBaseICM		:= 0
	Local nRatDesp		:= 0

	Local lRedesp    	:= .F.

	// Deve Zerar Todas as Veriaveis NUMERICAS que vem por PARAMETRO. Aqui Passa por ITEM.
	_nMC 		:= _nMCR	:= _nIMC 	:= _nIMCg 		:= _nIMCR 		:= _nIMCUC 	:= 0
	_nCusMCg 	:= _nCusMC 	:= _nCusMCR := _nCusMCUC 	:= _nMCTot 		:= _nMCRTot := 0
	_nCOEFF 	:= _nCOEFC 	:= _nCOEFI 	:= _nQxITotal 	:= _nQtdITotal	:= _nTISIPI := _nIdadeSC6 := 0 
	//--<<
	
	If lTmkOnLi // Quando chamado via F4

		n_COMIS1  	:= SF4->( U_DefComis( SA1->A1_VENDEXT , .F. , SA1->A1_PAGCOM1 , 0 , 0 ) )
		n_COMIS2  	:= SF4->( U_DefComis( SA1->A1_VEND    , .T. , SA1->A1_PAGCOM2 , 0 , 0 ) )
		n_COMIS3  	:= SF4->( U_DefComis( SA1->A1_VENDCOO , .F. , SA1->A1_PAGCOM3 , 0 , 0 ) )
		n_COMIS4  	:= SF4->( U_DefComis( SA1->A1_CHEFVEN , .F. , SA1->A1_PAGCOM4 , 0 , 0 ) )
		n_COMIS5  	:= SF4->( U_DefComis( SA1->A1_GERVEN  , .F. , SA1->A1_PAGCOM5 , 0 , 0 ) )
		
		cProduto	:= GDFIELDGET('UB_PRODUTO' 	, _nItem )
		nQtdItem 	:= GDFIELDGET('UB_QUANT'   	, _nItem )
		nVrcAcre 	:= GDFIELDGET('UB_VRCACRE' 	, _nItem )
		nVlrItem	:= GDFIELDGET('UB_VLRITEM' 	, _nItem )
		nTotAcre	:= GDFIELDGET('UB_TOTACRE' 	, _nItem )
		cLocalB2	:= GDFIELDGET('UB_LOCAL' 	, _nItem )
		
	EndIf		
	// Alert("FUNNAME : " + FUNNAME())
	//*********************************************************************
	//--> INICIO Calculo Custos

	lCliVinc 	:= Alltrim(cVinculo) $  ("#CM*CM*#PP*PP")	//| Cliente com Vinculo Contratual com a imdepa
	lCliFEsp	:= ( Upper(cCliFrte) $ '1#X' ) 				//| Cliente Com Frete Especial
	
	_nCusMC :=  U_FCusTrib(.F.)

	If  ( Type("lTk271Auto") == "U" .OR. !lTk271Auto ) .And.  Type("_oProcess") <> "U"

		_oProcess:IncRegua2("Margem - Definindo Custo Contribuição Reposicao...")
		_nCusMCR  := SF4->(U_PrcBase(cProduto,cTabPreco,@cTpCust,.F.,"R"))

	Else
		_nCusMCR  :=  U_PrcBase( cProduto,cTabPreco,@cTpCust,.F.,"R")
	EndIf

	//Custo Margem de Contribuição Média das Ultimas Compras
	If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto ) .And.  Type("_oProcess") <> "U"

		_oProcess:IncRegua2("Margem - Definindo Custo Contribuição Média das Ultimas Compras...")
		_nCusMCUC := SF4->(U_PrcBase( cProduto,cTabPreco,@cTpCust,.F.,"U"))

	Else
		_nCusMCUC := U_PrcBase( cProduto,cTabPreco,@cTpCust,.F.,"U")
	EndIf

	// converte o valor total do item para moeda 1
	nVrcAcre := IIF( cMoeda==1 , nVrcAcre , xMoeda(nVrcAcre,cMoeda,1,dDataBase,nDecVLRITEM))

	nRatDesp := nVlrItem / nValBrut * nDespesa

	lVerST	 := .F.
	If _nItem > 0

		nValDesp := NoRound(nVlrItem / nValMerc * nDespesa,2) // Despesa DOC

		nAcreCon := NoRound(((nVlrItem + (nVlrItem / nValMerc) * nDespesa) * nAcrsFin)/100,2) //Acrescimo Condicao

		If cTpFrete == "F" .AND. nFretefob !=0
			If Posicione("SZO",1,xFilial("SZO")+cCodRota,"ZO_REDESPA") = "S" //Verifica frete redespacho
				lRedesp := .T.
			EndIf
		EndIf

//		nBaseICM := NoRound((nVlrItem   + nValDesp + nAcreCon + nValFrtA),2)

//		nBaseICM := IIF(cMoeda==1,nBaseICM,xMoeda(nBaseICM,cMoeda,1,dDataBase,nDecBASEICM))

		nFretrSM := cFretran

		IF (xFilial(cTabCab) $ cMVFILFRT ) .AND. (!lCliVinc) .AND. !(lCliFEsp) .AND. cTpFrete <> 'F'
			nFretrSM := cFretran * nImdPerFrt // 
		EndIf


		IF (xFilial(cTabCab) $ cMVFILFRT ) .AND. (!lCliVinc) .AND. !(lCliFEsp) .AND. cTpFrete <> 'F'
			
			nValFret := NoRound(nTotAcre / nValMerc *  nFretrSM , 2) 
			nValFrtA := NoRound(nTotAcre / nValMerc *  nCFrete  , 2) // 
		Else
			If cTpFrete <> 'F' .And. nFretCal > 0 // Frete Destacado - Cristiano 
				
				nValFret := NoRound(nTotAcre / nValMerc *  nFretrSM , 2)
				nValFrtA := NoRound(nTotAcre / nValMerc *  nFretCal , 2)
			Else
			
				nValFret := NoRound(nTotAcre / nValMerc * nCFrete,2) //Valor Frete
				nValFrtA := 0
			EndIf
		EndIf

		If cTpFrete == "C" .AND. nCFrete !=0

			IF (xFilial(cTabCab) $ cMVFILFRT ) .AND. (!lCliVinc) .AND. !(lCliFEsp) .AND. cTpFrete <> 'F'

				nFreteItem	:= nValFret //| CIF - Destacado      ///nFreteCal / nValmerc * nVrcAcre
			Else

				nFreteItem	:= nValFret //- (nValFret * 0.2) // MENOS 20%
			EndIf

		ElseIf cTpFrete == "C" .AND. nCFrete == 0

			IF ( xFilial(cTabCab) $ cMVFILFRT ) .AND. (!lCliVinc) .AND. !(lCliFEsp) .AND. cTpFrete <> 'F'

				nFreteItem := NoRound(nTotAcre / nValMerc * nFretrSM ,2)
			Else
				///ORIGINAL
				nFreteItem := NoRound(nTotAcre / nValMerc * nFretCal,2) //Valor Frete Incluso
			EndIf

		ElseIf lRedesp
			nFreteItem := NoRound(nTotAcre / nValMerc * nFreteFob,2) //Valor Frete de Redespacho
		Else
			nFreteItem := 0
		EndIf

		IF (xFilial(cTabCab) $ cMVFILFRT ) .AND. (!lCliVinc) .AND. !(lCliFEsp) .AND. cTpFrete <> 'F'

			nCalcIcm := NoRound((nVlrItem   + nValDesp + nAcreCon + nValFrtA),2)   // Base do Icms

			NIcm_PIS := NoRound((nVlrItem  + nAcreCon ),2)   // Base do Icms // alterado por rodrigo em 29/05 em função de que não deve somar as despesas nos calculo de PIS

		Else
			nCalcIcm    := NoRound((nVlrItem   + nValDesp + nAcreCon + nValFret),2)   // Base do Icms

			//Novo Cálculo para PIS desprezando o frete
			NIcm_PIS:= NoRound((nVlrItem   + nAcreCon),2)   // Base do Icms // alterado por rodrigo em 29/05 em função de que não deve somar as despesas nos calculo de PIS
		EndIf

		nAlicIpi 	:= SB1->B1_IPI
		cTpCliFor  	:= SA1->A1_TIPO
		cSegmento  	:= Substr(SA1->A1_GRPSEG,3,1)

		lVerST := U_Fsubtrib(xFilial(cTabCab),"S","N",cTpCliFor,SA1->A1_EST,SB1->B1_POSIPI,cSegmento,3,"S")//| Verifica se eh ST

		If lVerST .AND. SF4->F4_CREDST == '3'

			DbSelectArea("SF7")
			If DbSeek(xFilial("SF7")+SB1->B1_GRTRIB,.F.)
				While !eof() .AND. SB1->B1_GRTRIB == SF7->F7_GRTRIB .AND. SF7->F7_GRPCLI == SPACE(03)
					If SA1->A1_EST == SF7->F7_EST
						nMVA := SF7->F7_MARGEM
						Exit
					EndIf
					DbSkip()

				EndDo

				nBaseRet 	:= ( nCalcIcm * (1 + nAlicIpi / 100)) * ( 1 +  (nMVA/100) )
				cEstxIcm 	:= GetMv("MV_ESTICM")
				nPosUf		:= At(SA1->A1_EST,cEstxIcm) + 2
				nValIcmSt 	:= (nBaseRet * ((Val(Substr(cEstxIcm,nPosUf,2))/100)))

			EndIf

		EndIf

		lInterna := (SM0->M0_ESTENT == SA1->A1_EST)

		If SF4->F4_ICM == 'S'
			If lInterna
				nAlicIcm := GetMv('MV_ICMPAD')
			Else

				If SA1->A1_EST $ GetMv('MV_NORTE') .AND. !(SM0->M0_ESTENT $ GetMv('MV_NORTE'))
					nAlicIcm := 7
				Else
					nAlicIcm := 12
				EndIf

				//| Cristiano Machado - 27/12/2012 - 4% Importados ICMS
				If SB1->B1_ORIGEM $ "1/2/3/8"
					nAlicIcm := GETMV('IM_ICMIMP') // 4
				EndIf

			EndIf
		EndIf

		If nValIcmSt != 0
			nIcmRetido := NoRound(( nValIcmSt - ( nCalcIcm * ( nAlicIcm / 100) )),2)
		Else
			nIcmRetido := 0
		EndIf
		DbSelectArea("SYD");DbSeek(xFilial("SYD")+SB1->B1_POSIPI,.F.)

		//Inserido por Edivaldo Gonçalves Cordeiro em 30/11/2009
		If cFilant == '04' .AND. ( SF4->F4_CODIGO $ '540/721/724/723' ) // Chamado AAZUTY
			//Tratamento para Goiania
			nValICM		:= (nCalcICM * SF4->F4_BASEICM/100) * nAlicIcm / 100

		Else

			IF SF4->F4_PICMDIF == 0 //CRISTIANO DATA 28/11/08 // Reducao da Base do ICMS
				nValICM 	:= NoRound(( nAlicIcm      /100)	* ( nCalcIcm ),2)
			Else
				nValICM 	:= NoRound(( nAlicIcm      /100)	* ( nCalcIcm ),2)
				nValICM		:= nValICM - (nValICM * (SF4->F4_PICMDIF / 100 ))
			EndIf

			//Edivaldo
			If  SF4->F4_BASEICM<>0 .AND. SF4->F4_PICMDIF == 0
				nValICM 	:= NoRound(( nAlicIcm      /100)	* ( nCalcIcm ),2)
				nValICM		:= nValICM - (nValICM * (SF4->F4_BASEICM / 100 ))
			EndIf
			//Edivaldo

		EndIf

		IF SF4->F4_CREDICM <> 'S'

			nValICM := 0

		EndIf

		If SA1->A1_TIPO == 'F' //Cliente Final
			nValICM := NoRound(( 1 + (nAlicIpi /100) ) * ( nValICM ),2)
		EndIf

		//Aloquotas PIS e COFINS
		nAliqPis := Iif(SB1->B1_PPIS==0,GetMv("MV_TXPIS"),SB1->B1_PPIS)
		nAliqCof := Iif(SB1->B1_PCOFINS==0,GetMv("MV_TXCOFIN"),SB1->B1_PCOFINS)

		// Percentual de Reducao PIS e COFINS
		nRedPis := SB1->B1_REDPIS
		nRedCof := SB1->B1_REDCOF

		// Calculo do PIS e COFINS
		If SF4->F4_PISCOF == '1'

			nCalcPis	:= NoRound( ( ( nAliqPis - ( ( nAliqPis / 100 ) * nRedPis) ) / 100 ) * (NIcm_PIS) , 2 )
			nCalcCof    := 0
		ElseIf SF4->F4_PISCOF == '2'
			nCalcPis	:= 0
			nCalcCof	:= NoRound( ( ( nAliqCof - ( ( nAliqCof / 100 ) * nRedCof) ) / 100 ) * (NIcm_PIS) , 2 )

		ElseIf SF4->F4_PISCOF == '3'

			nCalcPis	:= NoRound( ( ( nAliqPis - ( ( nAliqPis / 100 ) * nRedPis) ) / 100 ) * (NIcm_PIS) , 2 )
			nCalcCof	:= NoRound( ( ( nAliqCof - ( ( nAliqCof / 100 ) * nRedCof) ) / 100 ) * (NIcm_PIS) , 2 )

		Else
			nCalcCof    := 0
			nCalcPis	:= 0
		EndIf

		// ZERAR PIS \ COFINS QUANDO Credita PIS/COFINS <> DEBITA
		// FABIANO PEREIRA - SOLUTIO 05/10/2015

		If SF4->F4_PISCRED != '2' // <> DEBITA
			nCalcCof    := 0
			nCalcPis	:= 0
		EndIf

		DbSelectArea("SC6")

		cUfFilOrig := SM0->M0_ESTENT /// UF filial origem...
		If ( lverSt )

			cFilAjuMar := GetMV("MV_UFAJMGR") // UF's que devem receber o ajuste no custo reposicao...

			If ( cUfFilOrig $ cFilAjuMar ) .AND. SF4->F4_CODIGO == '720'

				If cFilAnt == SM0->M0_CODFIL .AND. cUfFilOrig == SM0->M0_ESTENT

					nFATOR		:= U_FCalcIMC(cFilAnt,cLocalB2,SB1->B1_ORIGER,SB1->B1_ORIGEM,SB1->B1_IPI)
					_nCusMCR	:= _nCusMCR * NFATOR

				EndIf

			EndIf

		Else

			If (cFilAnt =='02' .AND. cUfFilOrig =='MT'  .AND. SA1->A1_EST='MT' .AND. !(SB1->B1_GRUPO $ "0008") ) //.AND. SB1->B1_INDUSTR='N' //QUANDO INDUSTRIAL FOR NAO

				nFATOR := U_FCalcIMC(cFilAnt,cLocalB2,SB1->B1_ORIGER,SB1->B1_ORIGEM,SB1->B1_IPI)
				_nCusMCR  := _nCusMCR * NFATOR    // Acrescimo Especifico para MT
			EndIf

			If (cFilAnt =='14' .AND. cUfFilOrig =='MG' .AND. !(SB1->B1_GRUPO $ "0011*0014*0015*0008") .AND. SA1->A1_EST='MG'  .AND. SB2->B2_LOCAL=='01')//.AND. SB1->B1_INDUSTR='N' ///QUAN INSDUSTRIAL FOR NAO

				nFATOR := U_FCalcIMC(cFilAnt,cLocalB2,SB1->B1_ORIGER,SB1->B1_ORIGEM,SB1->B1_IPI)
				_nCusMCR  := _nCusMCR * NFATOR    // Acrescimo Especifico para MT
			EndIf

		EndIf

		nImpostosnoVlrItem := nValICM + nCalcPis + nCalcCof + nICMRetido// ver funções padrões do siga

	Else
		nImpostosnoVlrItem := 0
	EndIf

	If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto ) .And.  Type("_oProcess") <> "U"
		nIdadeSC6 := U_IdadeAtu(nQtdItem,SB2->B2_IDADE,SB2->B2_DTIDADE) //PEGA A IDADE1 PARA GRAVAR NO SC6
		IF SB2->B2_IDIMDE=0

			_oProcess:IncRegua2("Idade - Definindo Idade do Produto ...")
			nIdade := SF4->(U_IdadeAtu(nQtdItem,SB2->B2_IDADE,SB2->B2_DTIDADE))

		Else

			_oProcess:IncRegua2("Idade - Definindo Idade do Produto ...")
			nIdade :=SF4->(U_IdadeAtu(nQtdItem,SB2->B2_IDIMDE,SB2->B2_DTCALC))

		EndIf
	Else

		IF SB2->B2_IDIMDE == 0
			If Type("_oProcess") <> "U"
				_oProcess:IncRegua2("Verificando IdadeAtu...")
			EndIf
			nIdade := U_IdadeAtu(nQtdItem,SB2->B2_IDADE,SB2->B2_DTIDADE)
		Else
			If Type("_oProcess") <> "U"
				_oProcess:IncRegua2("Verificando IdadeAtu...")
			EndIf
			nIdade := U_IdadeAtu(nQtdItem,SB2->B2_IDIMDE,SB2->B2_DTCALC)
		EndIf

		If Type("_oProcess") <> "U"
			_oProcess:IncRegua2("Verificando IdadeAtu...")
		EndIf

		nIdadeSC6 := U_IdadeAtu(nQtdItem,SB2->B2_IDADE,SB2->B2_DTIDADE)

	EndIf

	nTJLPdia  := (1+ (GetMV("MV_TJLP",,0) /100)/12)^(1/30) -1

	_nCOEFC:= SB2->B2_COEFC
	_nCOEFF:= SB2->B2_COEFF
	_nCOEFI:= ((1+ nTJLPdia)^nIdade) - 1

	nFat1 := (SB2->B2_COEFC/100)	*	_nCusMC
	nFat2 := (SB2->B2_COEFF/100)	*	_nCusMC
	nFat3 := _nCOEFI			*	(_nCusMC+ nfat1 + nfat2)

	nFatores := nFat1 + nFat2 + nFat3

	IF (xFilial(cTabCab) $ cMVFILFRT ) .AND. (!lCliVinc) .AND. !(lCliFEsp) .AND. cTpFrete <> 'F'

		nTotItemSemIPI  := nVlrItem + nRatDesp + nAcreCon + nValFrtA
	Else

		nTotItemSemIPI  := nVlrItem + nRatDesp + nAcreCon + nValFret
	EndIf

	//Custo médio kardex Gerencial
	_nCusMCg 			:=  nFatores + _nCusMC

	nTxFin  			:=  GETMV("MV_TXFIN",,0) / 100  // Similar a Taxa CDI , mas ao mês
	nValCPMF	    	:=  GETMV("MV_CPMF" ,,0)/100  * MaFisRet(_nItem,"IT_TOTAL")
	nPrazoMedioCobr 	:= 	SE4->E4_PRZMED //criar campo
	nTaxaDiaria 		:=  ((1 + nTxFin )^(1/30))-1
	nValorDeflacionado 	:=  (nTotItemSemIPI / ((1 + round(nTaxaDiaria,6)) ^ nPrazoMedioCobr ))

	nRedComis := (((n_COMIS1 + n_COMIS3 + n_COMIS4 + n_COMIS5 ) * 1.63 * (nVlrItem  + nAcreCon)) + ((n_COMIS2) * (nVlrItem  + nAcreCon))) / 100

	_nMC   := NOROUND(nValorDeflacionado - (_nCusMC  * nQtdItem + nImpostosnoVlrItem + nRedComis + nFreteItem))

	_nMCR  := nValorDeflacionado - ( _nCusMCR  * nQtdItem + nImpostosnoVlrItem + nRedComis + nFreteItem )

	If Type("_oProcess") <> "U"
		_oProcess:IncRegua2("Analisando Margem....")
	EndIf
	_nIMC   := U_ValMarg(_nMC  / (nTotItemSemIPI - nIcmRetido)  * 100) //Valida a margem para manter entre -999.99 e 999.99

	If Type("_oProcess") <> "U"
		_oProcess:IncRegua2("Analisando Margem....")
	EndIf

	_nIMCR  := U_ValMarg(_nMCR  / (nTotItemSemIPI - nIcmRetido) * 100)

	_nMCTot		+= _nMC 

	_nMCRTot	+= _nMCR

	_nQxITotal	+= nQtdItem * nIdade
	_nQtdITotal += nQtdItem
	_nTISIPI 	+= nTotItemSemIPI  //acumulador da base de icm dos itens do pedido

	// Log de variáveis para localizar diferença nos custos
	If lGeralog

		cGeraLog := ""
		cGeraLog +=	" Filial             -> "+ (SC6->C6_FILIAL) 				+ CRLF
		cGeraLog +=	" Pedido             -> "+ (SC6->C6_NUM) 					+ CRLF
		cGeraLog +=	" Nota               -> "+ (SC6->C6_NOTA) 					+ CRLF
		cGeraLog +=	" Cliente            -> "+ (SC6->C6_CLI) 					+ CRLF
		cGeraLog +=	" Produto            -> "+ (SB1->B1_COD) 					+ CRLF
		cGeraLog +=	" Ncm                -> "+ (SB1->B1_POSIPI) 				+ CRLF
		cGeraLog +=	" nVrcAcre           -> "+ cValToChar(nVrcAcre) 			+ CRLF
		cGeraLog +=	" n_COMIS1           -> "+ cValToChar(n_COMIS1) 			+ CRLF
		cGeraLog +=	" n_COMIS2           -> "+ cValToChar(n_COMIS2) 			+ CRLF
		cGeraLog +=	" n_COMIS3           -> "+ cValToChar(n_COMIS3) 			+ CRLF
		cGeraLog +=	" n_COMIS4           -> "+ cValToChar(n_COMIS4) 			+ CRLF
		cGeraLog +=	" n_COMIS5           -> "+ cValToChar(n_COMIS5) 			+ CRLF
		cGeraLog +=	" nValIcmSt          -> "+ cValToChar(nValIcmSt) 			+ CRLF
		cGeraLog +=	" nIcmRetido         -> "+ cValToChar(nIcmRetido) 			+ CRLF
		cGeraLog +=	" nValDesp           -> "+ cValToChar(nValDesp) 			+ CRLF
		//removido em 10/02/2015 em função de que as regras de desconto e acrescimo foram descontinuadas
		//		cGeraLog +=	" nAcreCon           -> "+ cValToChar(nAcreCon) 			+ CRLF
		cGeraLog +=	" nRedPis            -> "+ cValToChar(nRedPis) 				+ CRLF
		cGeraLog +=	" nRedCof            -> "+ cValToChar(nRedCof) 				+ CRLF
		cGeraLog +=	" nAliqCof           -> "+ cValToChar(nAliqCof) 			+ CRLF
		cGeraLog +=	" nAliqPis           -> "+ cValToChar(nAliqPis) 			+ CRLF
		cGeraLog +=	" nCalcCof           -> "+ cValToChar(nCalcCof) 			+ CRLF
		cGeraLog +=	" nCalcPis           -> "+ cValToChar(nCalcPis) 			+ CRLF
		cGeraLog +=	" nAlicIcm           -> "+ cValToChar(nAlicIcm) 			+ CRLF
		cGeraLog +=	" nCalcIcm           -> "+ cValToChar(nCalcIcm) 			+ CRLF
		cGeraLog +=	" nValICM            -> "+ cValToChar(nValICM) 				+ CRLF
		cGeraLog +=	" nTaxaDiaria        -> "+ cValToChar(nTaxaDiaria) 			+ CRLF
		cGeraLog +=	" nPrazoMedioCobr    -> "+ cValToChar(nPrazoMedioCobr) 		+ CRLF
		cGeraLog +=	" nTotItemSemIPI     -> "+ cValToChar(nTotItemSemIPI) 		+ CRLF
		cGeraLog +=	" nFreteCal          -> "+ cValToChar(nFreteCal) 			+ CRLF
		cGeraLog +=	" nValFret           -> "+ cValToChar(nValFret) 			+ CRLF
		cGeraLog +=	" nFreteItem         -> "+ cValToChar(nFreteItem) 			+ CRLF
		//removido em 10/02/2015 em função de que as regras de desconto e acrescimo foram descontinuadas
		//cGeraLog +=	" nVDescComis        -> "+ cValToChar(nVDescComis)			+ CRLF
		cGeraLog +=	" nImpostosnoVlrItem -> "+ cValToChar(nImpostosnoVlrItem)	+ CRLF
		cGeraLog +=	" nQtdItem           -> "+ cValToChar(nQtdItem)			 	+ CRLF
		cGeraLog +=	" _nCusMC           -> "+ cValToChar(_nCusMC) 			+ CRLF
		cGeraLog +=	" _nCusMCR          -> "+ cValToChar(_nCusMCR)			+ CRLF
		//removido em 10/02/2015 em função de que as regras de desconto e acrescimo foram descontinuadas
		//  		cGeraLog +=	" nAcrComExp         -> "+ cValToChar(nAcrComExp)			+ CRLF
		cGeraLog +=	" nMCR               -> "+ cValToChar(_nMCR)				+ CRLF
		cGeraLog +=	" nValCPMF           -> "+ cValToChar(nValCPMF) 			+ CRLF
		cGeraLog +=	" nValorDeflacionado -> "+ cValToChar(nValorDeflacionado) 	+ CRLF
		cGeraLog +=	" nMC                -> "+ cValToChar(_nMC) 					+ CRLF
		cGeraLog +=	" nIMC               -> "+ cValToChar(_nIMC)					+ CRLF

		cArquivo := "C:\LOG_CUSTO - "+SC6->C6_FILIAL+"_"+SC6->C6_NUM+"_"+SC6->C6_PRODUTO+"_PED.txt"

		Memowrit(cArquivo , cGeraLog )

	EndIf

	Return
	*******************************************************************************
User Function ValMarg(nPar)//| Valida o valor de margem para manter entre -999.99 e 999.99
	*******************************************************************************

	If nPar > 999.99 .or. nPar < -999.99
		nPar := (999.99) * IIF( nPar > 0 , 1 , -1 )
	Endif

	Return(nPar)

	////JULIO JACOVENKO, em 03/09/2018
	////ajustes no NMC x FRETE
	///

	///JULIO JACOVENKO, em 13/01/2016
	///

	///PARA GRAVAR MC nos itens do orçamento
	///
	///ATIVADO VIA F4 (via PE_TMKACTIVE)---
	///
	*************************************************************************
User Function FDEFMC()
	*************************************************************************
	Local aArea 		:= Getarea()
	Local aAreaSUA 		:= SUA->( Getarea() )
	Local aAreaSUB 		:= SUB->( Getarea() )
	Local aAreaSA1 		:= SA1->( Getarea() )
	Local aAreaSB1 		:= SB1->( Getarea() )
	Local aAreaSF4 		:= SF4->( Getarea() )
	Local aAreaSA3 		:= SA3->( Getarea() )
	Local aAreaSL4 		:= SL4->( Getarea() )
	Local aAreaSUW 		:= SUW->( Getarea() )
	Local aAreaSC6 		:= SC6->( Getarea() )
	Local aAreaSC5 		:= SC5->( Getarea() )
	Local aAreaSB2 		:= SB2->( Getarea() )
	Local xaItem 		:= Array(0)
	Local xaCab  		:= Array(0)
	Local cDescComis	:= GetMV("MV_COMIDES")
	Local cAcreComis	:= GetMV("MV_COMIACR")
	Local aSZE      	:= Array(0)
	Local lGeraSZE  	:= .F.
	Local lOk			:= .T.
	Local lVerST		:= .F.

	Local nX,nJ
	Local __cFilAnt // ,lOkItem
	Local aVendedores //,aOperador
	local nPos
	Local cProduto
	Local cLocalB2
	Local nItem		:= 0
	Local nIMC 		:= 0, nIMCg  		:= 0, nIMCR  		:= 0, nIMCUC 	:= 0, nIMCgTot	:= 0, nIMCRTot	:= 0, nQtdItem 	:= 0
	Local nCusMCg	:= 0, nMC			:= 0, nMCTot		:= 0, nMCgTot	:= 0, nMCRTot	:= 0, nMCUCTot	:= 0, nIMCTot	:= 0
	Local nIMCUCTot	:= 0, nMCR			:= 0, nCOEFI		:= 0, nCusMCUC	:= 0, nCusMCR	:= 0, nCusMC	:= 0
	Local nQtdTotal	:= 0, nIdadeTotal 	:= 0, nQxITotal 	:= 0, nQtdITotal:= 0, nTISIPI	:= 0, nCOEFC	:= 0, nCOEFF	:= 0

	Local lEnvMail := (Upper(GetMv('MV_ENVMAIL')) = 'SIM') //Informa se envia e-mail para os operadores para informar que a nota de transferencia foi entrada

	Local n_COMIS1 := 0
	Local n_COMIS2 := 0
	Local n_COMIS3 := 0
	Local n_COMIS4 := 0
	Local n_COMIS5 := 0
	
	Local oProcess := Nil

	Private lMsHelpAuto := .T. // se .T. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
	Private __cNumOrig

//	Private cCustoNF  := GetMV("MV_CUSTONF",," ")
//	Private lEstOner  := dDatabase >= GetMV("MV_ESTONER",,dDatabase+1)

	Private aLogComiss := {}

	Private cVend_1
	Private NIcm_PIS

	Private cCodCli:=''
	Private cLojCli:=''

	Private aComplRD := {}
	Private bAction
	Private bAnte
	Private lExecutaX:=.F.
	Private nP_PROD  := Ascan(aHeader, {|x| AllTrim( x[2] ) == "UB_PRODUTO"} )

	//Se não tiver sido informado o produto na linha dos itens , aborta a execução do F4
	If ( Empty(( Acols[n,nP_PROD])))
		Return(.T.)
	Endif

 
	_ljaCPIMC := .T. //MARCA QUE CHAMOU F4 PELO MENO UMA VEZ
	IF !__lJaBotPag2 .AND. _ljaCPIMC
		bAction := SETKEY(VK_F6)  //+SETKEY(K_ENTER)
		SUA->(EVAL(bAction))     //abre tela de condicao de pagametno
		bACTION:=SETKEY(VK_F6,bAction)  //joga a acao novamente no F6
	ENDIF

	MaFisAlt("NF_FRETE",aValores[4])

	U_MyTk273Refresh(.T.)

	IIF( !ExisteSX6('MV_FILFRT'),	CriarSX6('MV_FILFRT', 'C','Parametro utilizado no fonte PE_TMKVFIM,PRW' ,'') , )

	DbSelectArea("SU7");DbSetOrder(4) //U7_FILIAL+U7_CODUSU
	DbSeek(xFilial("SU7")+SU7->(RetCodUsr()))

	cVend_1    := SU7->U7_CODVEN
	cOperAtivo := SU7->U7_COD

	//³Posiciona a ordem dos arquivos                ³
	SZP->(dbSetOrder(1))	//Filial + Numero do Atendimento	(Nao precisa salvar ambiente desta  tabela,  eh especificas)
	SZQ->(dbSetOrder(1))	//Filial + Numero do Atendimento + Item  	(Nao precisa salvar ambiente desta  tabela,  eh especificas)
	ZZA->(dbSetOrder(1))
	DbSelectarea("SF7");DbSetOrder(1)
	dbSelectArea("SA1");dbSetOrder(1)     //CLIETNES
	dbSelectArea("SB1");dbSetOrder(1)     //PRODUTOS
	dbSelectArea("SB2");dbSetOrder(1)     //SALDO FISICO E FIN
	dbSelectArea("SC6");dbSetOrder(1)     //Itens Pedido de venca  --> ordem: C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	dbSelectArea("SE1")
	dbSelectArea("SE4");dbSetOrder(1);dbseek(xFilial("SE4")+M->UA_CONDPG)  // cONDICAO DE pAGAMENTO
	dbSelectArea("SF4");dbSetOrder(1)      //TES
	dbSelectArea("SA3");dbSetOrder(1)       // CADASTRO DE VENDEDORES
	dbSelectArea("SL4");dbSetOrder(1)	      //CAD CONDICAO NEGOCIADA
	dbSelectArea("SUB");dbSetOrder(1)      //ITENS DO ORCAMENTO TELEVENDAS
	dbSelectArea("SUW");dbOrderNickName('UW_PRODUTO')
	dbSelectArea("DC8");dbSetOrder(4)
	dbSelectArea("SUA");dbSetOrder(1)

	SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))

	//nItemSUB	:= 1
	NFaTOTIMC :=0
	NFTOTIMCR :=0
	nIni:=n
	Nitens:=0
	
	//--> Percorre Itens Acols 
	
	For nItens := 1 to Len(acols)
		
		nItem := nItens
		
		If !aCols[nItens,len(aHeader)+1]    ////tratar as linhas deletadas...

			SF4->(dbSeek(xFilial("SF4")+GDFIELDGET('UB_TES', nItens)))

			cProduto 	:= GDFIELDGET('UB_PRODUTO', nItem) //M->UB_PRODUTO
			cLocalB2	 	:= GDFIELDGET('UB_LOCAL', nItem) //M->UB_LOCAL
			nIdadeSC6   := 	0
			
			IF FUNNAME() == 'TMKA271' .AND. !Empty(GDFIELDGET('UB_FILTRAN', nItens))
				cFilialB2	:= GDFIELDGET('UB_FILTRAN', nItens)
				cLocalB2 	:= Posicione("SB1",1,cFilialB2+cProduto,"B1_LOCPAD")
			ELSE
				cFilialB2	:= xFilial('SB2')
				cLocalB2 	:= cLocalB2
			ENDIF

			SB2->(DbSeek(cFilialB2+cProduto+cLocalB2))
			SB1->(DbSeek(xFilial("SB1")+cProduto))

			//*********************************************************************
			//--> INICIO Calculo Custos
		
			//| Observacoes: CalCusBase()
			//| 	1 - Tabelas a serem Posicionadas: [SA1 , SB1 , SB2 , SUA , SUB , SE4, SF4 ]
			//| 	2 - Comissoes já devem ter sido Gravadas no SUB
		
		
			U_CalCusBase(lVerST, nItem, @oProcess, @nMC, @nMCR, @nIMC, @nIMCg, @nIMCR, @nIMCUC, @nCusMC, @nCusMCg, @nCusMCR, @nCusMCUC, @nMCTot, @nMCRTot, @nCOEFC, @nCOEFF, @nCOEFI, @nQxITotal, @nQtdITotal, @nTISIPI, @nIdadeSC6 )
	

			GDFieldPut('UB_MC'        , nMC        	, nItens) //M->UB_MC	:= nMC
			GDFieldPut('UB_MCR'       , nMCR      	, nItens) //M->UB_MCR	:= nMCR
			GDFieldPut('UB_IMC'       , nIMC       	, nItens) //M->UB_IMC	:= nIMC
			GDFieldPut('UB_IMCG'      , nIMCG      	, nItens) //M->UB_IMCG	:= nIMCG
			GDFieldPut('UB_IMCR'      , nIMCR      	, nItens) //M->UB_IMCR	:= nIMCR
			GDFieldPut('UB_IMCUC'     , nIMCUC     	, nItens) //M->UB_IMCUC	:= nIMCUC
			GDFieldPut('UB_CUSMC'     , nCusMC   	, nItens) //M->UB_CUSMC	:= nCusMC
			GDFieldPut('UB_CUSMCG'    , nCusMCg  	, nItens) //M->UB_CUSMCG:= nCusMCg
			GDFieldPut('UB_CUSMCR'    , nCusMCR  	, nItens) //M->UB_CUSMCR:= nCusMCR
			GDFieldPut('UB_CUSMCUC'   , nCusMCUC 	, nItens) //M->UB_CUSMCUC:= nCusMCUC
			GDFieldPut('UB_COEFC'     , nCOEFC     	, nItens) //M->UB_COEFC	:= nCOEFC
			GDFieldPut('UB_COEFF'     , nCOEFF     	, nItens) //M->UB_COEFF	:= nCOEFF
			GDFieldPut('UB_COEFI'     , nCOEFI     	, nItens) //M->UB_COEFI	:= nCOEFI

		EndIf  ///le somente as nao deletadas

	Next

	n := nIni

	M->UA_IMC 	:= U_ValMarg(nMCTot   / nTISIPI * 100)
	M->UA_IMCR 	:= U_ValMarg(nMCRTot  / nTISIPI * 100)


	//³Restaura o ambiente                                  ³
	Restarea(aAreaSUA)
	Restarea(aAreaSUB)
	Restarea(aAreaSA1)
	Restarea(aAreaSB1)
	Restarea(aAreaSF4)
	Restarea(aAreaSA3)
	Restarea(aAreaSL4)
	Restarea(aAreaSUW)
	Restarea(aAreaSC5)
	Restarea(aAreaSC6)
	Restarea(aAreaSB2)
	Restarea(aArea)

	_ljaCPIMC := .F.
	
Return(.T.)

