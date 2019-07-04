#include "topconn.ch"
#include "rwmake.ch"
#define  X_DOLAR  "2"
#Define  CRLF    (chr(13)+chr(10))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Raul                º Data ³  April/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a gravacao de Nota fiscal             º±±
±±º          ³                                                            º±±
±±ºAlteracao ³Gravacao dos campos E1_ENDOSSO,E1_CREDICM E E1_REEM,        º±±
±±º          ³campos estes para filtro na geracao do bordero. (O rela-    º±±
±±º          ³cionamento destes campos sao com o arquivo SUA.             º±±
±±º          ³Gravacao do lucro e margem nos arquivos SD2 e SE1           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para o cliente Imdepa                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Expedito    ³06/04/06³ Verificacao de inconsistencia nas tabelas e     ³±±
±±³            ³        ³ geracao de log.                                 ³±±
±±³MarcioQ.Borg³19/09/07³ Ajuste na amarração do itemSD2 com o acols      ³±±
±±³MarcioQ.Borg³20/05/08³ Desonera MC qdo Sit.Trib,considera icm retido   ³±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
*********************************************************************
User Function M460FIM(xHawb)
	*********************************************************************

	Local nAcreFin
	Local nAcreReal
	Local nDescLucro
	Local custoTotal       // custo total do produto vindo da planilha
	Local totLucro1 	:= 0     // Lucro total em reais
	Local lucro
	Local totalVenda 	:=0    // Valor total da venda
	Local cTpCust
	Local area 			:= GetArea()
	Local lGeralog := .F. // GetMv('IM_LOGCUST')  //AJUSTADO 27/12/2012 - CRISTIANO
	Local nPercFrete
	Local nFreteItem
	Local nDecVLRITEM := TamSx3("D2_PRCVEN")[2]  // TamSx3("UB_VLRITEM")[2]
	Local nDecBASEICM := TamSx3("D2_BASEICM")[2]
	Local _nFreteCf := 0


	Local nIMC 		:= 0, nIMCg  		:= 0, nIMCR  		:= 0, nIMCUC 	:= 0, nIMCgTot	:= 0, nIMCRTot	:= 0, nQtdItem 	:= 0
	Local nCusMCg	:= 0, nMC			:= 0, nMCTot		:= 0, nMCgTot	:= 0, nMCRTot	:= 0, nMCUCTot	:= 0, nIMCTot	:= 0
	Local nIMCUCTot	:= 0, nMCR			:= 0, nCOEFI		:= 0, nCusMCUC	:= 0, nCusMCR	:= 0, nCusMC	:= 0
	Local nQtdTotal	:= 0, nIdadeTotal 	:= 0, nQxITotal 	:= 0, nQtdITotal:= 0, nTISIPI	:= 0, nCOEFC	:= 0, nCOEFF	:= 0

	// By Jeferson (Pega os campos do arquivo SUA para posterior gravacao no SE1)
	Local _cEndosso := ''
	Local _cCredicm := ''
	Local _cReemb   := ''
	Local nSimD2Total, nSimDescLucro, nSimValDifICM, nSimPercFrete, nSimFreteItem, nSimLucro
	Local nFatores
	Local nIdadeSC6   := 0
	
	Local _cNumLig := Space(6)
	Local _cFilLig := Space(2)
	Local _cNumSUA := Space(6)

	Local lVerST   := .F.
	Local oProcess := Nil
			
	Private cImdepa := GetMv('MV_IMDEPA') //CODIGO DA IMDEPA NO CADASTRO DE CLIENTES (SA1) E DE FORNECEDORES (SA2), PARA FINS DE TRANSFERENCIA ENTRE FILIAIS.

	Private  aItensTransf   :={}
	Private  nDescIcmPad	:= 0
	Private  nValDifICM	 	:= 0
	Private  nDescComExp	:= 0
	Private  nAcrComExp     := 0
	Private NIcm_PIS        :=0

	Public cUFOri := " "

	// incluido por Luciano Correa em 19/03/04 para gravar natureza em ndfs...
	Private Ind_SE2, Rec_SE2, cNaturez

	Private cCustoNF  := GetMV("MV_CUSTONF",," ")

	PRIVATE cNOTA   := SF2->F2_DOC
	PRIVATE cSERIE  := SF2->F2_SERIE
	PRIVATE cCLIENTE:= SF2->F2_CLIENTE
	PRIVATE cLOJA   := SF2->F2_LOJA

	//SF2->F2_DOC+SF2->F2_SERIE+F2_CLIENTE+F2_LOJA+

	//GetEnvServer()

	Private oErrorJK := ErrorBlock({|e| DeuErro(e:Description,CNOTA,CSERIE,cCLIENTE,cLOJA)})


	Begin Sequence    // Força erro, enviando caracter onde deveria ser numérico

		VerIncons()

		If SF2->F2_TIPO == 'D' .and. SE2->E2_TIPO == 'NDF' .and. ;
		( SF2->F2_SERIE + SF2->F2_DOC + SF2->F2_CLIENTE + SF2->F2_LOJA ) == ;
		( SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_FORNECE + SE2->E2_LOJA )

			// busca natureza do titulo de origem
			Ind_SE2 := SE2->( IndexOrd() )
			Rec_SE2 := SE2->( Recno() )

			//	SE2->( dbSetOrder( 1 ) )
			SE2->( dbSetOrder( 6 ) )

			// na Imdepa estah configurado para o titulo nao ser gerado com o prefixo igual a serie ( considero errado )...
			SE2->( dbSeek( xFilial( 'SE2' ) + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_SERIORI + SD2->D2_NFORI, .f. ) )
			//	SE2->( dbSeek( xFilial( 'SE2' ) + &( GetMv( "MV_2DUPREF" ) ) + SD2->D2_NFORI, .f. ) )
			IF !FOUND()  //  Compatiblizar para encontrar os titulos  gerados com os prefixos das filias, antes da alteração do parametro MV_2DUPREF para SF1->F1_SERIE em 14/02/2013
				SE2->( dbSeek( xFilial( 'SE2' ) + SD2->D2_CLIENTE + SD2->D2_LOJA + ALLTRIM(POSICIONE("SX5",1, XFILIAL("SX5")+"Z3"+SD2->D2_FILIAL , "X5_DESCRI")) + SD2->D2_NFORI, .f. ) )
			ENDIF
			cNaturez := SE2->E2_NATUREZ

			SE2->( dbSetOrder( Ind_SE2 ) )
			SE2->( dbGoTo( Rec_SE2 ) )

			// grava natureza
			SE2->( RecLock( 'SE2', .f. ) )
			SE2->E2_NATUREZ := cNaturez
			SE2->( MsUnlock() )
		EndIf

		_cNumLig := SC5->C5_NUM

		_cFilLig := SC5->C5_FILIAL

		cQUERY:=""

		cQUERY+=" SELECT * FROM "+RetSqlName('SUA')+" SUA ,"+RetSqlName('SC5')+" SC5 "
		cQUERY+=" WHERE SUA.UA_NUMSC5='"+_cNumLig+"' "
		cQUERY+=" AND SUA.UA_FILIAL='"+_cFilLig+"' "
		cQUERY+=" AND SUA.UA_CLIENTE=SC5.C5_CLIENTE "
		cQUERY+=" AND SUA.UA_LOJA=SC5.C5_LOJACLI "
		cQUERY+=" AND SC5.D_E_L_E_T_<>'*' "
		cQUERY+=" AND SUA.D_E_L_E_T_<>'*' "
		cQUERY+=" AND SC5.C5_NUM=SUA.UA_NUMSC5 "
		cQUERY+=" AND SC5.C5_FILIAL=SUA.UA_FILIAL "

		cQuery := ChangeQuery(cQuery)
		TCQUERY cQuery NEW ALIAS "TSUA"
		Do While TSUA->(!EOF())
			_cNumSUA:=TSUA->UA_NUM
			TSUA->(dBSkip())
		EndDo
		TSUA->(DBCloseArea())

		DbSelectarea("SUA");DbSetOrder(1)
		If DbSeek(xFilial("SUA")+_cNumSUA)
			// By Jeferson (Pega os campos do arquivo SUA para posterior gravacao no SE1)
			_cEndosso := SUA->UA_ENDOSSO
			_cCredicm := SUA->UA_CREDICM
			_cReemb   := SUA->UA_REEMB
			_nFreteCf := SUA->UA_FRETCAL

			Reclock("SUA",.F.)
			SUA->UA_DOC   := SF2->F2_DOC 		// SC9->C9_NFISCAL
			SUA->UA_SERIE := SF2->F2_SERIE 		// SC9->C9_SERIENF
			SUA->UA_EMISNF:= SF2->F2_EMISSAO    // SC9->C9_DATALIB
			SUA->UA_STATUS:= "NF."
			SUA->UA_STPB2B:= "A" //Atualizar enviar novamente ao B2B
			MsUnlock()
		Endif

		// Edivaldo Gonlcalves Cordeiro  |Envio dos Boletins de Entrada
		If SF2->F2_CLIENTE==cImdepa .AND. SF4->F4_ESTOQUE = 'S' .AND. SF2->F2_TIPO $ 'ND'  //Nota de Transferência , avisa vendedores da entrada dos produtos na filial

			SF2->(fItensBoletim())

			If Len(aItensTransf)>0
				SF1->(U_SendNfTrf(SF2->F2_FILIAL,SF2->F2_CLIENTE,SF2->F2_LOJA,aItensTransf,'SF2'))
			EndIf

		Endif

		If SF2->F2_CLIENTE==GetMv('MV_IMDEPA') .AND. SF2->F2_LOJA <> SF2->F2_FILIAL //Fazer somente quando for para outra filial. Notas para a mesma filial sao nota de ajuste do fiscal. Chamado 0017259

			U_PRENFTRF("I",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_FILIAL,SF2->F2_LOJA) //Gera pre-nota de entrada na filial destino - Agostinho Lima - 01/06/2016

		Endif

		//Atualiza a tabela de combustiveis (CD6) , graxas, com o codiog ANP. Chamado 19252 - 23/10/2017
		U_MovCD6ANP("INC","S",SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_EMISSAO)

		// Somente quando atualiza financeiro e quando for nota de venda
		If SF4->F4_DUPLIC <> 'S' .or. SF2->F2_TIPO $ 'BD'

			IF SF2->F2_CLIENTE == cImdepa //IDADE TRANFERENCIA - Agostinho 05/08/2014

				dbSelectArea("SD2");dbSetOrder(3) // filial+doc+serie
				dbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE )
				Do While  SD2->(!Eof()) .AND. SD2->D2_FILIAL == xFilial('SD2') .AND. SD2->D2_DOC == SF2->F2_DOC  .AND. SD2->D2_SERIE == SF2->F2_SERIE

					Reclock("SD2",.F.)
					//D2_IDADE  := POSICIONE("SC6",1,xFilial('SC6')+SD2->D2_PEDIDO+SD2->D2_ITEMPV,"C6_IDADE2")
					//D2_IDIMDE := u_IdadeAtu(SD2->D2_QUANT,POSICIONE("SB2",1,XFILIAL("SB2")+SD2->D2_COD+SD2->D2_LOCAL,"B2_IDADE"),POSICIONE("SB2",1,XFILIAL("SB2")+SD2->D2_COD+SD2->D2_LOCAL,"B2_DTIDADE"))
					D2_IDADE  := u_IdadeAtu(SD2->D2_QUANT,POSICIONE("SB2",1,XFILIAL("SB2")+SD2->D2_COD+SD2->D2_LOCAL,"B2_IDADE"),POSICIONE("SB2",1,XFILIAL("SB2")+SD2->D2_COD+SD2->D2_LOCAL,"B2_DTIDADE"))
					D2_IDIMDE := POSICIONE("SC6",1,xFilial('SC6')+SD2->D2_PEDIDO+SD2->D2_ITEMPV,"C6_IDADE2")
					MsUnlock()
					SD2->(dbSkip())
				Enddo

			ENDIF
			RestArea( area )
			Return

		Endif

		// Define o desconto de ICMS padrao 
		dbSelectArea('SA1')
		dbSetOrder(1) // filial+codigo+loja

		DBSEEK(xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA)

		If Empty( SA1->A1_EST )
			Alert("O estado do cliente ["+SF2->F2_CLIENTE+"] loja ["+SF2->F2_LOJA+"] nao foi informado, acione o suporte Microsiga.")
		EndIf

		If Empty(SA1->A1_FLADR) // Agostinho 18/04/2017 - Chamado 16002 do Robson H. - Atualiza o campo A1_FLADR com o ano da primeira compra do cliente sem consideraer a loja

			Reclock("SA1",.F.)
			SA1->A1_FLADR := ATUFLADR()
			MsUnlock()

		Endif

		///| Chamado: 21375  Data: 22/05/18 Analista: Cristiano Machado
		///| Atualiza todas as informaçòes estatisticos dos clientes (Maior Compra, Titulos em Aberto, Saldo em Pedidos e etc... )
		StartJob( cName := "U_PvSldFin", cEnv := GetEnvServer(), lWait := .F., cPar01 := SA1->A1_COD, cPar02 := SA1->A1_LOJA )
		//| Fim 21375

		//Grava o campo especifico F2_FILCLI                   ³
		Reclock("SF2",.F.)
		SF2->F2_FILCLI := SA1->A1_FILCLI
		MsUnlock()

		dbSelectArea('SC5');dbSetOrder(1) // filial+pedido

		dbSelectArea('SC6');dbSetOrder(1) // filial+pedido+item

		dbSelectArea("SB1");dbSetOrder(1) // Produtos

		dbSelectArea('SB2');dbSetOrder(1) // B2_FILIAL+B2_COD+B2_LOCAL

		///ORDER 18
		dbSelectArea('SD2');dbOrderNickName("SD2ITEM") //dbSeDbOrderNickName("SD2ITEM")

		dbSeek( xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+'01' ) //FORCA POSICIONAR NO ITEM 01
		//POIS TEM DE TER PELO MENOS
		//UM ITEM

		cTabPreco 	:= SC5->C5_TABELA
		cMoeda		:= SC5->C5_MOEDA
		cCondPag 	:= SF2->F2_COND

		aItemSD2 := ITEMSD2( xFilial('SD2'),SF2->F2_DOC,SF2->F2_SERIE)

		dbSelectArea("SE4");dbSetOrder(1);dbseek(xFilial("SE4")+cCondPag)  // cONDICAO DE pAGAMENTO

		nItemSD2	:= 0

		Do While  SD2->(!Eof()) .AND. SD2->D2_FILIAL == xFilial('SD2') .AND. SD2->D2_DOC == SF2->F2_DOC  .AND. SD2->D2_SERIE == SF2->F2_SERIE
			//	nItemSD2 := ITEMSD2(SD2->D2_ITEM)

			nItemSD2 := aScan(aItemSD2, SD2->D2_ITEM)

			//------> Posiciona nas Tableas

			// localiza a tabela de precos utilizada
			SC5->( MsSeek( xFilial('SC5')+SD2->D2_PEDIDO,.F. ))

			// localiza o custo da embalagem
			SC6->( MsSeek( xFilial('SC6')+SD2->D2_PEDIDO+SD2->D2_ITEMPV,.F. ))

			//³Posicionando de TES	         			     ³
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
			//-----> Carrega variaveis

			cProduto 	:= SD2->D2_COD
			cLocal	 	:= SD2->D2_LOCAL
//			nVlrItem 	:= SD2->D2_PRCVEN  //TOTAL DA LINHA COM ACRESCIMO
//			nBASEICM 	:= SD2->D2_BASEICM
			nQtdItem 	:= SD2->D2_QUANT
//			nDescIcm 	:= SC6->C6_DESCICM
//			nFreteCal 	:= SF2->F2_FRETE
//			nValmerc 	:= SF2->F2_VALMERC //VALOR TOTAL DAS MERCADORIAS COM ACRESCIMMO DA CONDIÇÃO DE PAGAMENTO
//			nDespesa	:= SF2->F2_DESPESA

			///IDADE FILIAL
//			nIdade 		:= 0
//			nFreteFob   := SUA->UA_FRETFOB  // Redespacho
			

			///JULIO JACOVENKO, em 25/01/2012
			///Projeto Idade Imdepa
			///
			nIdade2     := 0   //VARIAVEL PADRÃO PARA IDADE2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posicionando Produtos         			     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			SB1->(DbSeek(xFilial("SB1")+cProduto+cLocal))

			SB1->(DesICMPad(SA1->A1_EST))

			SB2->( MsSeek( xFilial('SB2')+cProduto+cLocal,.F. ))  //busco o armazem da nota (local)

			nItemacols 	:= 0
			nItem 		:= 	nItemSD2

			// CALCULO DAS COMISSOES

			n_COMIS1 := SC6->C6_COMIS1
			n_COMIS2 := SC6->C6_COMIS2
			n_COMIS3 := SC6->C6_COMIS3
			n_COMIS4 := SC6->C6_COMIS4
			n_COMIS5 := SC6->C6_COMIS5


			//*********************************************************************
			//--> INICIO Calculo Custos

			//| Observacoes: CalCusBase()
			//| 	1 - Tabelas a serem Posicionadas: [SA1 , SB1 , SB2 , SC5, SC6, SUA , SD2 , SE4, SF4 ]
			//| 	2 - Comissoes já devem ter sido Gravadas no SUB

			U_CalCusBase(lVerST, nItem, @oProcess, @nMC, @nMCR, @nIMC, @nIMCg, @nIMCR, @nIMCUC, @nCusMC, @nCusMCg, @nCusMCR, @nCusMCUC, @nMCTot, @nMCRTot, @nCOEFC, @nCOEFF, @nCOEFI, @nQxITotal, @nQtdITotal, @nTISIPI, @nIdadeSC6 )
		
			// REMOVIDO
			
			RecLock('SD2',.F.)

			Replace SD2->D2_MC    with nMC,		 SD2->D2_MCR    with nMCR

			//Grava Indices das Margens
			Replace SD2->D2_IMC   with nIMC,		SD2->D2_IMCR   with nIMCR

			//Grava Custos das Margens
			Replace SD2->D2_CUSMC with nCusMC, 	SD2->D2_CUSMCR with nCusMCR

			//Grava Coeficientes
			Replace SD2->D2_COEFC with nCOEFC,		SD2->D2_COEFF  with nCOEFF   , SD2->D2_COEFI   with nCOEFI

			//Grava Idade Filial
			Replace SD2->D2_IDADE with nIdadeSC6
			

			///busca no SC6 o conteudo do C6_IDADE2
			nIdade2:=0
			if SC6->( MsSeek( xFilial('SC6')+SD2->D2_PEDIDO+SD2->D2_ITEMPV,.F. ))
				nIdade2:=SC6->C6_IDADE2
			endif

			Replace SD2->D2_IDIMDE with nIdade2

			CNFCI := ''
			CNFCI := ALLTRIM(SD2->(Posicione("ZA7",1,SD2->D2_FILIAL+SD2->D2_COD,"ZA7_IMDFCI")))

			Replace SD2->D2_FCICOD with CNFCI
			///////////////////////////////////////////////////////////////////

			MsUnlock()

			SD2->(dbSkip())

		Enddo
		
		//--> FIM Calculo Custos
		//*************************
		

		nIMCTot 	:= U_ValMarg(nMCTot   / nTISIPI * 100)
		nIMCgTot	:= U_ValMarg(nMCgTot  / nTISIPI * 100)

		SF2->(Reclock("SF2",.F.))
		SF2->F2_IMC		:= nIMCTot
		SF2->F2_IMCG	:= nIMCgTot
		SF2->F2_IDADE	:= nQxITotal / nQtdITotal
		SF2->(MsUnlock())

		dbSelectArea('SE1')
		dbSetOrder(1)


		// Calcula o total a receber da nota
		dbSeek( xFilial('SE1')+SF2->F2_SERIE + SF2->F2_DOC )
		Do While !Eof() .AND. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial('SE1')+SF2->F2_SERIE+SF2->F2_DOC
			IF !('-' $ SE1->E1_TIPO )    // desconsidera descontos antecipados
				totalVenda += SE1->E1_VALOR
			ENDIF
			dbSkip()
		Enddo




		//******************* CONTAS A RECEBER (SE1) *****************************************************************

		// Atualiza as parcelas do contas a receber  com o valor ponderado do lucro
		dbSeek( xFilial('SE1')+SF2->F2_SERIE + SF2->F2_DOC )
		Do While !Eof() .AND. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial('SE1')+SF2->F2_SERIE+SF2->F2_DOC
			RecLock('SE1',.F.)
			SE1->E1_LUCRO1 := ( totLucro1 *  SE1->E1_VALOR ) / totalVenda
			SE1->E1_LUCRO2 := ConvMoeda( SF2->F2_EMISSAO, , SE1->E1_LUCRO1 , X_DOLAR )

			// By Jeferson (Pega os campos do arquivo SUA para posterior gravacao no SE1)
			SE1->E1_ENDOSSO := _cEndosso
			If Empty(SE1->E1_PARCELA) .Or. SE1->E1_PARCELA='A'  .Or. SE1->E1_PARCELA='1'
				SE1->E1_CREDICM := _cCredicm
			Endif
			SE1->E1_REEMB   := _cReemb

			// grava flag indicando se o titulo se trata de um Vendor do Contas a Receber
			If SE4->E4_VENDORR == "1"
				SE1->E1_VENDORR := "S"
				SE1->E1_HIST := "VENDOR"
			Endif
			MsUnlock()
			dbSkip()
		Enddo

		U_IMDA1600(SF2->F2_DOC,SF2->F2_SERIE)

		////JULIO JACOVENKO, em 18/01/2018
		////
		/////AQUI VAMOS AJUSTAR O CAMPO SA1->A1_CLIFRTE='2'

		IF UPPER(SA1->A1_CLIFRTE) =='Y'
			DbSelectArea("SA1")
			RecLock("SA1",.F.)
			SA1->A1_CLIFRTE		:= "0"
			MsUnlock()
		ENDIF

	End Sequence

	ErrorBlock(oErrorJK)

	RestArea( area )

	Return()

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³VERINCONS ³ Autor ³ Expedito Mendonca Jr  ³ Data ³06/06/2006³±±

	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³ Faz a verificacao de inconsistencias entre as tabelas      ³±±
	±±³          ³ SD2 e SC9 e, se houver, gera log. O objetivo desta funcao  ³±±
	±±³          ³ eh identificar a origem de problemas na quantidade         ³±±
	±±³          ³ reservada dos produtos (B2_RESERVA).                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ VERINCONS()                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Nenhum                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ NIL                                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³            ³        ³                                                 ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
	*********************************************************************
Static Function VERINCONS()
	*********************************************************************

	Local cQuery, cArea, aAreaSC9, nHdlLog, lTemSC9

	If GETMV("ES_LOGINC")

		// Salva a area atual
		cArea := alias()
		aAreaSC9 := SC9->(Getarea())

		SC9->(dbSetOrder(1))	// C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

		IF SELECT( 'TRB' ) <> 0
			dbSelectArea('TRB')
			Use
		Endif

		// Verifica se houve inconsistencias entre as tabelas SD2 e SC9
		// Monta a query para selecionar registros inconsistentes
		cQuery := "SELECT D2_FILIAL, D2_SERIE, D2_DOC, D2_CLIENTE, D2_LOJA, D2_ITEM, D2_COD, D2_LOCAL, D2_QUANT, D2_PEDIDO, D2_ITEMPV, D2_SEQUEN "
		cQuery += " FROM "+RetSqlName('SD2')+" SD2"
		// Filtra os itens desta nota fiscal
		cQuery += " WHERE D2_FILIAL = '"+SF2->F2_FILIAL+"'"
		cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"'"
		cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"'"
		cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"'"
		cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"'"
		cQuery += " AND SD2.D_E_L_E_T_ = ' '"
		// Verifica se existe o registro correspondente e correto na tabela SC9
		cQuery += " AND NOT EXISTS ("
		cQuery += 	" SELECT C9_PEDIDO"
		cQuery += 	" FROM "+RetSqlName('SC9')+" SC9"
		cQuery +=	" WHERE C9_FILIAL = SD2.D2_FILIAL"
		cQuery += 	" AND C9_PEDIDO = SD2.D2_PEDIDO"
		cQuery += 	" AND C9_ITEM = SD2.D2_ITEMPV"
		cQuery +=	" AND C9_PRODUTO = SD2.D2_COD"
		cQuery +=	" AND C9_NFISCAL = SD2.D2_DOC"
		cQuery +=	" AND C9_SERIENF = SD2.D2_SERIE"
		cQuery += 	" AND C9_BLEST = '10'"
		cQuery +=	" AND C9_BLCRED = '10'"
		cQuery +=	" AND SC9.D_E_L_E_T_ = ' ' )"
		// Executa a query
		//	MEMOWRIT( "\m460fim.sql", cQuery )
		dbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery ),'TRB',.T.,.T.)
		TCSetField('TRB','D2_QUANT','N',14,4)

		dbSelectArea("TRB")
		If !Eof()

			// Inconsistencias encontradas. Em cada inconsistencia, podem haver 2 possibilidades: Nao haver registro no SC9 ou haver registro no SC9 errado
			// Faz a gravacao do log de inconsistencia na geracao da NF
			If File("\incgernf.log")
				nHdlLog := fOpen("\incgernf.log",2)
				fSeek(nHdlLog,0,2)
			Else
				nHdlLog:=fCreate("\incgernf.log",0)
				fWrite(nHdlLog,"DATA     HORA     FILIAL SERIE DOCUMENTO CLIENTE LOJA ITEM PRODUTO         LOCAL QUANTIDADE PEDIDO ITEMPV SEQUENCIA C9_NFISCAL C9_SERIENF C9_BLEST C9_BLCRED"+CRLF)
				fWrite(nHdlLog,"------------------------------------------------------------------------------------------------------------------------------------------------------------"+CRLF)
			Endif

			// Grava log de cada inconsistencia encontrada
			Do While !Eof()

				// Verifica se ha ou nao registro no SC9
				lTemSC9 := .F.
				dbSelectArea("SC9")
				dbSeek(TRB->D2_FILIAL+TRB->D2_PEDIDO+TRB->D2_ITEMPV,.F.)
				Do While C9_FILIAL+C9_PEDIDO+C9_ITEM == TRB->D2_FILIAL+TRB->D2_PEDIDO+TRB->D2_ITEMPV .and. !Eof()
					If SC9->C9_PRODUTO == TRB->D2_COD
						lTemSC9 := .T.
						exit
					Endif
					dbSkip()
				Enddo
				If !lTemSC9
					dbGoBottom()
					dbSkip()
				Endif

				fWrite(nHdlLog,dtoc(date())+" "+time()+" "+PadR(TRB->D2_FILIAL,6)+" "+PadR(TRB->D2_SERIE,5)+" "+PadR(TRB->D2_DOC,9)+" "+;
				PadR(TRB->D2_CLIENTE,7)+" "+PadR(TRB->D2_LOJA,4)+" "+PadR(TRB->D2_ITEM,4)+" "+TRB->D2_COD+" "+PadR(TRB->D2_LOCAL,5)+" "+;
				Transform(TRB->D2_QUANT,"@E 999,999.99")+" "+TRB->D2_PEDIDO+" "+PadR(TRB->D2_ITEMPV,6)+" "+PadR(TRB->D2_SEQUEN,9)+" "+;
				PadR(SC9->C9_NFISCAL,10)+" "+PadR(SC9->C9_SERIENF,10)+" "+PadR(SC9->C9_BLEST,8)+" "+PadR(SC9->C9_BLCRED,9)+CRLF)

				dbSelectArea("TRB")
				dbSkip()

			Enddo

			// Fecha o arquivo de log e o cursor
			fClose(nHdlLog)

		Endif

		TRB->(dbCloseArea())
		// Restaura a area
		Restarea(aAreaSC9)
		dbSelectArea(cArea)

	Endif

	Return NIL
	*********************************************************************
Static Function ITEMSD2(_Filial,_DOC,_SERIE)
	*********************************************************************

	aItemSD2:={}

	cQuery :=   " "
	//cQuery +=	" SELECT D2.*,ROWNUM N_NUMITEM FROM "
	//cQuery +=	" ("
	cQuery +=	" SELECT  D2_ITEM C_D2_ITEM FROM " + RetSqlName("SD2") + " D2 "
	cQuery +=	"    WHERE D2_DOC = '" + _DOC + "' AND "
	cQuery +=	"		     D2_FILIAL ='"+ _Filial + "' AND "
	cQuery +=	"		     D2_SERIE ='" + _SERIE +  "' AND "
	cQuery +=	"		     D2.D_E_L_E_T_ != '*' "
	cQuery +=	"    ORDER BY D2_DOC, D2_ITEM
	//cQuery +=	" ) D2"

	IF SELECT( '__ITEMS' ) <> 0
		dbSelectArea('__ITEMS')
		Use
	Endif

	TCQuery cQuery NEW ALIAS ('__ITEMS')

	DO WHILE   !__ITEMS->(EOF())
		AADD(aItemSD2,C_D2_ITEM) //	AADD(aItemSD2,{C_D2_ITEM,N_NUMITEM})
		__ITEMS->(DBSKIP())
	ENDDO
	DbSelectArea('__ITEMS')
	DBCloseArea()

	Return aItemSD2
	*********************************************************************
Static Function DesIcmPad(cDestino)
	*********************************************************************
	Local aArea     := GetArea()
	Local aAreaSA1  := SA1->( GetArea() )
	Local nRecnoSA1 := SA1->( RECNO())
	//Local cImdepa   := GetMv('MV_IMDEPA') //CODIGO DA IMDEPA NO CADASTRO DE CLIENTES (SA1) E DE FORNECEDORES (SA2), PARA FINS DE TRANSFERENCIA ENTRE FILIAIS.
	Local cOrigem
//	LOCAL nOld

	Public cUFOri := " "
	//cFilAnt -> variavel publica do sistema,	Número da Filial que está em uso no momento.

	// recupero a UF de origem
	dbSelectArea('SA1');dbSetOrder(1)
	dbSeek(xFilial('SA1')+cImdepa+cFilAnt)
	cOrigem := SA1->A1_EST

	// determino o percentual de desconto de ICMS padrao na tabela DESCONTO DE ICMS
	dbSelectArea('SZW');dbSetOrder(1)
	If dbSeek(xFilial('SZW') + cOrigem + cDestino)
		///JULIO JACOVENKO....
		///21/12/2012 - PARA AJUSTAR DESCONTO ICM

		LIMP:=.F.
		CPRODUTO := SB1->B1_COD    //gdFieldGet( "UB_PRODUTO", N ) //SB1->B1_COD
		cIMPNAC:=SA1->(POSICIONE('SB1',1,XFILIAL('SB1')+CPRODUTO,'B1_ORIGEM'))
		LIMP:=(CIMPNAC='1' .OR. CIMPNAC='2')

		if !LIMP //e nacional
			nDescIcmPad	:= SZW->ZW_DESCONT
		else     //e importado
			nDescIcmPad	:= SZW->ZW_DESCIMP
		endif

		//nDescIcmPad	:= SZW->ZW_DESCONT
		nDescComExp := SZW->ZW_DESCEXP

	Else
		If Type("l410Auto") != "U" .And. !l410Auto
			//u_Mensagem("O desconto de ICMS padrão para vendas com origem em "+cOrigem+" e destino "+cDestino+" não está cadastrado.")
			Final("Erro ao gravar pedido de venda.")

			ConOut("O desconto de ICMS padrão para vendas com origem em "+cOrigem+" e destino "+cDestino+" não está cadastrado.")
			ConOut("Erro ao gravar pedido de venda.")
		EndIf
		nDescIcmPad	:= 0
		nDescComExp := 0
	EndIf

	//³ Armazena o estado de origem para calc da margem³
	cUFOri := cOrigem

	RestArea(aAreaSA1)
	DBGOTO(nRecnoSA1)
	RestArea(aArea)

	Return()

	//*-----------------------------------------------------------------------------------//
	//|Programa..: cComisPorOperador()
	//|Autor.....: Edivaldo Gonçalves Cordeiro
	//|Data......: 13/05/2010
	//|Descricao.: Atualiza comissão por Operador na gravação da Nota Fiscal
	//|Observação:
	//+-----------------------------------------------------------------------------------//
/*	*--------------------------------------------------*
Static Function cComisPorOperador(cVendInt,cNumSE3)
	*--------------------------------------------------*

	Local cNewVend     :=' '
	Local cSql         :=' '
	Local nDifComis    :=0
	Local nPerComVenda :=0

	DbSelectarea("SUA");DbSetOrder(1)

	If DbSeek(xFilial("SUA")+SC5->C5_NUMSUA)
		If Empty(SUA->UA_OPERAD2) .OR. SUA->UA_OPERAD2=SUA->UA_OPERADO .OR. SA1->A1_GERVEN <> '000685'   //-------Não há dois operadores,portando não precisa gerar a segunda comissão.
			Return
		Else
			cNewOperador:= SUA->UA_OPERAD2
			cNewVend    := POSICIONE("SU7",1,XFILIAL("SU7") + SUA->UA_OPERAD2, "U7_CODVEN")

			If cNewVend=cVendInt
				cNewVend    := POSICIONE("SU7",1,XFILIAL("SU7") + SUA->UA_OPERADO, "U7_CODVEN")
			Endif

			SE3->( dbSetorder( 1 ) )

			IF SE3->( dbSeek( xFilial("SE3") + SE3->E3_PREFIXO + SE3->E3_NUM + SE3->E3_PARCELA + SE3->E3_SEQ +  cVendInt , .T. ) )

				cNumSE3    :=SE3->E3_NUM
				cEmissSE3  :=SE3->E3_EMISSAO
				cSerie     :=SE3->E3_SERIE
				cCodCli    :=SE3->E3_CODCLI
				cLojaCli   :=SE3->E3_LOJA
				nBaseSe3   :=SE3->E3_BASE
				nE3PORC    :=SE3->E3_PORC
				nValComis  :=SE3->E3_COMIS
				dDataSE3   :=SE3->E3_DATA
				cPrefixoSE3:= SE3->E3_PREFIXO
				cParcelaSE3:= SE3->E3_PARCELA
				cTipoSE3   := SE3->E3_TIPO
				cPedidoSE3 := SE3->E3_PEDIDO
				cVencSE3   := SE3->E3_VENCTO
				cOrigSE3   := SE3->E3_ORIGEM
				cE3_BAIEMI := SE3->E3_BAIEMI

				SE3->( RecLock( 'SE3', .T. ) )
				SE3->E3_FILIAL   := Xfilial("SE3")
				SE3->E3_VEND 	 := cNewVend
				SE3->E3_NUM      := cNumSE3
				SE3->E3_EMISSAO  := cEmissSE3
				SE3->E3_SERIE    := cSerie
				SE3->E3_CODCLI   := cCodCli
				SE3->E3_LOJA     := cLojaCli
				SE3->E3_BASE     := nBaseSe3
				SE3->E3_PORC     := nE3PORC
				SE3->E3_COMIS    := nValComis
				SE3->E3_DATA     := dDataSE3
				SE3->E3_PREFIXO  := cPrefixoSE3
				SE3->E3_PARCELA  := cParcelaSE3
				SE3->E3_TIPO     := cTipoSE3
				SE3->E3_PEDIDO   := cPedidoSE3
				SE3->E3_VENCTO   := cVencSE3
				SE3->E3_ORIGEM	 := cOrigSE3
				SE3->E3_BAIEMI   := cE3_BAIEMI

				SE3->( MsUnlock() )

				//Identifico os percentuais de comissão dos vendedores
				nComVend1 := POSICIONE("SA3",1,XFILIAL("SA3") + cVendInt, "A3_COMIS") //Vendedor 1
				nComVend2 := POSICIONE("SA3",1,XFILIAL("SA3") + cNewVend, "A3_COMIS") //Vendedor 2

				//Calcula Diferença da Comissão entre o Cadastro(SA3) e Comissão no Título SE3
				nDifComis       := nE3PORC / nComVend1
				nPerComVenda    := nComVend2 *nDifComis

				cSql :=" UPDATE "+RetSqlName("SE3")//--------------Atualiza a Base e o valor da Comissão para os vendedores
				cSql +=" SET "
				cSql +=" E3_BASE = " + STR(SE3->E3_BASE  /2 )   + " ,  "
				cSql +=" E3_COMIS =" + Str(ROUND(SE3->E3_BASE  /2    * SE3->E3_PORC /100 ,2))
				cSql +=" WHERE "
				cSql +=" E3_FILIAL='"+xFilial("SE3")+"'"
				cSql +=" AND E3_SERIE='"+SE3->E3_SERIE+"'"
				cSql +=" AND E3_NUM='"+SE3->E3_NUM+"'"
				cSql +=" AND E3_CODCLI='"+SE3->E3_CODCLI+"'"
				cSql +=" AND D_E_L_E_T_ = ' ' "

				TCSQLExec( cSql )
				TCSQLExec('COMMIT')

				cSql :=" UPDATE "+RetSqlName("SE3")//--------Atualiza o Percentual e valor da comissão para o vendedor2
				cSql +=" SET "
				cSql +=" E3_BASE = " + STR(SE3->E3_BASE  /2 )   + " ,  "
				cSql +=" E3_PORC = " + STR(ROUND( nPerComVenda,4 ))   + " ,  "
				cSql +=" E3_COMIS =" + Str(ROUND(SE3->E3_BASE  /2    * nPerComVenda /100 ,2))
				cSql +=" WHERE "
				cSql +=" E3_FILIAL='"+xFilial("SE3")+"'"
				cSql +=" AND E3_VEND='"+cNewVend+"'"
				cSql +=" AND E3_SERIE='"+SE3->E3_SERIE+"'"
				cSql +=" AND E3_NUM='"+SE3->E3_NUM+"'"
				cSql +=" AND E3_CODCLI='"+SE3->E3_CODCLI+"'"
				cSql +=" AND D_E_L_E_T_ = ' ' "

				TCSQLExec( cSql )
				TCSQLExec('COMMIT')

			Endif

		Endif

	Endif

	Return
*/
	*****************************************************************************************
USER FUNCTION _CORCOMIS() // Faz a correcao da base e do valor das comissoes da filial de
	// Curitiba com TES com percentual de icms diferido informado.
	// Esse erro está ocorrendo no P8. No P10 não ocorre.
	// Essa função deverá ser desativado no P10.
	*****************************************************************************************

	Local cSql  := ""

	IF SF4->F4_FILIAL = "13"

		IF SF4->F4_PICMDIF > 0

			cSql :=" UPDATE "+RetSqlName("SE3")
			cSql +=" SET "
			cSql +=" E3_BASE = " + STR(SF2->F2_VALMERC, Tamsx3("E3_BASE")[1],Tamsx3("E3_BASE")[2])   + " ,  "
			cSql +=" E3_COMIS = ROUND( " + STR(SF2->F2_VALMERC, Tamsx3("E3_BASE")[1],Tamsx3("E3_BASE")[2]) + " * E3_PORC /100, " + STR(Tamsx3("E3_COMIS")[2],3) + " ) "
			cSql +=" WHERE "
			cSql +=" E3_FILIAL='"+xFilial("SE3")+"'"
			cSql +=" AND E3_SERIE='"+SF2->F2_SERIE+"'"
			cSql +=" AND E3_NUM='"+SF2->F2_DOC+"'"
			cSql +=" AND E3_CODCLI='"+SF2->F2_CLIENTE+"'"
			cSql +=" AND E3_EMISSAO='"+DTOS(SF2->F2_EMISSAO)+"'"
			cSql +=" AND D_E_L_E_T_ = ' ' "

			TCSQLExec( cSql )
			TCSQLExec('COMMIT')

		ENDIF

	ENDIF

	RETURN()

	//+-----------------------------------------------------------------------------------//
	//|Funcao....: nRetPerComisVen2()
	//|Descricao.: Retorna o percentual de comissão para o 2º Operador do Call Center
	//|Uso.......: U_SendNfTrf
	//|Observação: Envia o e-mail dos Boletins de Entrada
	//+-----------------------------------------------------------------------------------//

/*	*************************************************
Static Function nRetPerComisVen2()
	*************************************************
	Local cSql    :=''
	Local nPComis :=0

	cSql:= " SELECT ROUND((VALCOMISSAO/TOTAL)*100,2) PER_COMIS "
	cSql+= " FROM "
	cSql+= "( "

	cSql+=" SELECT SUM(D2_TOTAL) TOTAL, "
	cSql+=" SUM((D2_TOTAL * D2_COMIS1)/100) VALCOMISSAO "
	cSql+=" FROM "+RetSqlName('SD2')+" SD2"
	cSql+=" WHERE D2_FILIAL='"+SF2->F2_FILIAL+"'"
	cSql+=" AND   D2_DOC='"+SF2->F2_DOC+"'"
	cSql+=" AND   D2_SERIE ='"+SF2->F2_SERIE+"'"
	cSql+=" )"

	If( Select("TRB_TEMP") <> 0 ) // Se a area a ser utilizada estiver em uso, fecho a mesma
		TRB_TEMP->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,'TOPCONN',TCGenQry(,,cSql ),'TRB_TEMP',.T.,.T.)
	dbSelectArea("TRB_TEMP")

	If !Eof()
		nPComis:= TRB_TEMP->PER_COMIS
	Endif

	TRB_TEMP->( dbCloseArea() )

	Return (nPComis)
*/

	//+-----------------------------------------------------------------------------------//
	//|Funcao....: fItensBoletim()
	//|Descricao.: Carrega os itens de transferência para envio do Boletim de Entrada
	//|Uso.......: U_SendNfTrf
	//|Observação: Envia o e-mail dos Boletins de Entrada
	//+-----------------------------------------------------------------------------------//

	***********************************
Static Function fItensBoletim()
	***********************************
	Local cSql:=' '

	cSql:=" SELECT D2_COD,D2_QUANT  "
	cSql+=" FROM "+RetSqlName("SD2")+" SD2"
	cSql+=" WHERE "
	cSql+=" D2_FILIAL      ='"+xFilial("SD2")+ "'"
	cSql+=" AND D2_DOC     ='"+SF2->F2_DOC+ "'"
	cSql+=" AND D2_SERIE   ='"+SF2->F2_SERIE+"'"
	cSql+=" AND D2_CLIENTE ='"+SF2->F2_CLIENTE+"'"
	cSql+=" AND D2_LOJA    ='"+SF2->F2_LOJA+"'"
	cSql+=" AND D_E_L_E_T_  <>'*'"

	If( Select("QRY_D2") <> 0 ) // Se a area a ser utilizada estiver em uso, fecho a mesma
		QRY_D2->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"QRY_D2",.F.,.T.)

	While !QRY_D2->(EOF())

		aAdd(aItensTransf,{QRY_D2->D2_COD,QRY_D2->D2_QUANT})
		QRY_D2->( dbSkip() )
	EndDo

	QRY_D2->( dbCloseArea() )

Return

///JULIO JACOVENKO, em 21/09/2016
///cerro texto (pode ser '')
///cnota    numero nf saida
///cserie   serie nf saida
///ccliente cod. cliente da nf
///cloja    num loja cliente da nf
////////////////////////////////////

Static Function DeuErro(cErro,cNota,cSerie,cCliente,cLoja)
	
	Local cSql := ""
	Local cArea:=GetArea()

	Iw_MsgBox("Mensagem de Erro M460FIM - Avise a TI: " + chr(10) + cErro, "Atenção", "ALERT")

	///agora grava um log
	///

	//MsgAlert("Forcando gravacao no SD2 ref NF..."+cNOTA+' '+cSERIE)

	////aqui quando der erro
	////podemos tratar o que podera ser feito

	/////Como deu erro vamos garantir de atualizar os MC
	/////com base no pedido de vendas
	/////VAMOS LER O PEDIDO VIA QUERY
	/////ja que estava posicinado na NOTA e SERIE
	/////
	cSQL:=" SELECT * FROM "+RetSqlName("SC6")+" SC6"
	cSQL+=" WHERE C6_NOTA='"+CNOTA+"' "
	cSQL+=" AND C6_SERIE='"+CSERIE+"' "
	cSQL+=" AND C6_FILIAL='"+XFILIAL('SF2')+"' "
	cSQL+=" AND D_E_L_E_T_ <> '*' "

	If( Select("QRY_C6") <> 0 ) // Se a area a ser utilizada estiver em uso, fecho a mesma
		QRY_C6->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"QRY_C6",.F.,.T.)

	While !QRY_C6->(EOF())
		///COMECA A LER DADOS DO SC6 P/ALIMENTAR O SD2
		CPRODUTO:=QRY_C6->C6_PRODUTO
		CITEM   :=QRY_C6->C6_ITEM
		///REGISTRA OS MC da vida que estao no pedido de venda
		///
		NMC     :=QRY_C6->C6_MC
		NMCR    :=QRY_C6->C6_MCR
		NIMC    :=QRY_C6->C6_IMC
		NIMCR   :=QRY_C6->C6_IMCR

		NCUSMCR :=QRY_C6->C6_CUSMCR
		NCUSMC  :=QRY_C6->C6_CUSMC
		NMCUC   :=QRY_C6->C6_MCUC
		NIMCUC  :=QRY_C6->C6_IMCUC
		NCUSMCUC:=QRY_C6->C6_CUSMCUC

		NCOEFC  :=QRY_C6->C6_COEFC
		NCOEFF  :=QRY_C6->C6_COEFF
		NCOEFI  :=QRY_C6->C6_COEFI
		NIDADE  :=QRY_C6->C6_IDADE
		NIDIMDE :=QRY_C6->C6_IDADE2

		///agora busco a linha no SD2 correspondente
		///
		dbSelectArea('SD2');dbSetOrder(3) // filial+doc+serie
		IF dbSeek( xFilial('SD2')+cNOTA+cSERIE+cCLIENTE+cLOJA+CPRODUTO+CITEM) //SF2->F2_DOC+SF2->F2_SERIE+F2_CLIENTE+F2_LOJA+CPRODUTO+CITEM )
			//ACHOU A LINHA, VAMOS ALIMENTAR
			//OS MC que estao registrados no Pedido de Venda
			///
			IF RecLock('SD2',.F.)
				SD2->D2_MC 		:= NMC
				SD2->D2_MCR		:= NMCR
				SD2->D2_IMC		:= NIMC
				SD2->D2_IMCR	:= NIMCR

				SD2->D2_CUSMCR := NCUSMCR
				SD2->D2_CUSMC  := NCUSMC
				SD2->D2_MCUC   := NMCUC
				SD2->D2_IMCUC  := NIMCUC
				SD2->D2_CUSMCUC:= NCUSMCUC

				SD2->D2_COEFC	:= NCOEFC
				SD2->D2_COEFI	:= NCOEFI
				SD2->D2_IDADE	:= NIDADE
				SD2->D2_IDIMDE  := NIDIMDE
				//////////////////////////////////////////////////////
				//////////JULIO JACOVENKO, em 23/05/2016
				//////////tratamento FCI
				//////////busca no ZA7 pelo campo D2_FILIAL+D2_COD o
				//////////conteudo do ZA7_IMDFCI
				//////////
				CNFCI:=''
				CNFCI:=ALLTRIM(SD2->(Posicione("ZA7",1,XFILIAL('SD2')+CPRODUTO,"ZA7_IMDFCI")))
				SD2->D2_FCICOD:=CNFCI
				///////////////////////////////////////////////////////////////////
				MsUnlock()
			ENDIF
		ELSE
			//NAO ACHOU, O QUE FAZER
			//...nao faz nada...
			//
			///
		ENDIF

		DBSELECTAREA("QRY_C6")
		QRY_C6->( dbSkip() )
	EndDo
	QRY_C6->( dbCloseArea() )

	////JULIO JACOVENKO, mem 20/05/2016
	////
	////aqui vamos mandar um email com os dados do erro
	////que esta na varivel CERRO, junto com CNOTA,CSERIE
	////para rastrear a causa.
	////SUGIRO MANDAR PARA GRUPO TI
	////
	//EnvMyMail(_cFrom,_cTo,_cBcc,_cSubject,_cBody,_cAttach,lTela)
	_cFrom   := 'protheus@imdepa.com.br'
	_cTo     :=	'julio.cesar@imdepa.com.br; edivaldo@imdepa.com.br'
	_cBcc    := ''
	_cSubject:= 'Ocorreu erro na Geraçao da NF '+CNOTA+'/'+CSERIE+' pela rotina M460Fim'
	_cBody   := CERRO
	U_ENVMYMAIL(_cFrom,_cTo,_cBcc,_cSubject,_cBody)

	//////////////////////////////////////////////////////

	RestArea(CAREA)
	return .t.

	*******************************
Static Function ATUFLADR()
	*******************************
	// Agostinho Lima - 17/04/2017 -
	// Atualizacao do campo A1_FLADR
	// Atualizado com o ano da primeira compra do cliente sem considerar a loja

	Local cQuery := ""
	Local cAno := SA1->A1_FLADR

	cQuery := "SELECT SUBSTR(MIN(A1_PRICOM),1,4) ANO FROM SA1010 WHERE D_E_L_E_T_ = ' ' AND A1_PRICOM <> ' ' AND A1_COD = '" + SA1->A1_COD + "' "

	U_ExecMySql(cQuery,"TP01","Q")

	If ! (TP01->( bof() ) .AND. TP01->( eof() ))

		cAno := TP01->ANO

	Endif
	DbSelectArea("TP01")
	dbCloseArea()

Return(cAno)

