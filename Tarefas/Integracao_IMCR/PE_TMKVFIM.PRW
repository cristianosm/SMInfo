#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "IMDEPA.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE X_PARCELA		"123456789ABCDEFGHIJKLMNOPQ"
#DEFINE CRLF 			( chr(13)+chr(10) )
#DEFINE X_PRODUTO		aScan(aHeader, {|x| Alltrim(x[2])=='UB_PRODUTO'})
#DEFINE X_QTD			aScan(aHeader, {|x| Alltrim(x[2])=='UB_QUANT'})
#DEFINE X_ZE_NUMPLAN	12
#DEFINE X_ZE_ITEM		13
#DEFINE X_ZE_PVITEM		14

#DEFINE  ENTER CHR(13)+CHR(10)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³U_Tmkvfim() ³ Autor ³Microsiga/MQB        ³ Data ³ 22/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gravacao do arquivos de pedido de vendas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ESPECIFICO PARA O CLIENTE IMDEPA						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³15/10/2005³  MQB   ³     Fonte Compatibilizado Hand                    ³±±
±±³21/10/2005³  MQB   ³     Adicionado caso que PEDIDO é liberado direto  ³±±
±±³19/10/2005³  MQB   ³     Liberação de PV automatico para Imdepauto     ³±±
±±³21/11/2005³  MQB   ³     Retirado alçada de Margem                     ³±±
±±³29/11/2005³  MQB   ³     Revisado toda a alcada de margem              ³±±
±±³18/12/2006³  MQB   ³     Posicionado TES logo apos Posicionadp Pedido  ³±±
±±³25/04/2007³  MQB   ³     Passagem dos Acresc e Desc Real no U_Defcomis ³±±
±±³12/06/2007³  MQB   ³     SelectArea("SE1"), p/ compatib. grv. prospect ³±±
±±³20/05/2008³  MQB   ³     Desonera MC qdo Sit.Trib,considera icm retido ³±±
±±³          ³        ³                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*******************************************************************************
User Function Tmkvfim()
*******************************************************************************
	Local _aArea := GetArea()
	Local aAreaSA1 := SA1->(GetArea())
	Local nRecSA1  := SA1->(Recno())
	Local cOld_F10 := SetKey(VK_F10)

	//MaFisSave()

	cTpOperAT := IIF(SUA->UA_OPER == '1', 'Faturamento', IIF(SUA->UA_OPER == '2','Orcamento','Atendimento'))

	oProcess := MsNewProcess():New({|lEnd| ExecGravaAT(@oProcess, @lEnd) },"Gravando "+cTpOperAT,"Processando... Aguarde",.F.)
	oProcess:Activate()

	// GRAVA O ULTIMO CONTATO DO CLIENTE	                 
	If !lProspect
		ExecBlock('LastCont',.F.,.F.,{SUA->UA_CLIENTE, SUA->UA_LOJA})
	EndIf

	RestArea(_aArea)
	RestArea(aAreaSA1)

	// Verificacao se Registro do SA1 do ultimo pedido ficou
	// TRAVADO por alguma rotina por este usuario. DESTRAVA sempre                                      
	DbSelectArea("SA1");DbGoTo( nRecSA1 )
	If !SA1->(SimpleLock())
		SA1->(MsRUnlock(nRecSA1))
	Else
		SA1->(MsRUnlock(nRecSA1))
	EndIf

	//MaFisRestore()

	SetKey(VK_F10, cOld_F10)

Return(.T.)
*******************************************************************************
Static Function ExecGravaAT(oProcess, lEnd, cTpOperAT)
*******************************************************************************
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
//	Local aIt   		:= Array(0)
	Local xaItem 		:= Array(0)
	Local xaCab  		:= Array(0)
//	Local nDecSUB 		:= TamSx3("UB_VRUNIT")[2]
//	Local nDecDesc 		:= TamSx3("UB_DESC")[2]
//	Local nDecVLRITEM 	:= TamSx3("UB_VLRITEM")[2]
//	Local nDecBASEICM 	:= TamSx3("UB_BASEICM")[2]
	Local cDescComis	:= GetMV("MV_COMIDES")
	Local cAcreComis	:= GetMV("MV_COMIACR")
	Local aSZE      	:= Array(0)
	Local lGeraSZE  	:= .F.
	Local lOk			:= .T.
//	Local lLibDireto	:= .F.
//	Local lLibTES		:= .F.
//	Local cHora 		:= Strtran(Left(Time(),5),":","")
//	Local nDescReal 	:= 100
//	Local aAvalCom		:= {}

	Local nX,nJ
	Local __cFilAnt // ,lOkItem
//	Local nPerComisCLI,aComisCamp,nPrRecSUB
//	Local nLucro, nMargem, nCusto, cTpCust
//	Local nAcreFin, nAcreReal, nDescLucro
//	Local nPrcTabBase
	Local aVendedores //,aOperador
//	Local nPosQtdLib
	local nPos
//	Local nVlrItem

//	Local lGeralog := .F.
	Local cProduto
	Local cLocal
//	Local nValDifICM
//	Local nPercFrete, nFreteItem
//	Local aPlanilha := {}
//	Local cPlanilha
//	Local cFiltran
	Local nIMC 		:= 0, nIMCg  		:= 0, nIMCR  		:= 0, nIMCUC 	:= 0, nIMCgTot	:= 0, nIMCRTot	:= 0, nQtdItem 	:= 0
	Local nCusMCg	:= 0, nMC			:= 0, nMCTot		:= 0, nMCgTot	:= 0, nMCRTot	:= 0, nMCUCTot	:= 0, nIMCTot	:= 0
	Local nIMCUCTot	:= 0, nMCR			:= 0, nCOEFI		:= 0, nCusMCUC	:= 0, nCusMCR	:= 0, nCusMC	:= 0
	Local nQtdTotal	:= 0, nIdadeTotal 	:= 0, nQxITotal 	:= 0, nQtdITotal:= 0, nTISIPI	:= 0, nCOEFC	:= 0, nCOEFF	:= 0


//	Local lCancAnt
	Local lEnvMail := (Upper(GetMv('MV_ENVMAIL')) = 'SIM') //Informa se envia e-mail para os operadores para informar que a nota de transferencia foi entrada
	//alterado em 10/02/2015 em função de que as regras de acrescimo e desconto forma descontinuadas - Rodrigo Carvalho - Solutio
	//Local nPrBaseDesc,nDifIcmUnit,nPrcMin
//	Local nDifIcmUnit,nPrcMin
//	Local nFatores

	//Inserido por Edivaldo Gonçalves Codeiro em 31/08/06 Declarado variáveis locais para percentual de comissão //
	//Pois está sendo rodado o MSAGUARDE e com isso se faz necessário iniciar ás varíaveis                       //
	//12/09/06 Edivaldo/Márcio - Inserido o (SF4->)para garantir que o MsAguarde e o RetCodUsr() não desposicione//
	//o alias Corrente                                                                                           //

	Local n_COMIS1 := 0
	Local n_COMIS2 := 0
	Local n_COMIS3 := 0
	Local n_COMIS4 := 0
	Local n_COMIS5 := 0

	//Cristiano Machado
	Local nAlicIcm	:= 0
	Local nValDesp  := 0
	Local nAcreCon  := 0
	Local nValFret  := 0
	Local nCalcIcm  := 0
	Local nAlicIpi  := 0
	Local nMVA		:= 0
	Local nValIcmSt := 0
	Local nIcmRetido := 0

//	Local nCusMCR  :=0
//	Local nCusMCUC :=0
//	Local lRetWMS
	Local cTpEstFis  := ""
	Local cEndPad    := ""
//	Local lRedesp    := .F.
//	Local lAjustPrec := .F.

	Local lTemReserva :=	.F. //IIF(!Empty(SUA->UA_RESERVA) /*.And. SUA->UA_OPER == '2'*/, .T., .F.)  // 1=Faturamento;2=Orcamento;3=Atendimento

	Local lVerST	:= .F.
	
	Private lPVBloqReg := .F.
	Private lMsHelpAuto := .T. // se .T. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
//	Private __cNumOrig
	Private aStrucSC5   := RetStruct('SC5')
	Private aStrucSC6   := RetStruct('SC6')

//	Private cCustoNF  := GetMV("MV_CUSTONF",," ")
//	Private lEstOner  := dDatabase >= GetMV("MV_ESTONER",,dDatabase+1)

	Private aLogComiss := {}

	Private cVend_1
	Private NIcm_PIS

	//CRIADO PELO JULIO JACOVENKO em 14/10/2011 PARA GRAVAR O CODIGO DO CLIENTE CORRETO QUANDO
	//TRANSFORMA PROSPECT PARA CLIENTES

	Private cCodCli:=''
	Private cLojCli:=''

	//JULIO JACOVENKO, em 13/08/2014
	//projeto frete 1.3
	Private nValFrtA:=0

	// FABIANO PEREIRA - SOLUTIO
	Private lOperFat 	:= (SUA->UA_OPER == '1')	// 1=Faturamento;2=Orcamento;3=Atendimento
	//Private aRetZRD	:=	{}
	Private aRetZRN	 	:=	{}
	Private aComplRD 	:=	{}
	Private nE4Acresc	:=	Posicione('SE4',1,xFilial('SE4')+SUA->UA_CONDPG,'E4_ACRSFIN')
	Private aPTransf	:=	{}
	Private lTemGuia    :=.F.

	// Jean Rehermann - Solutio IT - 19/11/2015 - Variáveis transformadas em private para uso em outros programas (referência ao acols e aheader)
	Private __aCols := 	Array(0)
	Private __aHeader := 	Array(0)
	Private cNumSC5	:=	Space(TamSx3('C5_NUM')[01])
	Private cNumFIL	:=	Space(TamSx3('C5_FILIAL')[01])

	//JULIO JACOVENKO, em 30/11/2017
	//usado na funcao IMDFPEDSIM

	Private nQuant	:=	0
	Private nPesoB	:=	0

	Private aProds	:=	{}
	Private aATxRes	:=	{}

	IIF( !ExisteSX6('MV_FILFRT'),	CriarSX6('MV_FILFRT', 'C','Parametro utilizado no fonte PE_TMKVFIM,PRW' ,'') , )

	oProcess:SetRegua1(Len(aCols))

	DbSelectArea("SU7")
	DbSetOrder(4) //U7_FILIAL+U7_CODUSU
	DbSeek(xFilial("SU7")+SU7->(RetCodUsr()))

	cVend_1    := SU7->U7_CODVEN
	cOperAtivo := SU7->U7_COD

	__cMensagem := ""
	cDescComis  := IIF(EMPTY(cDescComis),"N",cDescComis)
	cAcreComis  := IIF(EMPTY(cAcreComis),"N",cAcreComis)

	// Posicionando o atendimento

	DbSelectArea("SUA")
	DbSetorder(1)
	If !DbSeek(xFilial("SUA")+M->UA_NUM)
		// Cancela toda a transacao
		If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
			U_Mensagem("Não foi possível encontrar o atendimento "+M->UA_NUM+". Favor acionar Depto de Tecnologia Imdepa.")
		Else
			ConOut("Não foi possível encontrar o atendimento "+M->UA_NUM+". Favor acionar Depto de Tecnologia Imdepa.")
		EndIf
		Final("Erro ao localizar atendimento.")
	EndIf

	cTabPreco	:= SUA->UA_TABELA
	cMoeda		:= SUA->UA_MOEDA
	cCondPag 	:= SUA->UA_CONDPG

	//  Autor: Cristiano Machado    Data: 02/07/2014
	//  Atualiza Cliente no Consultado (ZA0) Caso Tenha Sido alterado...
	oProcess:IncRegua1('Verificando Cliente...')
	CLI_Atualiza()

	__aCCols 	:= aClone(Acols) /// Atualiza o __CopaCols Publico para utilizado na emissão do orcamento...

	//Posiciona a ordem dos arquivos

	SZP->(dbSetOrder(1))	//Filial + Numero do Atendimento	(Nao precisa salvar ambiente desta  tabela,  eh especificas)
	SZQ->(dbSetOrder(1))	//Filial + Numero do Atendimento + Item  	(Nao precisa salvar ambiente desta  tabela,  eh especificas)
	ZZA->(dbSetOrder(1))
	DbSelectArea("SF7");DbSetOrder(1)
	DbSelectArea("SA1");dbSetOrder(1)     //CLIETNES
	DbSelectArea("SB1");dbSetOrder(1)     //PRODUTOS
	DbSelectArea("SB2");dbSetOrder(1)     //SALDO FISICO E FIN
	DbSelectArea("SC6");dbSetOrder(1)     //Itens Pedido de venca  --> ordem: C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	DbSelectArea("SE1")
	DbSelectArea("SE4");dbSetOrder(1);dbseek(xFilial("SE4")+cCondPag)  // cONDICAO DE pAGAMENTO
	DbSelectArea("SF4");dbSetOrder(1)      //TES
	DbSelectArea("SA3");dbSetOrder(1)       // CADASTRO DE VENDEDORES
	DbSelectArea("SL4");dbSetOrder(1)	      //CAD CONDICAO NEGOCIADA
	DbSelectArea("SUB");dbSetOrder(1)      //ITENS DO ORCAMENTO TELEVENDAS
	DbSelectArea("SUW");dbOrderNickName('UW_PRODUTO')
	DbSelectArea("DC8");dbSetOrder(4)

	// Posicionando Clientes
	SA1->(DbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA))

	aVendedores := { {SA1->A1_VENDEXT},{SA1->A1_VEND},{SA1->A1_VENDCOO},{SA1->A1_CHEFVEN},{SA1->A1_GERVEN} }

	//CRIADO PELO JULIO JACOVENKO em 14/10/2011 PARA GRAVAR O CODIGO DO CLIENTE CORRETO QUANDO TRANSFORMA PROSPECT PARA CLIENTES
	cCodCli:=SA1->A1_COD
	cLojCli:=SA1->A1_LOJA

	DbSelectArea("SA3")
	For nX := 1 to Len(aVendedores)
		DbSeek(xFilial("SA3")+aVendedores[nX,1])
		aAdd(aVendedores[nX],SA3->A3_COMIS)
	Next

	//	FABIANO PEREIRA - SOLUTIO
	If lOperFat

		DbSelectArea("SC5")
		dbSetOrder(1)
		If !DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)
			If Type("l410Auto") != "U" .And. !l410Auto
				ALERT("PROBLEMA, Pedido de venda n:"+ SUA->UA_NUMSC5 + " não encontrado , entre em contato com o Depto. de Tecnologia Imdepa!")
			Else
				ConOut("PROBLEMA, Pedido de venda n:"+ SUA->UA_NUMSC5 + " não encontrado , entre em contato com o Depto. de Tecnologia Imdepa!")
			EndIf
		EndIf

		// INCLUIDO PELO JULIO EM 17/10/2011 PARA AJUSTAR O CODIGO DO CLIENTE QUANDO DE PROSPECT PARA CLIENTE
		cNumSC5:=SC5->C5_NUM
		cNumFIL:=SC5->C5_FILIAL

	EndIf

	RecLock("SUA",.F.)

	//	FABIANO PEREIRA - SOLUTIO
	//	GRAVA DESCONTO GERAL QUE USUARIO CONCEDEU.UTILIZADO NO CASOS ONDE O USUARIO QUER SABER QUANTO DE DESCONTO GERAL FOI DADO. EX.: VIA HISTORICO
	If SUA->(FieldPos('UA_DESC_CC')) > 0
		SUA->UA_DESC_CC := SUA->UA_DESCG
	EndIf

	If  SUA->UA_OPERAD2 <> cOperAtivo  .AND. SUA->UA_OPERADO <> cOperAtivo  //Mudou o operador
		SUA->UA_OPERAD2 := cOperAtivo
	EndIf

	If SUA->UA_JUROS != nE4Acresc
		SUA->UA_JUROS := nE4Acresc
	EndIf
	SUA->(MsUnlock())

	//	FABIANO PEREIRA - SOLUTIO
	If lOperFat
		//³Altera o cabecalho do pedido de venda                 ³
		Reclock("SC5",.F.)
		SC5->C5_VEND1   := aVendedores[1,1] //INTERNO
		SC5->C5_VEND2   := aVendedores[2,1] //EXTERNO
		SC5->C5_VEND3   := aVendedores[3,1] //COORDE.
		SC5->C5_VEND4   := aVendedores[4,1] //CHEFE VENDAS
		SC5->C5_VEND5   := aVendedores[5,1] //GER.VENDAS
		SC5->C5_COMIS1  := 0
		SC5->C5_COMIS2  := 0
		SC5->C5_COMIS3  := 0
		SC5->C5_COMIS4  := 0
		SC5->C5_COMIS5  := 0
		SC5->C5_TIPLIB  := "2"
		SC5->C5_CODROTA := SUA->UA_CODROTA
		SC5->C5_OCCLI   := SUA->UA_OCCLI
		SC5->C5_TIPFAT  := SUA->UA_TIPFAT
		SC5->C5_MENNOTA := SUA->UA_MENNOTA
		SC5->C5_OPERADO := SUA->UA_OPERADO
		SC5->C5_NUMSUA  := SUA->UA_NUM
		SC5->C5_CLIENTR := SUA->UA_CLIENTR
		SC5->C5_LOJENTR := SUA->UA_LOJENTR
		SC5->C5_GERAWMS := '1'
		SC5->C5_STATUS  := ' ' // RESETA O STATUS DE LIBERACAO QUANDO SOFRE ALTERACAO . CHAMADO: 21578
		//	FABIANO PEREIRA - SOLUTIO
		SC5->C5_DESC1	:=	SUA->UA_DESC1		//	DESCONTO CAD.CLIENTE
		// SC5->C5_DESCG:=	SUA->UA_DESCG		//	DESCONTO GERAL (USUARIO ALTERA NA MAO)
		SC5->C5_DESC4	:=	SUA->UA_DESC4		//	DESCONTO DA REGRA DE DESCONTO

		// AJUSTA E4_ACRSFIN == E4_ACRSFIN
		// OCORRENCIA ONDE E4_ACRSFIN GRAVOU ERRADO

		If SC5->C5_ACRSFIN != nE4Acresc
			SC5->C5_ACRSFIN := nE4Acresc
		EndIf

		MsUnlock()

	EndIf

	//³Altera os itens do pedido de vendas							 ³
	nItemSUB	:= 1

	//JULIO JACOVENKO, em 30/11/2017
	//para usar com a funcao ImdFPedSim(nPesoB,nQuant)
	nQuant:=0
	nPesoB:=0

	//----------------------------------------------------------------------------------------------------------------
	//---->>>>>>>>>>>> INICIO LOOP SUB
	//----------------------------------------------------------------------------------------------------------------
	SUB->(dbSeek(xFilial("SUB")+M->UA_NUM))
	Do While SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+M->UA_NUM .And. SUB->(!Eof())

		oProcess:IncRegua1("Processando Item "+Alltrim(Str(nItemSUB))+" de "+Alltrim(Str(Len(aCols))) )
		oProcess:SetRegua2(17)

		//	ATENDIMENTO X RESERVAS
		Aadd(aATxRes, {SUB->UB_ITEM, SUB->UB_PRODUTO, SUB->UB_RESERVA})


		//	FABIANO PEREIRA - SOLUTIO
		If lOperFat
			//³Posicionando Pedidos    ³
			SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM+SUB->UB_ITEM+SUB->UB_PRODUTO,.F.))
		EndIf


		//³Posicionando de TES	         			     ³
		SF4->(dbSeek(xFilial("SF4")+SUB->UB_TES))

		
		//Inserido por Edivaldo Gonçalves Cordeiro em 21/10/06                                    //
		//Verifica se o produto em movimentação está habilitado o apanhe/separação pelo WMS       //
		IF  ( TYPE("lTk271Auto") = "U" .OR. !lTk271Auto )
			oProcess:IncRegua2("WMS - Verificando se o item possui controle de localização...")
			lRetWMS := SF4->(U_checkWMS(SUB->UB_PRODUTO))
		Else
			lRetWMS := SF4->(U_checkWMS(SUB->UB_PRODUTO))
		EndIf

		
		//FABIANO PEREIRA - SOLUTIO - 13/02/2015 - participação Rodrigo Carvalho Solutio
		Reclock('SUB', .F.)
		SUB->UB_PRCTAB2	:=	SUB->UB_PRCTAB			//	Prc.Tab.Dia At
		SUB->UB_PREC_CC	:=	SUB->UB_VRUNIT			//	Preco Atend
		SUB->UB_DESC_CC	:=	Round(SUB->UB_DESCVEN,TamSx3('UB_DESCVEN')[02])			//	% Desconto Concedido
		SUB->UB_ACRE_CC	:=	Round(SUB->UB_ACRE2   ,TamSx3('UB_ACRE2')[02]) 			//	% Acrescimo Concedido


		/////JULIO JACOVENKO, em 30/11/2017
		/////para usar com a funcao ImdFPedSim(nPesoB,nQuant)
		nQuant += SUB->UB_QUANT
		nPesoB += POSICIONE("SB1",1,xFilial("SB1")+UB_PRODUTO,"B1_PESO") * UB_QUANT

		MsUnlock()

		//	FABIANO PEREIRA - SOLUTIO
		If lOperFat

			DbSelectArea("SC6")
			Reclock("SC6",.F.)

			SC6->C6_PRCACRE := SUB->UB_VRCACRE

			If lRetWMS
				If DC8->(dbSeek(xFilial('DC8')+'5'+SC6->C6_LOCAL, .F.))
					cTpEstFis      := DC8->DC8_CODEST
					cEndPad        := Alltrim(DC8->DC8_DESEST)
					If SBE->(dbSeek(xFilial('SBE')+SC6->C6_LOCAL + cEndPad, .F.)) // Verificar se endereco EXISTE
						SC6->C6_ENDPAD := cEndPad
						SC6->C6_SERVIC := SuperGetMv("IMD_SVCONF" , .F. , "001" , xFilial("SC6")) //DC5->(Posicione("DC5",2,xFilial("DC5") +'002',"DC5_SERVIC"))
					EndIf
				EndIf
			EndIf

			//Grava no Pedido de Vendas a Observação do Produto para Itens Promo
			lTaemPromo:= Iif(Alltrim( SUBSTR(SB1->B1_OBSTPES,1,5))=='PROMO',.T.,.F.)

			If lTaemPromo
				SC6->C6_OBS:=Alltrim(SB1->B1_OBSTPES)
			EndIf

			MsUnlock()

		EndIf

		//-----> Carrega variaveis SUB
		cProduto 	:= SUB->UB_PRODUTO
		cLocal	 	:= SUB->UB_LOCAL
		//nBaseICM 	:= NoRound((SUB->UB_VLRITEM   + nValDesp + nAcreCon + nValFrtA),2)
		nQtdItem 	:= SUB->UB_QUANT
		//nFreteCal	:= SUA->UA_FRETE //SUA->UA_FRETCAL
		//nValmerc 	:= SUA->UA_VALMERC  // VALOR COM ACRESCIMO (PS. NO UA_VALMERC NÃO ESTÁ CONTIDO O ACRESCIMO)
		//nDespesa	:= SUA->UA_DESPESA
		// nIdade 		:= 0
		nIdadeSC6   := 0
		//nFreteFob   := SUA->UA_FRETFOB  // Redespacho

		//³Posicionando Estoque, se for transrfeência, busca do estoque da filial de transferência   ³
		// Utilizar a pesquisa de estoque na filial de transferencia somente
		// no atendimento (tmk271), no faturamento verificar o estoque atual
		IF FunName() == 'TMKA271' .AND. !Empty(SUB->UB_FILTRAN)
			cFilialB2	:= SUB->UB_FILTRAN
			cLocalB2 	:= Posicione("SB1",1,cFilialB2+cProduto,"B1_LOCPAD")
		Else
			cFilialB2	:= xFilial('SB2')
			cLocalB2 	:= cLocal
		EndIf

		SB2->(DbSeek(cFilialB2 + cProduto + cLocalB2))
		SB1->(DbSeek(xFilial("SB1")+cProduto))

		// Inicia processo de gravacao de campos especificos na tabela SUB
		// ITEM SUB X ITEM ACOLS  	  							³

		//Identifica item do SUB correspondente no alcols
		nTotValSol  := 0
		nItem		:= 0
		nItemacols 	:= 1
		For i:=1 To Len( acols )
			If  !gdDeleted(i)   //  se não estiver deletado (DELETADO = .T.)
				If nItemSUB = nItemacols
					nItem := i
					Exit
				EndIf
				nItemacols++
				nTotValSol := MaFisRet(i,"IT_VALSOL")
			EndIf
		Next i

		// Chamado: 23902 Cristiano Machado - Ajuste para Identificar se eh Necessario Imprimir Guia ST no FATURAMENTO
		cConteudo := SuperGetMv("MV_SUBTRIB" , .F. , "" , xFilial("SC5"))
		If nTotValSol > 0 .And. AT(SA1->A1_EST, cConteudo ) <= 0  .And.  Alltrim( GetMv("MV_ESTADO") ) <> SA1->A1_EST
			lTemGuia := .T.
		Else
			lTemGuia := .F.
		EndIf

		//|CUSTOS        (OBS: qualquer alteração aqui, faça também no M460FIM        º
		oProcess:IncRegua2('Verificando Comissoes vendedor 1...')
		n_COMIS1  := SF4->(U_DefComis(SA1->A1_VENDEXT,.F.,SA1->A1_PAGCOM1,0,0 ))
		oProcess:IncRegua2('Verificando Comissoes vendedor 2...')
		n_COMIS2  := SF4->(U_DefComis(SA1->A1_VEND   ,.T.,SA1->A1_PAGCOM2,0,0 ))
		oProcess:IncRegua2('Verificando Comissoes vendedor 3...')
		n_COMIS3  := SF4->(U_DefComis(SA1->A1_VENDCOO,.F.,SA1->A1_PAGCOM3,0,0 ))
		oProcess:IncRegua2('Verificando Comissoes vendedor 4...')
		n_COMIS4  := SF4->(U_DefComis(SA1->A1_CHEFVEN,.F.,SA1->A1_PAGCOM4,0,0 ))
		oProcess:IncRegua2('Verificando Comissoes vendedor 5...')
		n_COMIS5  := SF4->(U_DefComis(SA1->A1_GERVEN ,.F.,SA1->A1_PAGCOM5,0,0 ))


		RecLock("SUB",.F.)
		SUB->UB_COMIS1 := n_COMIS1
		SUB->UB_COMIS2 := n_COMIS2
		SUB->UB_COMIS3 := n_COMIS3
		SUB->UB_COMIS4 := n_COMIS4
		SUB->UB_COMIS5 := n_COMIS5
		MsUnlock()

		//*********************************************************************
		//--> INICIO Calculo Custos
		
		//| Observacoes: CalCusBase()
		//| 	1 - Tabelas a serem Posicionadas: [SA1 , SB1 , SB2 , SUA , SUB , SE4, SF4 ]
		//| 	2 - Comissoes já devem ter sido Gravadas no SUB
		
		
		U_CalCusBase(lVerST, nItem, @oProcess, @nMC, @nMCR, @nIMC, @nIMCg, @nIMCR, @nIMCUC, @nCusMC, @nCusMCg, @nCusMCR, @nCusMCUC, @nMCTot, @nMCRTot, @nCOEFC, @nCOEFF, @nCOEFI, @nQxITotal, @nQtdITotal, @nTISIPI, @nIdadeSC6 )
		
		//REMOVIDO
		
		Reclock("SUB",.F.)
		//Grava Margens
		Replace UB_MC    with nMC, UB_MCR    with nMCR
		//Grava Indices das Margens
		Replace UB_IMC   with nIMC		,UB_IMCG   with nIMCg	 , UB_IMCR   with nIMCR	 , UB_IMCUC   with nIMCUC
		//Grava Custos das Margens
		Replace UB_CUSMC with nCusMC	,UB_CUSMCG with nCusMCg, UB_CUSMCR with nCusMCR	, UB_CUSMCUC with nCusMCUC
		//Grava Coeficientes
		Replace UB_COEFC with nCOEFC	,UB_COEFF  with nCOEFF   , UB_COEFI   with nCOEFI

		//Grava Idade
		Replace UB_IDADE with nIdadeSC6 //nIdade

	
		// Verifica se houve venda perdida
		If SUB->UB_QCONSUL > SUB->UB_QOFERT
			// Registra a venda perdida (Atencao, SUA e SUB devem estar posicionados)
			If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				// MsAguarde({|| SF4->(U_GravaVP()) },"Venda Perdida","Registrando Venda Perdida ...")
				oProcess:IncRegua2("Registrando Venda Perdida ...")
				SF4->(U_GravaVP())
			Else
				U_GravaVP()
			EndIf

		EndIf
		MsUnlock()
		
		//--> FIM Calculo Custos
		//*************************
		
	
		// Define alcada do operador (vendedor)
		DbSelectArea("SA3");DBSETORDER(7)
		DBSEEK(xFilial("SA3")+SF4->(RetCodUsr()))
		If SB1->B1_ALCDESC == '1'
			nalcada := SA3->A3_ALCDESC
		Else
			nalcada := SA3->A3_ALCDES2
		EndIf

		//	FABIANO PEREIRA - SOLUTIO
		If lOperFat

			oProcess:IncRegua2("Atualizando Pedido de Venda...")

			//************ GRAVA DADOS NO SC6***********
			SC6->( Reclock("SC6",.F.) )
			//--------- Campos de Custos
			SC6->C6_IDADE   := SUB->UB_IDADE

			_jarea  := GetArea()
			nIdade2 := 0
			//DbSelectArea('SB2');DbSetOrder(1)

			C6FILIAL := SC6->C6_FILIAL

			If SB2->( DbSeek(C6FILIAL+SC6->C6_PRODUTO+SC6->C6_LOCAL)) //'01')

				IF SB2->B2_IDIMDE == 0
					nIdade2 := U_IdadeAtu(nQtdItem,SB2->B2_IDADE,SB2->B2_DTIDADE)
					RECLOCK('SB2',.F.)
					SB2->B2_IDIMDE	:= nIdade2
					SB2->B2_DTCALC	:= SB2->B2_DTIDADE
					MSUNLOCK()
				Else
					nIdade2 := U_IdadeAtu(nQtdItem,SB2->B2_IDIMDE,SB2->B2_DTCALC)
				EndIf

			EndIf

			RestArea(_jarea)

			SC6->C6_IDADE2 	:= nIdade2
			SC6->C6_MC		:= SUB->UB_MC
			SC6->C6_IMC		:= SUB->UB_IMC
			SC6->C6_CUSMC	:= SUB->UB_CUSMC
			SC6->C6_MCG		:= SUB->UB_MCG
			SC6->C6_IMCG	:= SUB->UB_IMCG
			SC6->C6_CUSMCG	:= SUB->UB_CUSMCG
			SC6->C6_MCR		:= SUB->UB_MCR
			SC6->C6_IMCR	:= SUB->UB_IMCR
			SC6->C6_CUSMCR	:= SUB->UB_CUSMCR
			SC6->C6_MCUC	:= SUB->UB_MCUC
			SC6->C6_IMCUC	:= SUB->UB_IMCUC
			SC6->C6_CUSMCUC	:= SUB->UB_CUSMCUC
			SC6->C6_COEFC	:= SUB->UB_COEFC
			SC6->C6_COEFF	:= SUB->UB_COEFF
			SC6->C6_COEFI	:= SUB->UB_COEFI

			// RODRIGO SOLUTIO
			SC6->C6_COMIS1  := SC6->(U_DefComis(SA1->A1_VENDEXT,.F.,SA1->A1_PAGCOM1,0,0 ))  //n_COMIS1
			SC6->C6_COMIS2  := SC6->(U_DefComis(SA1->A1_VEND   ,.T.,SA1->A1_PAGCOM2,0,0 ))  //n_COMIS2
			SC6->C6_COMIS3  := SC6->(U_DefComis(SA1->A1_VENDCOO,.F.,SA1->A1_PAGCOM3,0,0))  //n_COMIS3
			SC6->C6_COMIS4  := SC6->(U_DefComis(SA1->A1_CHEFVEN,.F.,SA1->A1_PAGCOM4,0,0 ))  //n_COMIS4
			SC6->C6_COMIS5  := SC6->(U_DefComis(SA1->A1_GERVEN ,.F.,SA1->A1_PAGCOM5,0,0 ))  //n_COMIS5

			// Grava as informacoes de comissao na tabela xcomis para posterior uso pela Trigger TRI_XCOMIS
			SC6->(U_GrvXComis(SC6->C6_FILIAL , SC6->C6_NUM , SC6->C6_ITEM , SC6->C6_COMIS1, SC6->C6_COMIS2 , SC6->C6_COMIS3 , SC6->C6_COMIS4 , SC6->C6_COMIS5))

			// Jean Rehermann - Solutio IT - 18/01/2017 - Recalcula o total de descontos e regrava no item do atendimento e do pedido, para garantir
			nTtDscIt := SUA->UA_DESC1 + SUA->UA_DESC2 + SUA->UA_DESC4 + SUA->UA_DESCG + SUB->UB_DESCVEN + SUB->UB_DESCRD
			SUB->( RecLock("SUB",.F.) )
			SUB->UB_TOTDESC := nTtDscIt
			SUB->( MsUnLock() )
			// Fim Jean Rehermann - 18/01/2017

			SC6->C6_CUSTEMB := SUB->UB_CUSTEMB
			SC6->C6_PLANILH := SUB->UB_PLANILH
			SC6->C6_PLITEM  := SUB->UB_PLITEM
			SC6->C6_FILTRAN := SUB->UB_FILTRAN
			SC6->C6_ACREREA := SUB->UB_ACRE2		//	FABIANO PEREIRA - SOLUTIO
			SC6->C6_DESCREA := SUB->UB_TOTDESC		//	FABIANO PEREIRA - SOLUTIO
			SC6->C6_PRCTPAD := SUB->UB_PRCBASE
			SC6->C6_DTINC   := Date()
			SC6->C6_HRINC   := Time()
			SC6->C6_USRINC  := SubStr( cUsuario, 7, 15 )

			// Atualizacao do Pedido de Compra do Cliente - Agostinho Lima - 20/11/2017
			SC6->C6_ITEMPC  := SUB->UB_ITEMPC
			SC6->C6_NUMPCOM := SUB->UB_NUMPCOM

			SC6->(MsUnlock())
		EndIf

		
		
		///  Gravacao da Planilha
		If !Empty(SUB->UB_FILTRAN) .AND. EMPTY(SUB->UB_PLANILH)
			lGeraSZE := .T.

			nPos := aScan(aSZE, {|x| x[1] = SUB->UB_FILTRAN})

			If Empty(aSZE) .or. nPos <= 0

				Aadd(aSZE, {SUB->UB_FILTRAN,{{.T.,;									//01 //X_lMKBR_SC7
				' ',;										//02 //
				' ',;                           	//03
				SUB->UB_PRODUTO,;  					//04 //X_ZE_PRODUTO
				SUB->UB_QUANT,;              		//05 //X_ZE_QTDPC
				cFilAnt,;         					//06 //X_ZE_DESTINO filial em uso no momento
				SUB->UB_QUANT,;						//07 //X_ZE_QTDORIG
				' ',;										//08 //X_ZE_HAWB
				SUB->UB_DTNECLI,;						//09 //X_ZE_DTENTRE
				0,;                             	//10 //X_ZE_EXCED
				' ',;									   //11 //X_ZE_LOCAL
				' ',;										//12 //X_ZE_NUMPLAN
				' ',;										//13 //X_ZE_ITEM
				SUB->UB_ITEM,;							//14 //X_ZE_PVITEM
				SUB->UB_QUANT,;						//15 - Backup da quantidade
				'',;										//16 - Descricao
				dDataBase + 5,;						//17 - Previsao de chegada mercadoria
				'';										//18 - Codigo da PE
				}}})
			Else

				// Jorge Oliveira - 20/12/2010 - Incluido campos para a Planilha de Transferencia( posicao 15, 16 e 17 )
				Aadd(aSZE[nPos,2], {.T.,;  						//01 //X_lMKBR_SC7
				' ',;							//02 //
				' ',;                  	//03
				SUB->UB_PRODUTO,;			//04 //X_ZE_PRODUTO
				SUB->UB_QUANT,;			//05 //X_ZE_QTDPC
				cFilAnt,;					//06 //X_ZE_DESTINO
				SUB->UB_QUANT,;			//07 //X_ZE_QTDORIG
				' ',;							//08 //X_ZE_HAWB
				SUB->UB_DTNECLI,;			//09 //X_ZE_DTENTRE
				0,;							//10 //X_ZE_EXCED
				' ',; 						//11 //X_ZE_LOCAL
				' ',;							//12 //X_ZE_NUMPLAN
				' ',;							//13 //X_ZE_ITEM
				SUB->UB_ITEM,;				//14 //X_ZE_PVITEM
				SUB->UB_QUANT,;			//15 - Backup da quantidade
				'',;							//16 - Descricao
				dDataBase + 5,;			//17 - Previsao de chegada mercadoria
				'';							//18 - Codigo da PE
				})
			EndIf
		EndIf




		//  FABIANO PEREIRA - SOLUTIO
		//  ATUALIZA ARRAY aATxRN COM NUMERO\ITEM DO PEDIDO DE VENDA
		//Do While .T.
		//  1 ITEM DO ATENDIMENTO PODE TER MAIS DE UM BLOQUEIO DA REGRA DE NEGOCIO
		nPos := Ascan(aATxRN, {|X| Alltrim(X[11]) == '' .And. Alltrim(X[1]) == Alltrim(SUB->UB_NUM) .And. Alltrim(X[5]) == Alltrim(SUB->UB_ITEM) })
		If nPos > 0
			aATxRN[nPos][09] := SUB->UB_NUMPV
			aATxRN[nPos][10] := IIF(!Empty(SUB->UB_NUMPV), SUB->UB_ITEMPV, '')
			aATxRN[nPos][11] := 'X'
		//Else
		//	Exit
		EndIf
		//EndDo

		//  GRAVA NO ARRAY aRetZRN ITEMS DO ATENDIMENTO QUE NAO ENTRARAM NO BLOQ. DA REGRA DE NEGOCIO
		//  CASO ITEM EXISTA NA TABELA DE LOG ZRN ENTAO DELETA REGISTRO
		If Ascan(aATxRN, {|X|  Alltrim(X[1]) == Alltrim(SUB->UB_NUM) .And. Alltrim(X[5]) == Alltrim(SUB->UB_ITEM) }) == 0
			Aadd(aRetZRN, {Alltrim(SUB->UB_NUM), Alltrim(SUB->UB_ITEM) })
		EndIf

		nPosR := Ascan(aRegDesc, {|X| Alltrim(X[02]) == Alltrim(SUB->UB_ITEM) })
		If nPosR > 0
			Aadd(aComplRD, {Alltrim(SUB->UB_ITEM), Alltrim(SUB->UB_PRODUTO), SUB->UB_DESCVEN, SUB->UB_NUMPV, IIF(!Empty(SUB->UB_NUMPV), SUB->UB_ITEMPV, ''), SUB->UB_DESCRD, '' })
		EndIf


		SUB->(DbSkip())
		
		nItemSUB++
		
	EndDo
	
	//----------------------------------------------------------------------------------------------------------------
	//---->>>>>>>>>>>> FIM LOOP SUB
	//----------------------------------------------------------------------------------------------------------------

	
	// VERIFICA SE ALGUM ITEM DO ATENDIMENTO TEM RESERVA

	lTemReserva	:=	IIF(Ascan(aATxRes, {|X| !Empty(X[03]) }) > 0, .T., .F.)

	If lOperFat

		lPVBloqReg 	:= 	.F.
		lSC6AllLib	:=	.F.
		aAreaAtu 	:=	GetArea()
		DbSelectArea("SC5");DbSetOrder(1);DbGoTop()
		If DbSeek(xFilial("SC5") + SUA->UA_NUMSC5, .F.)

			//  FABIANO PEREIRA - SOLUTIO
			//  CASO EXISTIR ALGUM ITEM COM BLOQ.REGRA NAO FORCA LIB.PV
			lPVBloqReg 	:= 	Alltrim(SC5->C5_BLQ) == '1'
			If lPVBloqReg

				// OBSERVACAO: FABIANO PEREIRA - SOLUTIO
				// PV BLOQUEADO APENAS NO C5_BLQ E C6_BLOQUEI COM TODOS OS ITENS DO PV
				// ESTAO LIBERAMOS O C5_BLQ PARA PODER GERAR SC9.
				// VERIFICAR SE TEM ALGUM ITEM BLOQ NO SC6 (SE NAO TIVER EH PQ O PV
				//	ESTAVA BLOQ.POR REGRA E AGORA ESTA SAINDO DO BLOQ.DE REGRA
				// (EX. USER ADD NOVO ITEM E SAIU DO BLOQ.REGRA)

				If ChkSC6Lib(SC5->C5_FILIAL, SC5->C5_NUM)

					lSC6AllLib 	:= 	.T.
					lPVBloqReg	:=	.F.

					// VERIFICA SE ALGUM ITEM ESTA COM DESCONTO ACIMA DA REGRA.
					//	CASO ITEM EXISTE NA ZRN E C6_BLOQUEI = ' ' FORCA BLOQUEIO NO SC6
					// QDO BLOQ DE REGRA NO PADRAO TODO OS ITENS VEM COM C6_BLOQUEI = '01'
					// DE QQ MANEIRA VERIFICO ZRN x SC6  (SE C5_BLQ=1 C6_BLOQUEI TEM Q SER =01)
					IIF(Select('TMPC')!=0, TMPC->(DbCloseArea()), )
					cQuery := "	SELECT 	ZRN.ZRN_FILIAL, ZRN.ZRN_NUMAT, ZRN.ZRN_ITEMAT, ZRN.ZRN_PEDIDO, ZRN.ZRN_ITEMPV, ZRN.ZRN_PRODUT, 	"+ENTER
					cQuery += "			ZRN.ZRN_TPBLQ, ZRN.ZRN_VENDA,  ZRN.ZRN_REGRA,  ZRN.ZRN_CODRN,  ZRN.ZRN_TPBLQ,  ZRN.ZRN_CPOBLQ,	"+ENTER
					cQuery += "			SC6.C6_BLOQUEI, SC6.R_E_C_N_O_ AS SC6RECNO														"+ENTER+ENTER

					cQuery += " FROM 	"+RetSqlName("ZRN")+" ZRN   											   	"+ENTER
					cQuery += "										INNER JOIN "+RetSqlName("SC6")+" SC6 			"+ENTER
					cQuery += "										ON 	SC6.C6_FILIAL 	 = 	ZRN.ZRN_FILIAL			"+ENTER
					cQuery += "										AND SC6.C6_NUM 		 =  ZRN.ZRN_PEDIDO			"+ENTER
					cQuery += "										AND SC6.C6_ITEM 	 = 	ZRN.ZRN_ITEMPV			"+ENTER
					cQuery += "										AND SC6.C6_PRODUTO 	 = 	ZRN.ZRN_PRODUT			"+ENTER
					cQuery += "										AND SC6.C6_BLOQUEI	 =  '  '					"+ENTER
					cQuery += "										AND SC6.D_E_L_E_T_ 	!= 	'*' 					"+ENTER+ENTER

					cQuery += " WHERE 	ZRN.ZRN_FILIAL 	=  '"+SUA->UA_FILIAL+"' 	"+ENTER
					cQuery += " AND 	ZRN.ZRN_PEDIDO 	=  '"+SUA->UA_NUMSC5+"'		"+ENTER
					cQuery += " AND 	ZRN.D_E_L_E_T_ !=  '*' 						"+ENTER+ENTER

					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPC', .F., .T.)
					DbSelectArea('TMPC');DbGoTop()
					Do While !Eof()

						lSC6AllLib 	:= 	.F.
						lPVBloqReg	:=	.T.

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³  	BLOQUEIA SC6 	³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SC6Bloqueia(TMPC->ZRN_PEDIDO, TMPC->ZRN_ITEMPV)

						DbSelectArea('TMPC')
						DbSkip()
					EndDo

				EndIf

			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ VERIFICA SE C5_BLQ = ' ' e C6_BLOQUEI = '  '				³
				//| CASO ALGUM ITEM BLOQUEADO NO SC6 VERIFICA SE EXISTE SC9		|
				//| SENAO TEM SC9 BLOQUEIA P C5_BLQ								|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			EndIf

		EndIf
		RestArea(aAreaAtu)

		IF SC5->C5_LIBREPR = "S" // Libera quando o pedido estiver macado para reprocesso  - Marca Pedido
			lOk := .T.
		EndIf

		//| ANALISTA:CRISTIANO MACHADO CHAMADO:AAZS0B     SOLICITANTE: JULIANO       DESCRICAO: INFLUENCIAVA NA LIBERACAO DE CREDITO    DATA: 02/06/2010
		//| O pedido passou pela liberacao comercial, devo gerar o SC9

		//If lOk .And. !lPVBloqReg		//	FABIANO PEREIRA - RETIRADO lOk (CASOS ONDE PV ESTA BLOQ. + F10 AJUSTA AT PARA NAO BLOQUEAR E SALVA - PV FICA NO LIMBO)
		If !lPVBloqReg					//	FABIANO PEREIRA - SOLUTIO [ VERIFICA SE PV TEM BLOQ. REGRA ]
			DbSelectArea("SC5")
			dbSetOrder(1)
			DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)
			//| Adicionado Flag para liberar o pedido qdo ele passa pela liberação comercial  // MQB 06/10/2005
			// ANALISTA:CRISTIANO MACHADO CHAMADO:AAZS0B     SOLICITANTE: JULIANO       DESCRICAO: INFLUENCIAVA NA LIBERACAO DE CREDITO    DATA: 02/06/2010
			If Found()
				Reclock("SC5",.F.)
				SC5->C5_LIBEROK := "S"
				SC5->C5_LIBERAD := SF4->(RetCodUsr())
				If lSC6AllLib
					SC5DesBlq(SC5->C5_NUM, .T.)
				EndIf
				MsUnlock()
			EndIf
			//---fim da flag

			SC6->(dbSetOrder(1))		// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM,.F.))
			SA1->( dbSeek(xFilial('SA1')+SC6->C6_CLI+SC6->C6_LOJA) )

			DbSelectArea('SC6')
			Do While !Eof() .And. xFilial('SC6') == SC6->C6_FILIAL .And. SC5->C5_NUM == SC6->C6_NUM

				Begin Transaction
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³  		 EXECUTA  MaLibDoFat  			 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ExecMaLibDoFat()

				End Transaction

				DbSelectArea('SC6')
				DbSkip()

			EndDo

		Else  // nao deve liberar o pedido

			// Localiza o pedido de venda relacionado ao atendimento
			DbSelectArea("SC5")
			DbSetOrder(1)
			If DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)
				// Verifica se o pedido esta liberado
				DbSelectArea("SC9")
				DbSetorder(1)
				If DbSeek(xFilial("SC9")+SUA->UA_NUMSC5)
					// estorno as liberacoes
					xaCab := {	{'C5_NUM'      ,SUA->UA_NUMSC5      , },;
					{'C5_TIPO'     ,SC5->C5_TIPO        , },;
					{'C5_CLIENTE'  ,SC5->C5_CLIENTE     , },;
					{'C5_LOJACLI'  ,SC5->C5_LOJACLI     , },;
					{'C5_TIPOCLI'  ,SC5->C5_TIPOCLI     , },;
					{'C5_CONDPAG'  ,SC5->C5_CONDPAG     , },;
					{'C5_EMISSAO'  ,SC5->C5_EMISSAO     , },;
					{'C5_MOEDA'    ,SC5->C5_MOEDA       , },;
					{'C5_TIPLIB'   ,SC5->C5_TIPLIB      , } }

					// incluo os campos especificos
					For nField := 1 To Len(aStrucSC5)
						cCampo := aStrucSC5[nField,1]
						If Ascan(xaCab, {|X| Alltrim(X[01]) == Alltrim(cCampo)}) == 0
							Aadd(xaCab, {cCampo, SC5->&(cCampo), } )
						EndIf
					Next

					xaIt := {}
					DbSelectArea("SC6");DbSetOrder(1)	//FILIAL+NUMERO+ITEM
					DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)
					Do While C6_FILIAL+C6_NUM == xFilial("SC6")+SUA->UA_NUMSC5 .and. !Eof()

						xaItem := {}

						// Aadd(aATxRes, {SUB->UB_ITEM, SUB->UB_PRODUTO, SUB->UB_RESERVA})
						nPosATR	:=	Ascan(aATxRes, {|X| Alltrim(X[01]) == Alltrim(SC6->C6_ITEM) .And. Alltrim(X[02]) == Alltrim(SC6->C6_PRODUTO) })
						cATxRes	:=	IIF(nPosATR > 0, aATxRes[nPosATR][03], SC6->C6_RESERVA)

						aAdd(xaItem,{'C6_ITEM'     ,SC6->C6_ITEM    , })
						aAdd(xaItem,{'C6_PRODUTO'  ,SC6->C6_PRODUTO , })
						aAdd(xaItem,{'C6_QTDVEN'   ,SC6->C6_QTDVEN  , })
						aAdd(xaItem,{'C6_PRCVEN'   ,SC6->C6_PRCVEN  , })
						aAdd(xaItem,{'C6_VALOR'    ,SC6->C6_VALOR   , })
						aAdd(xaItem,{'C6_TES'      ,SC6->C6_TES     , })
						aAdd(xaItem,{'C6_QTDLIB'   ,0               , })
						aAdd(xaItem,{'C6_LOCAL'    ,SC6->C6_LOCAL   , })
						aAdd(xaItem,{'C6_PRUNIT'   ,SC6->C6_PRUNIT  , })
						aAdd(xaItem,{'C6_CLASFIS'  ,SC6->C6_CLASFIS , })
						//Aadd(xaItem,{'C6_RESERVA'  ,cATxRes			 , })
						Aadd(xaItem,{'C6_PEDCLI'   ,SC6->C6_PEDCLI  , })

						// incluo os campos expecificos
						For nField := 1 To Len(aStrucSC6)
							cCampo := aStrucSC6[nField,1]
							If Ascan(xaItem, {|X| Alltrim(X[01]) == Alltrim(cCampo)}) == 0
								Aadd(xaItem, {cCampo, SC6->&(cCampo), } )
							EndIf
						Next

						Aadd(xaIt,aClone(xaItem))
						Dbskip()
					EndDo

					MSExecAuto({|w,x,y| MATA410(w,x,y)},xaCab,xaIt,4)
					If lMsErroAuto
						Mostraerro()
					EndIf

				EndIf
			EndIf
		EndIf

		DbSelectArea('SC5')

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia a transacao de inclusao do pedido de vendas  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Begin Transaction

	If lOperFat
		// Inicio - 07/05/2003
		If lGeraSZE
			// inicio a geracao da planilha de transferecia
			// quem vai distribuir eh a filial que vai enviar a mercadoria
			// backup
			__aCols 	:= aClone(aCols)
			__aHeader 	:= aClone(aHeader)
			__cFilAnt  	:= cFilAnt
			__aArea		:= GetArea()
			__aAreaSM0 	:= SM0->(GetArea())
			// Jean Rehermann - Solutio IT - 19/11/2015 - Salvo a área fiscal antes de gerar planilha e pedido de transferência
			MaFisSave()
			// qunatidade de planilhas a serem geradas depende das filiais (FILTRAN) utilizadas
			// para gerar a transferencia. Serah gerada uma planilha para cada filial utilizada
			For nSZE := 1 To Len(aSZE)
				aCols   := Array(0)
				aHeader := Array(0)
				cFilAnt := aSZE[nSZE,1]

				// gera planilhas de transferencia sempre na filial distribuidora
				If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
					MsAguarde({||SF4->(U_IMD080Plan( .F., ' ', aSZE[nSZE,2] ))},"Item de Transferência","Gerando Planilha ...")
				Else
					U_IMD080Plan( .F., ' ', aSZE[nSZE,2] )
				EndIf

				cFilAnt := __cFilAnt

				// Recupera o numero/item da planilha de transferencia
				For ncItem := 1 To Len(aSZE[nSZE,2])
					// item do pedido de venda
					__cItem := aSZE[nSZE,2,ncItem,X_ZE_PVITEM]

					// recupero a linha do item que vai ser gravado no PV

					SC6->(dbSetOrder(1))		// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					SC6->(dbSeek(xFilial("SC6")+SUA->UA_NUMSC5+__cItem,.F.))
					SC6->(Reclock("SC6",.F.))
					// salvo o numero/item da planilha no item do pedido
					SC6->C6_PLANILH := aSZE[nSZE,2,ncItem,X_ZE_NUMPLAN]    // SZE->ZE_NUMPLAN
					SC6->C6_PLITEM 	:= aSZE[nSZE,2,ncItem,X_ZE_ITEM]   	 	// SZE->ZE_ITEM
					If !Empty(SC6->C6_PLANILH)
						Aadd(aPTransf, {SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_PLANILH, SC6->C6_PLITEM})
					EndIf
					SC6->( MsUnlock() )

					// SUB --> PROJ F11
					// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					SUB->(dbSeek(xFilial("SUB")+SUA->UA_NUM+__cItem,.F.))
					SUB->(Reclock("SUB",.F.))
					// salvo o numero/item da planilha no item do pedido
					SUB->UB_PLANILH := aSZE[nSZE,2,ncItem,X_ZE_NUMPLAN]
					SUB->UB_PLITEM 	:= aSZE[nSZE,2,ncItem,X_ZE_ITEM]
					SUB->( MsUnlock() )

					// reserva na planilha
					SZE->(dbSetOrder(3))
					SZE->( dbSeek(xFilial("SZE")+SC6->C6_PLANILH+SC6->C6_PLITEM) )

					SZE->(Reclock("SZE",.F.))
					SZE->ZE_QTDRES := SC6->C6_QTDVEN
					SZE->( MsUnlock() )

					SZE->(dbSetOrder(1))
				Next

				// processa a planilha gerada  e  gera o pedido de compra e pedido de venda correspondente a planilha
				//If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				cFilAnt := aSZE[nSZE,1]
				**********************************************************
				//Alterado por Edivaldo Gonçalves Cordeiro em 31/07/06  //
				//Inserido a passagem de parâmetro(M->UA_NUM)           //
				**********************************************************
				If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
					MsAguarde({||SF4->(U_IMD090Proc(.F.,,M->UA_NUM))},"Item de Transferência","Processando Planilha ...")
				Else
					U_IMD090Proc(.F.,,M->UA_NUM)
				EndIf

				cFilAnt := __cFilAnt

			Next

			// Fabiano Pereira\Gean -Solutio IT - 19/11/2015 - Restauro a área fiscal após gerar planilha e pedido de transferência
			MaFisRestore()
			aHeader := __aHeader
			aCols   := __aCols
			RestArea(__aArea)
			RestArea(__aAreaSM0)
		EndIf
	EndIf

	nIMCTot 	:= U_ValMarg(nMCTot   / nTISIPI * 100)
	nIMCRTot	:= U_ValMarg(nMCRTot  / nTISIPI * 100)

	//	FABIANO PEREIRA - SOLUTIO
	If lOperFat

		DbSelectArea("SC5")
		dbSetOrder(1)
		If DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Totalizadores do Pedido (SC5)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SC5->( Reclock("SC5",.F.) )
			SC5->C5_IMC		:= nIMCTot
			SC5->C5_IMCG	:= nIMCgTot
			SC5->C5_IMCR  	:= nIMCRTot
			SC5->C5_IMCUC 	:= nIMCUCTot
			SC5->C5_IDADE	:= nQxITotal / nQtdITotal
			If lTemGuia
				SC5->C5_PEDGUIA := '1'
			Else
				SC5->C5_PEDGUIA := '2' // Sempre deve Alimentar
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Libera o Pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				SC5->C5_LIBEROK := "S"
				SC5->C5_LIBERAD := SF4->(RetCodUsr())
				/*
				Else
				// removido em 10/02/2015 em função de que o processo carta de negocio foi descontinuado - Rodrigo Carvalho - Solutio
				// Jorge Oliveira - 28/02/2011 - Projeto Carta Negocios
				SC5->C5_LIBEROK := " "
				SC5->C5_LIBERAD := Space( 6 )
				*/
			EndIf

			SC5->( MsUnlock() )

			//--------------------

			DbSelectArea("SUA")
			RecLock("SUA",.F.)
			If SC5->C5_LIBEROK == "S"
				SUA->UA_STATUS := "LIB"
			EndIf
			MsUnlock()

			If  ( Type("lTk271Auto") <> "U" .AND. lTk271Auto )
				cResp := "PALMJOB: " + Space(4) + "Pedido " + SC5->C5_NUM + " importado com sucesso."
				ConOut(cResp)
			EndIf

			///////////////////////////////////////////////////////////////
			//////////////JULIO JACOVENKO, em 30/11/2017
			//////////////manda para o SimFrete o numero do Pedido Gerado
			//////////////pelo TeleVenda
			ImdFPedSim(nPesoB,nQuant)
			///////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////

		Else
			// Cancela toda a transacao
			If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				U_Mensagem("Nao foi possivel encontrar o pedido "+SC6->C6_NUM+". Favor acionar o Depto de Tecnologia Imdepa.")
			Else
				ConOut("Nao foi possivel encontrar o pedido "+SC6->C6_NUM+". Favor acionar o Depto de Tecnologia Imdepa.")
			EndIf
			Final("Erro ao localizar pedido de venda.")
		EndIf

	EndIf

	// Rodrigo - Solutio - 18/06/2015 - grava totais de IMC e IMCR na tabela SUA, cabeçalho do atendimento
	DbSelectArea("SUA")
	RecLock("SUA",.F.)
	SUA->UA_IMC		:= nIMCTot
	SUA->UA_IMCR  	:= nIMCRTot
	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  FABIANO PEREIRA - SOLUTIO            			³
	//³  ATUALIZA LOG ATENDIMENTO X REGRA DE NEGOCIO	³
	//|  1o GRAVA LOG(ZRN) 								|
	//|  2o GRAVA BLOQUEIOS								|
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//|*** OBS.: BLOQUEIOS VERIFICA ZRN	                |
	//|			 EXECUTAR ANTESLogRegNeg				|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*********************
	LogRegNeg()
	*********************
	aRegDesc	:= {}	//	REGRA DE DESCONTO
	aATxRN	 	:= {}	//	ATENDIMENTO X REGRA DE NEGOCIO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|						B L O Q U E I O   D E   R E G R A S 							|
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//³  18/06/2015  - RODRIGO SOLUTIO                                                      |
	//|  VERIFICACAO DE IMC NO ITEM DO ATENDIMENTO E COMPARACAO COM A CURVA 				³
	//³  DO PRODUTO PARA ALTERAR O TIPO DE BLOQUEIO DO PEDIDO      							³
	//³  CASO A MARGEM FIQUE NEGATIVA OU INFERIOS à MíNIMA CADASTRADA NA TABELA DE CURVAS.	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lOperFat

		cTabPrc	 	:= 	' '
		cTabCli 	:= 	' '
		cTabPV		:=	' '
		aPVBlq   	:= 	{}

		IIF(!ExisteSX6('IMD_TMIMC'),	CriarSX6('IMD_TMIMC', 'L','Bloq.Trava Master por IMC - FT210OPC.PRW', 	'.T.' ),)
		lMvIMC_TM := GetMv('IMD_TMIMC')
		IIF(!ExisteSX6('IMD_TMIMCR'),	CriarSX6('IMD_TMIMCR', 'L','Bloq.Trava Master por IMCR - FT210OPC.PRW', '.F.' ),)
		lMvIMCR_TM := GetMv('IMD_TMIMCR')
		IIF(!ExisteSX6('IMD_IMCOUR'),	CriarSX6('IMD_IMCOUR', 'L','Bloq.Trava Master por IMC OU IMCR - FT210OPC.PRW', '.F.' ),)
		lIMCouIMCR := GetMv('IMD_IMCOUR')

		IIF(!ExisteSX6('IMD_MINIMC'),	CriarSX6('IMD_MINIMC', 'N','Valor minimo IMC  - PE_TMKVFIM.PRW', '-10'),)
		nMvImcMin 	:=	GetMv('IMD_MINIMC')				// 0 \-10
		IIF(!ExisteSX6('IMD_MIIMCR'),	CriarSX6('IMD_MIIMCR', 'N','Valor minimo IMCR - PE_TMKVFIM.PRW', '-10'),)
		nMvImcRMin	:=	GetMv('IMD_MIIMCR')				// 0 \-10

		If SUA->UA_NUMSC5 != SC5->C5_NUM
			DbSelectArea('SC5');DbSetOrder(1)		// C5_FILIAL+C5_NUM
			DbSeek(xFilial('SC5') + SUA->UA_NUMSC5, .F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|	TABELA DE PRECO - PEDIDO	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTabPV	:=	SC5->C5_TABELA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|	VERIFICA SE CLIENTE TEM TABELA DE PRECO EXCLUSIVA	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SA1->A1_COD+SA1->A1_LOJA != SC5->C5_CLIENTE+SC5->C5_LOJACLI
			DbSelectArea("SA1");DbSetOrder(1);DbGoTop()
			If DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, .F.)
				cTabCli := SA1->A1_TABELA
			EndIf
		Else
			cTabCli := SA1->A1_TABELA
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|	lChkLogZRN = VARIAVEL PARA CONTROLE SE ATUALIZA LOG (ZRN)	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lChkLogZRN := IIF(SC5->C5_BLQ == '1' .And. Empty(SC5->C5_LIBRNV1), .F., .T.)

		aTabelas 	:= 	&(GetMv('MV_SEGXTAB'))		//	{{"1","OEM"},{"2","MNT"},{"3","REV"}}
		nPosTab 	:= 	Ascan(aTabelas, {|X| X[2] == SC5->C5_TABELA })
		If nPosTab > 0
			cTabPrc := 	SC5->C5_TABELA
		Else

			DbSelectArea("SA1");DbSetOrder(1);DbGoTop()
			If DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, .F.)
				cSegmento  	:= 	SubStr(SA1->A1_GRPSEG,3,1)
				nPosTab 	:= 	Ascan(aTabelas, {|X| X[1] == cSegmento })
				cTabPrc 	:= 	IIF(nPosTab > 0, aTabelas[nPosTab][02], '')
			EndIf

		EndIf

		IIF(Select('TMPV')!=0, TMPV->(DbCloseArea()), )
		cQuery := "	SELECT 	SUB.UB_PRODUTO, SB1.B1_DESC,	SB1.B1_OBSTPES, 						"+ENTER
		cQuery += "			SUB.UB_NUM, 	SUB.UB_ITEM, 	SUB.UB_ITEMPV,  SUB.UB_PRODUTO,			"+ENTER
		cQuery += "			SUB.UB_IMC, 					SUB.UB_IMCR,	SUB.UB_IMCG,			"+ENTER
		cQuery += "			ZGV.ZGV_IMCMIN RGV_IMCMIN, 		ZGV.ZGV_IMCRMI  RGV_IMCRMIN, 			"+ENTER
		cQuery += "			ZGV.ZGV_VLRMIN RGV_VLRMIN, 												"+ENTER
		cQuery += "			(IM1.IM1_IMCMIN * 100) IM1_IMCMIN,										"+ENTER
		cQuery += "			(IM1.IM1_IMCRMI * 100) IM1_IMCRMI,										"+ENTER
		cQuery += "			(IM1.IM1_TRAVAM * 100) TRVM_IMC,										"+ENTER
		cQuery += "			(IM1.IM1_TRAVAR * 100) TRVM_IMCR,										"+ENTER
		cQuery += "			SUB.UB_TABPRC, SUB.UB_PRCTAB, 											"+ENTER
		cQuery += "			SUB.UB_VRCACRE, SUB.UB_VRUNIT, SUB.UB_PRCBASE							"+ENTER+ENTER

		cQuery += "	FROM "+RetSqlName("SUB")+"  SUB  												"+ENTER+ENTER

		cQuery += "									INNER JOIN "+RetSqlName("ZGV")+" ZGV 			"+ENTER
		cQuery += "									ON 	ZGV.ZGV_FILIAL 	 = '"+xFilial("ZGV")+" '	"+ENTER
		cQuery += "									AND ZGV.ZGV_GV 		 =  SUB.UB_FILIAL	 		"+ENTER
		cQuery += "									AND ZGV.ZGV_TABELA 	 = 	'"+cTabPrc+"' 			"+ENTER
		cQuery += "									AND ZGV.D_E_L_E_T_ 	!= 	'*' 					"+ENTER+ENTER

		cQuery += " 								INNER JOIN "+RetSqlName("SB1")+" SB1 			"+ENTER
		cQuery += " 								ON  SB1.B1_FILIAL 	=  SUB.UB_FILIAL		 	"+ENTER
		cQuery += " 								AND SB1.B1_COD 		=  SUB.UB_PRODUTO 			"+ENTER
		cQuery += " 								AND SB1.D_E_L_E_T_ !=  '*' 						"+ENTER+ENTER

		cQuery += " 								INNER JOIN "+RetSqlName("IM1")+" IM1 			"+ENTER
		cQuery += " 								ON  IM1.IM1_FILIAL 	=  SUB.UB_FILIAL		 	"+ENTER
		cQuery += " 								AND IM1.IM1_COD 	=  SB1.B1_CURVA 			"+ENTER
		cQuery += " 								AND IM1.IM1_SEGMEN 	=  '"+cTabPrc+"' 			"+ENTER
		cQuery += " 								AND IM1.D_E_L_E_T_ !=  '*' 						"+ENTER+ENTER

		cQuery += "	WHERE SUB.UB_FILIAL  = '"+SUA->UA_FILIAL+"' 	"+ENTER
		cQuery += "	AND SUB.UB_NUM 		 = '"+SUA->UA_NUM+"' 		"+ENTER
		cQuery += "	AND SUB.D_E_L_E_T_ 	!= '*'  					"+ENTER

		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPV', .F., .T.)

		DbSelectArea("TMPV");DbGoTop()
		Do While !Eof()

			lChkIMC := 	.T.
			lDelZRN	:= 	.T.
			lTravaM	:=	.F.
			lPromo	:=	Left(TMPV->B1_OBSTPES,1) == 'P'

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³***  BUSCA VALOR DA TRAVA MASTER NA TABELA IM1	*** ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTrvMIMC  := TMPV->TRVM_IMC
			nTrvMIMCR := TMPV->TRVM_IMCR

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  VERIFICA SE EXISTE DESCONTO ACIMA DO PERMITIDO                     |
			//|	(SE ZRN_TPBLQ = DESCONTO EH PQ DESCONTO ESTA ACIMA DO PERMITIDO)	³
			//³  UTILIZADO QUERY PQ PODE HAVER + REGISTROS NA TABELA ZRN            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IIF(Select('TMPD')!=0, TMPD->(DbCloseArea()), )
			cQuery := "	SELECT 	ZRN.ZRN_FILIAL, ZRN.ZRN_NUMAT, ZRN.ZRN_ITEMAT, ZRN.ZRN_PEDIDO, ZRN.ZRN_ITEMPV, ZRN.ZRN_PRODUT, 	"+ENTER
			cQuery += "			ZRN.ZRN_TPBLQ, ZRN.ZRN_VENDA,  ZRN.ZRN_REGRA,  ZRN.ZRN_CODRN, ZRN.ZRN_TPBLQ, ZRN.ZRN_CPOBLQ		"+ENTER+ENTER

			cQuery += " FROM 	"+RetSqlName("ZRN")+" ZRN   			   	"+ENTER
			cQuery += " WHERE 	ZRN.ZRN_FILIAL 	=  '"+SUA->UA_FILIAL+"' 	"+ENTER
			cQuery += " AND 	ZRN.ZRN_NUMAT 	=  '"+TMPV->UB_NUM+"'		"+ENTER
			cQuery += " AND 	ZRN.ZRN_ITEMAT 	=  '"+TMPV->UB_ITEM+"'		"+ENTER
			cQuery += " AND 	ZRN.ZRN_PRODUT 	=  '"+TMPV->UB_PRODUTO+"' 	"+ENTER
			cQuery += " AND 	UPPER(RTRIM(ZRN.ZRN_TPBLQ)) =  'DESCONTOS'	"+ENTER
			cQuery += " AND 	ZRN.ZRN_VENDA 	>  ZRN.ZRN_REGRA 			"+ENTER
			cQuery += " AND 	ZRN.D_E_L_E_T_ !=  '*' 						"+ENTER+ENTER

			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPD', .F., .T.)
			nCount := 0
			TMPD->(DbGoTop())
			TMPD->(dbEval({||nCount++},,,1 ))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//|  VERIFICA SE DESCONTO DENTRO DA ALCADA	  |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDescOK 	:=	IIF(nCount==0, .T., .F.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//|	 [ VERSAO ANTIGA ] 																|
			//|  SE PRODUTO ESTA EM PROMO E DESCONTO DENTRO DA ALCADA [ NAO ] VERIFICA IMC\IMCR	|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lChkIMC  :=	IIF(lPromo, IIF(nCount==0, .F., .T.), .T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//|																			|
			//| PARA CLIENTES COM TABELA DE PRECO EXCLUSIVA NAO VERIFICAR VALIDACOES	|
			//| PROCESSA VALIDACOES QDO PRC.VENDA > PRC.TAB								|
			//|ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|
			//| VERIFICA TAB.PRECO DO AT. PQ A TAB. CADASTRADA NO CLIENTE PODE ESTAR 	|
			//| FORA DE VIGENCIA ou USUARIO ALTEROU A TAB.PRECO NO ATENDIMENTO			|
			//|																			|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosTab 	:= 	Ascan(aTabelas, {|X| Alltrim(X[2]) == Alltrim(cTabPV) }) //	{{"1","OEM","INDUSTRIA"},{"2","MNT","MANUTENCAO"},{"3","REV","REVENDA"}}
			lCliTab 	:= 	IIF(nPosTab > 0, .F., 	IIF(cTabPV == TMPV->UB_TABPRC, .T., .F.))
			nItPreco	:=	TMPV->UB_VRCACRE
			nPrcTab		:=	TMPV->UB_PRCTAB

			If !lCliTab
				lChkRegra := .T.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//|  ATUALIZA PRECO TABELA + IMPOSTOS   |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosProd	:=	Ascan(aProdxImp, {|X| Alltrim(X[01]) == Alltrim(TMPV->UB_ITEM) .And. Alltrim(X[02]) == Alltrim(TMPV->UB_PRODUTO) })
				nVlrImp 	:=	IIF(nPosProd > 0, aProdxImp[nPosProd][21], 0)		//	[21] SOMA ALIQUOTAS IMPOSTOS
				nPrcTab		:=	NoRound(nPrcTab/ ((100 - nVlrImp) / 100), 02)
				lChkRegra 	:=	IIF(nItPreco > nPrcTab,  .F., .T.)
			EndIf

			If lDescOK .And. lChkRegra

				//If !lPromo  //Comentado por Edivaldo Gonçalves

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//| 		-->   R E G R A   B L O Q U E I O   <--  				|
				//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
				//| GetMv('IMD_TMIMC') 	- VERIFICA TRAVA MASTER POR IMC            	|
				//| GetMv('IMD_TMIMCR')	- VERIFICA TRAVA MASTER POR IMCR			|
				//|	GetMv('IMD_IMCOUR')	- VERIFICA IMC OU IMCR						|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³    X5_TABELA = 'GV'    					³
				//³	BLMRG1 - IMC Negativo 					³
				//³	BLMRG2 - IMC Item     					³
				//³	BLMRG3 - IMC Pedido   					³
				//³	BLMRG4 - IMCR Negativo					³
				//³	BLMRG5 - IMCR Item    					³
				//³	BLMRG6 - IMCR Pedido  					³
				//³	BLMRG7 - IMC e  IMCR Negativo  			³
				//³	BLMRG8 - IMC ou IMCR Negativo  			³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				If lIMCouIMCR
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//| TRAVA MASTER VERIFICA IMC -> OU <- IMCR		|
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If TMPV->UB_IMC < nTrvMIMC .Or. TMPV->UB_IMCR < nTrvMIMCR
						cCodRegra 	:= 	'BLMRG8'
						cBlqImc		:=	'!lPromo e  IMC PROD.   [ '+cValToChar(TMPV->UB_IMC)+' ]   MENOR QUE TRAVA MASTER  [ '+cValToChar(nTrvMIMC )+' ]  -  '+cCodRegra
						cBlqImcR	:=	'!lPromo e  IMCR PROD.  [ '+cValToChar(TMPV->UB_IMCR)+' ]  MENOR QUE TRAVA MASTER  [ '+cValToChar(nTrvMIMCR)+' ]  -  '+cCodRegra

						lDelZRN := .F.
						Aadd(aPVBlq,  {SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO, cCodRegra, 'Item PV', nTrvMIMC,  TMPV->UB_IMC,  Alltrim(TMPV->B1_DESC), cBlqImc  })
						Aadd(aPVBlq,  {SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO, cCodRegra, 'Item PV', nTrvMIMCR, TMPV->UB_IMCR, Alltrim(TMPV->B1_DESC), cBlqImcR })
					EndIf

				Else

					If lMvIMC_TM .And. lMvIMCR_TM
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//| TRAVA MASTER - IMC -> E <- IMCR	Negativo	|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If	TMPV->UB_IMC < nTrvMIMC .And. TMPV->UB_IMCR < nTrvMIMCR
							cCodRegra 	:= 	'BLMRG7'
							cBlqImc		:=	'!lPromo e  IMC PROD.   [ '+cValToChar(TMPV->UB_IMC)+' ]   MENOR QUE TRAVA MASTER  [ '+cValToChar(nTrvMIMC)+'  ]  -  '+cCodRegra
							cBlqImcR	:=	'!lPromo e  IMCR PROD.  [ '+cValToChar(TMPV->UB_IMCR)+' ]  MENOR QUE TRAVA MASTER  [ '+cValToChar(nTrvMIMCR)+' ]  -  '+cCodRegra

							lDelZRN := .F.
							Aadd(aPVBlq,  {SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO, cCodRegra, 'Item PV', nTrvMIMC, TMPV->UB_IMC,  Alltrim(TMPV->B1_DESC), cBlqImc  })
							Aadd(aPVBlq,  {SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO, cCodRegra, 'Item PV', nTrvMIMC, TMPV->UB_IMCR, Alltrim(TMPV->B1_DESC), cBlqImcR })
						EndIf

					ElseIf lMvIMC_TM
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//| TRAVA MASTER - IMC Negativo		|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If TMPV->UB_IMC < nTrvMIMC
							cCodRegra 	:= 	'BLMRG1'
							nVenda		:=	TMPV->UB_IMC
							nRegra		:=	nTrvMIMC
							cCondBlq	:=	'!lPromo e  IMC PROD.  [ '+cValToChar(TMPV->UB_IMC)+' ]  MENOR QUE TRAVA MASTER  [ '+cValToChar(nTrvMIMC)+'  -  '+cCodRegra
							lDelZRN 	:= 	.F.
							Aadd(aPVBlq, {SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO, cCodRegra, 'Item PV', nRegra, nVenda, Alltrim(TMPV->B1_DESC), cCondBlq})
						EndIf

					ElseIf lMvIMCR_TM
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//| TRAVA MASTER - IMCR	Negativo	|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If TMPV->UB_IMCR < nTrvMIMCR
							cCodRegra 	:=	'BLMRG4'
							nVenda		:=	TMPV->UB_IMCR
							nRegra		:=	nTrvMIMC
							cCondBlq	:=	'!lPromo e  IMCR PROD.  [ '+cValToChar(TMPV->UB_IMCR)+' ]  MENOR QUE TRAVA MASTER  [ '+cValToChar(nTrvMIMCR)+'  -  '+cCodRegra
							lDelZRN 	:= 	.F.
							Aadd(aPVBlq, {SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO, cCodRegra, 'Item PV', nRegra, nVenda, Alltrim(TMPV->B1_DESC), cCondBlq})
						EndIf

					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//| TODOS OS PARAMETROS COMO FALSO - NAO VERIFICA TRAVA MASTER	|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					EndIf

				EndIf

				//EndIf

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  VERIFICA SE REGISTRO COM BLOQUEIO 'BLMRG' EXISTE NA ZRN E DELETA	³
			//|  QDO lChkLogZRN == .F. Eh A PRIMEIRA INCLUSAO 						|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lDelZRN .And. lChkLogZRN
				DelZRNLog(SUA->UA_NUM, TMPV->UB_ITEM, SUA->UA_NUMSC5, TMPV->UB_ITEMPV)
			EndIf

			IIF(Select('TMPD')!=0, TMPD->(DbCloseArea()), )
			DbSelectArea("TMPV")
			DbSkip()

		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  VERIFICA BLOQUEIOS SC9\SC5\SC6\ZRN		|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aPVBlq) > 0

			Begin Transaction

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  ESTORNA SC9 \ BLOQUEIA SC5    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//SC9Estorna(SUA->UA_NUMSC5)
				ExecBlock('SC9Estorna', .F., .F., {SUA->UA_NUMSC5}) //SC9Estorna(SUA->UA_NUMSC5)
				SC5Bloqueia(SUA->UA_NUMSC5)

				aMsgBlq := {}
				cMsg 	:= ''
				For nY:=1 To Len(aPVBlq)
					cTexto 	:= 	''

					/*					[01]			[02]        	  [03]			[04]		 	  [05]
					Aadd(aPVBlq,  {	SUA->UA_NUM,   TMPV->UB_ITEM,   SUA->UA_NUMSC5, TMPV->UB_ITEMPV, TMPV->UB_PRODUTO,
					cCodRegra, 	  (Pedido\Item PV),		nRegra, 		nVenda,		 TMPV->B1_DESC,		cCondBlq })
					[06]			[07]			  [08]			[09]			  [10]			  [11]
					*/

					cNumAT		:=	aPVBlq[nY][01]
					cItemAT		:=	aPVBlq[nY][02]
					cNumPV		:=	aPVBlq[nY][03]
					cItemPV		:=	aPVBlq[nY][04]
					cProduto	:=	aPVBlq[nY][05]
					cCodRegra	:=	aPVBlq[nY][06]
					cTpBloq		:=	aPVBlq[nY][07]
					nRegra		:=	aPVBlq[nY][08]
					nVenda		:=	aPVBlq[nY][09]
					cDescri		:=	aPVBlq[nY][10]
					cCondBlq	:=	aPVBlq[nY][11]

					/*
					If cCodRegra $ 'BLMRG1\BLMRG4'
					cTexto := 'MARGEM ABAIXO DA TRAVA MASTER '+IIF(cCodRegra=='BLMRG1','[ IMC ]',' [ IMCR ]')
					ElseIf cCodRegra $ 'BLMRG2\BLMRG5'
					cTexto := 'PRODUTO COM MARGEM ABAIXO DO MÍNIMO PERMITIDO '+IIF(cCodRegra=='BLMRG2','[ IMC ]',' [ IMCR ]')
					ElseIf cCodRegra $ 'BLMRG3\BLMRG6'
					cTexto := 'PEDIDO COM MARGEM ABAIXO DO MÍNIMO PERMITIDO '+IIF(cCodRegra=='BLMRG3','[ IMC ]',' [ IMCR ]')
					EndIf
					*/

					If cCodRegra $ 'BLMRG1\BLMRG4'
						cTexto := 'PRODUTO COM MARGEM ABAIXO DA TRAVA MASTER '+IIF(cCodRegra=='BLMRG1','[ IMC ]',' [ IMCR ]')
					ElseIf cCodRegra $ 'BLMRG7\BLMRG8'
						cTexto := 'PRODUTO COM MARGEM ABAIXO DA TRAVA MASTER [ IMC ]'+IIF(cCodRegra=='BLMRG7',' E ',' OU ')+'[ IMCR ]'
					EndIf

					cMsg += cTexto +ENTER
					Aadd(aMsgBlq,{cNumAT, cItemAT, cNumPV, cItemPV, cProduto, cDescri, cCodRegra, cTpBloq, nRegra, nVenda, cTexto, cCondBlq })

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³  BLOQUEIA SC6  \ GRAVA LOG     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SC6Bloqueia(cNumPV, cItemPV)
					ZRNGravaLog(cNumAT, cItemAT, cCodRegra, cTpBloq, nRegra, nVenda, cProduto, cNumPV, cItemPV)

				Next

			End Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  TELA COM BLOQUEIO IMC \ IMCR  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//IIF(!Empty(cMsg), MsgAlert(cMsg,'TMKVFIM'),)
			IIF(Len(aMsgBlq)>0, TelaBloq(aMsgBlq),)

		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ OBS.: BLOQUEIO DE REGRA DE NEGOCIO (DESC\COM\NEG)                	|
			//|		  POR PADRAO JA ESTA COM FLAGs (C5_BLQ e C6_BLOQUEI)			³
			//|		  (JA GRAVADOS NA TAB. ZRN VIA ROTINA LogRegNeg())				|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ NENHUM ITEM ESTA NA REGRA DE NEGOCIO -> LIBERA DO BLOQUEIO SC5\SC6	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea('ZRN');DbSetOrder(1)	//	ZRN_FILIAL + ZRN_NUMAT + ZRN_ITEMAT  + ZRN_CODRN
			If !DbSeek(xFilial('ZRN')+ SUA->UA_NUM, .F.)
				Begin Transaction

					SC5DesBlq(SUA->UA_NUMSC5)
					SC6DesBlq(SUA->UA_NUMSC5)

					If !SC9ExistReg(SUA->UA_NUMSC5)
						// NAO EXISTE REGISTRO NO SC9, PV NAO ESTA BLOQUEADO ENTAO GERA SC9.

						SC6->(DbSetOrder(1))		// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
						SC6->(DbSeek(xFilial('SC6')+SUA->UA_NUMSC5,.F.))
						SA1->(DbSeek(xFilial('SA1')+SC6->C6_CLI+SC6->C6_LOJA))

						DbSelectArea('SC6')
						Do While !Eof() .And. xFilial('SC6') == SC6->C6_FILIAL .And. SC6->C6_NUM == SUA->UA_NUMSC5

							Begin Transaction
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³  EXECUTA MaLibDoFat  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								ExecMaLibDoFat()

							End Transaction

							DbSelectArea('SC6')
							DbSkip()

						EndDo

					EndIf
				End Transaction
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ EXISTE ALGUM ITEM BLOQUEADO(ZRN) PELA REGRA DE NEGOCIO E CAMPOS DE BLOQUEIO EM BRANCO						|
				//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
				//³ OCORRENCIA: C5_BLQ == '1'.And.Empty(C5_LIBRNV1) QDO PV COM APENAS BLOQUEIO DE REGRA DE NEGOCIO NO PADRAO	³
				//| SOLUCAO:	FORCA BLOQUEIO NOS CAMPOS CUSTOMIZADOS C5_LIBRNV1,2,3											|
				//|				C6_BLOQUEI E LOG->ZRN JA ESTAO GRAVADOS															|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea('SC5');DbSetOrder(1)		// C5_FILIAL+C5_NUM
				If DbSeek(xFilial('SC5') + SUA->UA_NUMSC5, .F.)
					If SC5->C5_BLQ == '1' .And. Empty(SC5->C5_LIBRNV1)

						Begin Transaction
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³  ESTORNA SC9 \ BLOQUEIA SC5    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//SC9Estorna(SUA->UA_NUMSC5)
							ExecBlock('SC9Estorna', .F., .F., {SUA->UA_NUMSC5})	//SC9Estorna(SUA->UA_NUMSC5)
							SC5Bloqueia(SUA->UA_NUMSC5)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ NAO Eh NECESSARIO ATUALIZA SC6											|
							//| QDO BLOQ DE REGRA NO PADRAO TODO OS ITENS VEM COM C6_BLOQUEI = '01'		|
							//|																			|
							//| DE QQ MANEIRA VERIFICO ZRN x SC6  (SE C5_BLQ=1 C6_BLOQUEI TEM Q SER =01)|
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							IIF(Select('TMPC')!=0, TMPC->(DbCloseArea()), )
							cQuery := "	SELECT 	ZRN.ZRN_FILIAL, ZRN.ZRN_NUMAT, ZRN.ZRN_ITEMAT, ZRN.ZRN_PEDIDO, ZRN.ZRN_ITEMPV, ZRN.ZRN_PRODUT, 	"+ENTER
							cQuery += "			ZRN.ZRN_TPBLQ, ZRN.ZRN_VENDA,  ZRN.ZRN_REGRA,  ZRN.ZRN_CODRN,  ZRN.ZRN_TPBLQ,  ZRN.ZRN_CPOBLQ,	"+ENTER
							cQuery += "			SC6.C6_BLOQUEI, SC6.R_E_C_N_O_ AS SC6RECNO														"+ENTER+ENTER

							cQuery += " FROM 	"+RetSqlName("ZRN")+" ZRN   											   	"+ENTER
							cQuery += "										INNER JOIN "+RetSqlName("SC6")+" SC6 			"+ENTER
							cQuery += "										ON 	SC6.C6_FILIAL 	 = 	ZRN.ZRN_FILIAL			"+ENTER
							cQuery += "										AND SC6.C6_NUM 		 =  ZRN.ZRN_PEDIDO			"+ENTER
							cQuery += "										AND SC6.C6_ITEM 	 = 	ZRN.ZRN_ITEMPV			"+ENTER
							cQuery += "										AND SC6.C6_PRODUTO 	 = 	ZRN.ZRN_PRODUT			"+ENTER
							cQuery += "										AND SC6.C6_BLOQUEI	 =  '  '					"+ENTER
							cQuery += "										AND SC6.D_E_L_E_T_ 	!= 	'*' 					"+ENTER+ENTER

							cQuery += " WHERE 	ZRN.ZRN_FILIAL 	=  '"+SUA->UA_FILIAL+"' 	"+ENTER
							cQuery += " AND 	ZRN.ZRN_PEDIDO 	=  '"+SUA->UA_NUMSC5+"'		"+ENTER
							cQuery += " AND 	ZRN.D_E_L_E_T_ !=  '*' 						"+ENTER+ENTER

							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPC', .F., .T.)
							DbSelectArea('TMPC');DbGoTop()
							Do While !Eof()

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³  BLOQUEIA SC6  \ GRAVA LOG     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								SC6Bloqueia(TMPC->ZRN_PEDIDO, TMPC->ZRN_ITEMPV)

								DbSelectArea('TMPC')
								DbSkip()
							EndDo

							IIF(Select('TMPC')!=0, TMPC->(DbCloseArea()), )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³  NAO Eh NECESSARIO ATUALIZA ZRN POIS JA FOI ATUALIZADA PELA FUNCAO LogRegNeg()	|
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//ZRNGravaLog(cNumAT, cItemAT, cCodRegra, cTpBloq, nRegra, nVenda, cProduto, cNumPV, cItemPV)

						End Transaction

					EndIf
				EndIf

			EndIf

		EndIf

		IIF(Select('TMPD')!=0, TMPD->(DbCloseArea()), )
		IIF(Select('TMPV')!=0, TMPV->(DbCloseArea()), )
	EndIf

	If lOperFat .And. (SC5->C5_BLQ == '1' .And. SC5->C5_LIBRNV1 == 'L' .And. SC5->C5_LIBRNV2 == 'L' .And. SC5->C5_LIBRNV3 == 'L')

		//MsgAlert('ALERTA-2  - INFORMAR A TI',"Alerta - 2")

		DbSelectArea("SC5");DbSetOrder(1)
		If DbSeek(xFilial("SC5")+SUA->UA_NUMSC5, .F.)
			RecLock("SC5",.F.)
			SC5->C5_LIBRNV1 := 'B'
			MsUnLock()
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizo flag para ser considerada a consulta anterior     ³
	//³quando o usuario deleta algum item.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SUB');DbSetOrder(1)
	nPosItem := Ascan(aHeader, {|x| Alltrim(x[2])=='UB_ITEM'})
	cNumAT	 := SUA->UA_NUM
	For nX := 1 To Len(aCols)
		If GdDeleted(nX)
			//nItemAT := aCols[nX][nPosItem]
			//cProduto:= aCols[nX][X_PRODUTO]

			If DbSeek(xFilial("SUB")+SUA->UA_NUMORIG+StrZero(nX,2)+aCols[nX,X_PRODUTO])
				//If DbSeek(xFilial("SUB")+cNumAT+nItemAT+aCols[nX,X_PRODUTO])
				Reclock("SUB", .F.)
				SUB->UB_FLAGCON := "S"
				MsUnlock()
			EndIf
			/*
			cSql :=" UPDATE "+RetSqlName('SUB')
			cSql +=" 	SET UB_FLAGCON = 'S' "
			cSql +=" WHERE UB_FILIAL   = '"+xFilial('SUB')+"' "
			cSql +=" AND   UB_NUM      = '"+cNumAT+"' "
			cSql +=" AND   UB_ITEM     = '"+nItemAT+"' "
			cSql +=" AND   UB_PRODUTO  = '"+cProduto+"' "
			cSql +=" AND   D_E_L_E_T_  = '*' "

			nErro := TcSqlExec(cSql)
			IIF(nErro==0, TcSqlExec('COMMIT'), TcSqlExec('ROLLBACK'))
			*/

		EndIf

	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro os itens de campanhas de vendas relacionadas a este pedido.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//removido em função da descontinuação da campanha de vendas - Rodrigo carvalho - Solutio 09/02/2015
	/*

	DbSelectArea("ZZI")
	for nX := 1 to Len(__aProdCamp)
	If __aProdCamp[nX] != NIL .and. __aProdCamp[nX,3]
	Reclock("ZZI",.T.)
	Replace ZZI_FILIAL with xFilial("ZZI"),;
	ZZI_NUM    with SUA->UA_NUMSC5,;
	ZZI_PRODUT with __aProdCamp[nX,1],;
	ZZI_CODCAM with __aProdCamp[nX,2]
	MsUnlock()
	EndIf
	next
	__aProdCamp := {}
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se eh primeira compra do cliente            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If __PrimComp == "S"  // primeira compra
		If lEnvMail
			//Envia e-mail para o departamento de credito avisando sobre novo cliente
			EnvMailCred(SUA->UA_NUMSC5)
		EndIf
		__PrimComp := "N"	// Primeira compra do cliente
	EndIf

	If Len(aProds) > 0
		U_TmkMailPed(SUA->UA_NUMSC5,SUA->UA_FILIAL,SUA->UA_EMISSAO,aProds)
		aProds:={}
	EndIf


	//³ ENVIA EMAIL INFORMANDO ATENDIMENTO\ITENS RESERVADOS	³
	If lTemReserva
		U_SC0Mails(SUA->UA_NUM)
	EndIf

	////JULIO JACOVENKO, em 18/01/2018
	////
	/////AQUI VAMOS AJUSTAR O CAMPO SA1->A1_CLIFRTE='2'
	IF LOK  //SE PEDIDO APROVADO
		IF UPPER(SA1->A1_CLIFRTE) =='X'
			DbSelectArea("SA1")
			RecLock("SA1",.F.)
			SA1->A1_CLIFRTE		:= "Y"
			MsUnlock()
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura o ambiente                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//Verifico se houve algum erro na composicao das comissoes,havendo erro envia log por e-mail
	//removido em 09/02/2015 em função de que o envio de e-mails foi descontinuado - Rodrigo Carvalho - Solutio
	/*
	If Len(aLogComiss)>0
	MailMaxComissao()
	EndIf
	*/

	If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
		MsAguarde({||SF4->(Testetmkok())},"Aguarde...","Verificando se é cópia e processando...")
	Else
		Testetmkok()
	EndIf

	////////////////////////////////////////////////CRIADO PELO JULIO JACOVENKO em 14/10/2011
	////////////////////////////////////////////////PARA GRAVAR O CODIGO DO CLIENTE CORRETO QUANDO
	////////////////////////////////////////////////TRANSFORMA PROSPECT PARA CLIENTES
	///////////////////////////////////////////////////////////////////////////

	If lRunProspect //SA1->A1_STATUS=='X'
		fVeCodCli(cCodcli,cLojCli,cNumSC5,cNumFil)
	EndIf

	***********************************************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  FABIANO PEREIRA - SOLUTIO            	³
	//³  ZERA VARIAVEIS PUBLICAS - TMKACTIVE()	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// VldGrvRes VALIDA\GRAVA RESERVA - SC0 [PROJETO CORREIAS]
	lGravaRes := .T.
	IIF(lOperFat, (oProcess:IncRegua2("Verificando Reservas"), ExecBlock('VldGrvRes',.F.,.F.,{lGravaRes, aPTransf})), )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  FABIANO PEREIRA - SOLUTIO            	³
	//³  ZERA VARIAVEIS PUBLICAS - TMKACTIVE()	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aProdxImp  	:= {}	//	PRODUTO X IMPOSTOS
	aContDesc 	:= {}	//	ARRAY UTILIZADO NA REGRA DE DESCONTO
	aHistTV		:= {}	//	HISTORICO DE ATENDIMENTO
	aImdCodR 	:= {}	//	CODIGO DA REGRA DE NEGOCIO

	If Type('aIPvImda090') <> 'U'
		aIPvImda090 := Nil
	EndIf


	Return(.T.)
*******************************************************************************
Static Function SC5Bloqueia(cNumPV)
*******************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| REALIZA BLOQUEIO - SC5	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SC5');DbSetOrder(1)		// C5_FILIAL+C5_NUM
	If DbSeek(xFilial('SC5') + cNumPV, .F.)
		RecLock('SC5',.F.)
		SC5->C5_BLQ  	:= 	'1'
		SC5->C5_LIBRNV1	:= 	'B'
		SC5->C5_LIBRNV2	:= 	'B'
		SC5->C5_LIBRNV3	:=	'B'
		MsUnLock()
	EndIf

	Return()
*******************************************************************************
Static Function SC6Bloqueia(cNumPV, cItemPV)
*******************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| REALIZA BLOQUEIO - SC6	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SC6');DbSetOrder(1)		// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If DbSeek(xFilial('SC6')+ cNumPV + cItemPV, .F.)
		RecLock('SC6', .F.)
		SC6->C6_BLOQUEI := '01'
		MsUnLock()
	EndIf

	Return()

*******************************************************************************
Static Function ZRNGravaLog(cNumAT, cItemAT, cCodRegra, cTpBloq, nRegra, nVenda,cProduto, cNumPV, cItemPV)
*******************************************************************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| 						   				GRAVA LOG - ZRN									 					|
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//| ZRNGravaLog(SUA->UA_NUM, TMPV->UB_ITEM, 'BLMRG1', 'Item PV', nTrvMIMC, TMPV->UB_IMC)						|
	//| ZRNGravaLog(SUA->UA_NUM, TMPV->UB_ITEM, 'BLMRG2', 'Item PV', ((TMPV->IM1_IMCMIN -1 ) * 100), TMPV->UB_IMC)	|
	//| ZRNGravaLog(SUA->UA_NUM, TMPV->UB_ITEM, 'BLMRG3', 'Pedido', TMPV->RGV_IMCMIN, SUA->UA_IMC)					|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// cCodRegra[ BLMRG1 - MARGEM NEGATIVA 	- IMC	]
	//			[ BLMRG2 - MARGEM ITEM 		- IMC 	]
	//			[ BLMRG3 - MARGEM PEDIDO 			]
	//			[ BLMRG4 - MARGEM NEGATIVA 	- IMCR 	]
	//			[ BLMRG5 - MARGEM ITEM 		- IMCR 	]
	//
	// cTpBloq 	[ Item PV - Pedido		 ]
	//
	// nRegra  	[ nTrvMIMC == GetMv('IMD_MINIMC')	]
	//			[ ((TMPV->IM1_IMCMIN -1 ) * 100)	]
	//
	// nVenda	[ TMPV->UB_IMC			 ]
	//			[ SUA->UA_IMC 			 ]
	//			[ TMPV->RGV_IMCMIN		 ]
	//

	DbSelectArea('ZRN');DbSetOrder(1)	//	ZRN_FILIAL + ZRN_NUMAT + ZRN_ITEMAT + ZRN_CODRN
	lGrava := !DbSeek(xFilial('ZRN') + cNumAT + cItemAT + PadR(cCodRegra, TamSx3('ZRN_CODRN')[01]), .F.)

	DbSelectArea('ZRN')
	Reclock('ZRN',lGrava)
	ZRN->ZRN_FILIAL	:=	xFilial('ZRN')
	ZRN->ZRN_NUMAT	:=	cNumAT
	ZRN->ZRN_ITEMAT	:= 	cItemAT
	ZRN->ZRN_PRODUT	:=	cProduto
	ZRN->ZRN_VENDA	:=	Round(nVenda, TamSx3('ZRN_VENDA')[02])
	ZRN->ZRN_CODRN	:=	cCodRegra
	ZRN->ZRN_REGRA	:=	Round(nRegra, TamSx3('ZRN_REGRA')[02])
	ZRN->ZRN_TPBLQ 	:=	Posicione("SX5",1,xFilial("SX5")+"GV"+cCodRegra,"X5_DESCRI" )
	ZRN->ZRN_CPOBLQ	:=	cTpBloq
	ZRN->ZRN_PEDIDO	:=	cNumPV
	ZRN->ZRN_ITEMPV	:=	cItemPV
	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| VERIFICA\APAGA ALGUM LOG QUE POSSA TER OCORRIDO E NAO EXISTE MAIS A DIVERGENCIA		|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('ZRN');Dbsetorder(1)
	If Dbseek(xFilial('ZRN') + cNumAT + cItemAT + 'BLM')
		Do While !Eof().And. Substr(ZRN->ZRN_CODRN,1,3) == 'BLM' .And.  ZRN->ZRN_PEDIDO == cNumPV .And. ZRN->ZRN_ITEMPV == cItemPV
			If Alltrim(ZRN->ZRN_CODRN) != Alltrim(cCodRegra)
				RecLock('ZRN',.F.)
				DbDelete()
				MsUnlock()
			EndIf
			DbSkip()
		EndDo
	EndIf

	Return()
*******************************************************************************
Static Function DelZRNLog(cNumAT, cItemAT, cNumPV, cItemPV)
*******************************************************************************

	DbSelectArea('ZRN');Dbsetorder(1)
	If Dbseek(xFilial('ZRN') + cNumAT + cItemAT + 'BLM')
		Do While !Eof().And. Substr(ZRN->ZRN_CODRN,1,3) == 'BLM' .And.  ZRN->ZRN_PEDIDO == cNumPV .And. ZRN->ZRN_ITEMPV == cItemPV
			RecLock('ZRN',.F.)
			DbDelete()
			MsUnlock()
			DbSkip()
		EndDo
	EndIf

	Return()
*******************************************************************************
Static Function SC5DesBlq(cNumPV, lForca)
*******************************************************************************
	Default lForca := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| REALIZA BLOQUEIO - SC5	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SC5');DbSetOrder(1)		// C5_FILIAL+C5_NUM
	If DbSeek(xFilial('SC5') + cNumPV, .F.)
		If !Empty(SC5->C5_BLQ) .Or. !Empty(SC5->C5_LIBRNV1) .Or. !Empty(SC5->C5_LIBRNV2) .Or. !Empty(SC5->C5_LIBRNV3) .Or. lForca
			RecLock('SC5',.F.)
			SC5->C5_BLQ  	:= 	' '
			SC5->C5_LIBRNV1	:= 	' '
			SC5->C5_LIBRNV2	:= 	' '
			SC5->C5_LIBRNV3	:=	' '
			MsUnLock()
		EndIf
	EndIf

	Return()
*******************************************************************************
Static Function SC6DesBlq(cNumPV)
*******************************************************************************
	DbSelectArea('SC6');DbSetOrder(1)		// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If DbSeek(xFilial('SC6') + cNumPV, .F.)
		Do While !Eof() .And. SC6->C6_NUM == cNumPV
			If !Empty(SC6->C6_BLOQUEI)
				RecLock('SC6', .F.)
				SC6->C6_BLOQUEI := '  '
				MsUnLock()
			EndIf
			DbSkip()
		EndDo
	EndIf

	Return()
*******************************************************************************
Static Function TelaBloq(aMsgBlq)
*******************************************************************************

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|   	TELA BLOQUEIO PV - IMC \ IMCR		|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//				   [01]		[02]    [03]	 [04]	  [05]      [06]      [07]	    [08]	[09]    [10]    [11]	 [12]
	//  Aadd(aMsgBlq,{cNumAT, cItemAT, cNumPV, cItemPV, cProduto, cDescri, cCodRegra, cTpBloq, nRegra, nVenda, cTexto, cCondBlq })

	Define Dialog oDlgBlq Title "Bloqueio PV - IMC \ IMCR" From 120,120 To 350,950 Pixel

	oBrowse := TcBrowse():New(001, 001, 415, 095,,{'Item At.','Produto','Descrição','Bloqueio'},{50,50,50},oDlgBlq,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oBrowse:SetArray(aMsgBlq)

	oBrowse:AddColumn( TcColumn():New('Item At.'	,{|| aMsgBlq[oBrowse:nAt][02] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn( TcColumn():New('Produto'		,{|| aMsgBlq[oBrowse:nAt][05] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn( TcColumn():New('Descrição'	,{|| aMsgBlq[oBrowse:nAt][06] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
	oBrowse:AddColumn( TcColumn():New('Bloqueio'	,{|| aMsgBlq[oBrowse:nAt][11] },,,,"LEFT",,.F.,.T.,,,,.F.,) )

	If UsrRetName(__cUserId) == 'SOLUTIO'
		oBrowse:AddColumn( TcColumn():New('Detalhe'		,{|| aMsgBlq[oBrowse:nAt][12] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
		/*
		oBrowse:AddColumn( TcColumn():New('cCodRegra'		,{|| aMsgBlq[oBrowse:nAt][07] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
		oBrowse:AddColumn( TcColumn():New('cTpBloq'			,{|| aMsgBlq[oBrowse:nAt][08] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
		oBrowse:AddColumn( TcColumn():New('nRegra'			,{|| aMsgBlq[oBrowse:nAt][09] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
		oBrowse:AddColumn( TcColumn():New('nVenda'	   		,{|| aMsgBlq[oBrowse:nAt][10] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
		*/
	EndIf

	TButton():New( 100, 365, '&Sair', oDlgBlq,{|| oDlgBlq:End() },30,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	@ 100, 003  Say oSay1 PROMPT "Nesta tela são exibidas todas as regras de MARGEM que bloqueiam o Pedido de Venda." Size 225, 020 Of oDlgBlq COLORS CLR_HRED,CLR_WHITE/*0, 16777215*/ Pixel

	Activate Dialog oDlgBlq Centered

	Return()
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³DEFCOMIS    ³ Autor ³Márcio Borges        ³ Data ³ 28/04/03 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Define o percentual de comissao dos vendedores              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³obs       ³Deve se estar posicionado no SB1                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ESPECIFICO PARA O CLIENTE IMDEPA 						      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	*********************************************************************
User Function DefComis(_cVendedor,lRep,cPagCom,_nDesNeg,_nAcreNeg)
	*********************************************************************

	Local aSaveArea	    := GetArea()
	Local nComCli       := SA1->A1_COMIS    	  // Comissão CLiente
	Local nProdComiss	:= SB1->B1_COMIS          //Comissao do Produto
	Local cProdMerc		:= SB1->B1_MERCADO
	//Local cDescComis    := GetMV("MV_COMIDES")	//	RODRIGO SOLUTIO
	//Local cAcreComis    := GetMV("MV_COMIACR")	//	RODRIGO SOLUTIO
	//Local nLimDescComis := 0//GetMV("MV_LIMDESC",,0) //Limite máximo p/ Desconto na Comissao do Vendedor		//	RODRIGO SOLUTIO
	Local _ComisVend    := 0//SA3->(Posicione("SA3",1,xFilial("SA3")+ _cVendedor,"A3_COMIS"))Local nComisPaga    := 0
	Local nPerComisREP  := SA1->A1_COMISRE
	//Local nComisPaga    := 0
	//Local lTemLimDesc   :=.F.
	Local cFilVend      := Space(2)

	DbSelectArea('SA3')
	DbSetOrder(1)

	If SA3->( DbSeek( xFilial( "SA3" ) + _cVendedor ) )
		_ComisVend    :=SA3->A3_COMIS
		cFilVend      :=SA3->A3_CODFIL
		//removido em 10/02/2015 em função de que as regras de desconto foram descontinuadas
		// nLimDescComis :=SuperGetMv("MV_LIMDESC" , .T. , 0 ,cFilVend)
	EndIf

	//removido em 10/02/2015 em função de que as regras de desconto e acrescimos foram descontinuadas - Rodrigo Carvalho - Solutio
	//Tratamento para o Desconto na Comissao do Vendedor interno
	//Em Cuiaba o limite de desconto na comissao é baseado apenas no A3_COMIS, o desconto na venda é desconsiderado no cálculo
	/*
	If !lRep
	If (nLimDescComis > 0 .OR. cFilVend $ "02/04") .AND. ( _nDesNeg > nLimDescComis)
	lTemLimDesc:=.T.
	EndIf
	EndIf
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso nao tenha sido passado o vendedor ou para este cliente 		 ³
	//³nao se paga comissao para este vendedor, retorna 0          		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(_cVendedor) .or. cPagCom <> "1"
		Return 0
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso as comissoes nao estejam cadastradas no SA1 nem nas campanhas   ³
	//³vale a menor entre o Cadastro de Produtos e o Cadastro de Vendedores.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//Alterado esta lógica para: se A1_COMIS == 0 vale a formula acima, caso contrário, é a fórmula acima X A1_COMIS/100 */
	//vide abaixo  (cONSIDERA SEMRE A MENOR COMISSAO ENTRE A COMISSAO DO PRODUTO E A DO VENDEDOR)

	//Solicitado por Beto 25/06/09
	//If _ComisVend == 0 .OR. nProdComiss == 0
	//	nformula_comissao := iif(_ComisVend > nProdComiss,_ComisVend,nProdComiss)  //Max(_ComisVend,nProdComiss)
	//Else
	nformula_comissao := iif(_ComisVend < nProdComiss,_ComisVend,nProdComiss)  //Min(_ComisVend,nProdComiss)
	//EndIf

	//|Chamado: 	AAZQ9Y 			|Assunto: Comissao Repasse Produto Mercado |Analista: Cristiano MAchado
	//|Solicitante: Marcia Silveira |Data: 24/06/09
	//|Obs.: SATIV1 = Montadoras

	If nComCli == 0 .or. (cProdMerc == 'S' .AND. SA1->A1_SATIV1 = '000002')

		//If cProdMerc == 'S' .AND. SA1->A1_SATIV1 = '000002'
		nComCli := nformula_comissao
	ElseIf cProdMerc == 'N'
		nComCli := nformula_comissao * nComCli/100
	ElseIf cProdMerc == 'S' .AND.  SA1->A1_SATIV1 <> '000002'
		nComCli := nformula_comissao * nComCli/100

	EndIf
	//FIM AAZQ5R

	// Caso For Vendedor Representante  e Tiver comissão específica no SA1->A1_COMISRE
	IF nPerComisREP  <> 0 .AND. lRep
		nComCli := nPerComisREP
	EndIf

	RestArea(aSaveArea)

	Return nComCli

*******************************************************************************
Static Function EnvMailCred(cNum) // Envia e-mail para o departamento de credito avisando que foi inserido um novo cliente.
*******************************************************************************

	Local cServer 	:= GetMV("MV_RElseRV" )
	Local cAccount 	:= Alltrim(GETMV("MV_RELACNT"))
	Local cPassword := Alltrim(GETMV("MV_RELPSW"))
	Local lAuth 	:= .F. 
	Local cAssunto 	:= "Cliente novo"
	Local cMensagem	:= ""
	Local cEmailTo 	:= ""
	Local cEmailBcc	:= ""
	Local lResult  	:= .F.
	Local cError 	:= ""
	
	lAuth 	:= Getmv("MV_RELAUTH")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cEmailTo := GetMV("MV_EMAILCR")

	// Posiciona arquivo de pedidos de venda (SC5)
	DbSelectArea("SC5")
	dbSetOrder(1)
	DbSeek(xFilial("SC5")+cNum)

	// corpo do e-mail
	cMensagem := "Ao responsável pelo departamento de crédito"
	cMensagem += CRLF
	cMensagem += CRLF
	cMensagem += "O sistema Advanced Protheus comunica a inserção do primeiro pedido de venda para o cliente. " + CRLF
	cMensagem += "Favor proceder a avalidação de crédito do pedido de venda e a classificação do cliente em relação ao crédito." + CRLF
	cMensagem += "Seguem abaixo os dados do pedido:" + CRLF+CRLF
	cMensagem += "Número: "+SC5->C5_NUM + CRLF
	cMensagem += "Emissão: "+dtoc(SC5->C5_EMISSAO) + CRLF
	cMensagem += "Código/Loja do Cliente....: "+SA1->A1_COD+"/"+SA1->A1_LOJA + CRLF
	cMensagem += "Nome do Cliente..............: "+SA1->A1_NOME + CRLF
	cMensagem += "Valor do Pedido de Venda: "+Transform(aValores[6],"@E 99,999,999.99") + CRLF

	// conectando-se com o servidor de e-mail
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

	// fazendo autenticacao
	If lResult .And. lAuth
		lResult := MailAuth(cAccount,cPassword)
		If !lResult
			If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				lResult := QADGetMail() // Funcao que abre uma janela perguntando o usuario e senha para fazer autenticacao
			Else
				ConOut("Não foi possivel autenticar o usuário ou senha, será desconectado...")
			EndIf
		EndIf
		If !lResult
			//Erro na conexao com o SMTP Server
			
			GET MAIL ERROR cError
			If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				U_Mensagem("Erro de Autenticacao no envio de e-mail: "+cError)
			Else
				ConOut("Erro de Autenticacao no envio de e-mail: "+cError)
			EndIf
			Return Nil
		EndIf
	Else
		If !lResult
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				U_Mensagem("Erro de Conexao no envio de e-mail: "+cError)
			Else
				ConOut("Erro de Conexao no envio de e-mail: "+cError)
			EndIf
			Return Nil
		EndIf
	EndIf

	// enviando e-mail
	If lResult
		SEND MAIL FROM cAccount ;
		TO			 cEmailTo;
		BCC     	cEmailBcc;
		SUBJECT 	cAssunto;
		BODY    	cMensagem;
		RESULT lResult
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError

			If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
				U_Mensagem("Erro no envio de e-mail: "+cError)
			Else
				ConOut("Erro no envio de e-mail: "+cError)
			EndIf
		EndIf
		DISCONNECT SMTP SERVER
	EndIf

	Return(lResult)
*******************************************************************************
Static Function Testetmkok()
*******************************************************************************
	// projeto f11,
	// não cancela mais pelo botão COPIA --> NÃO CANCELA ORÇAMENTO ORIGINAL QUANDO FOR ORÇAMENTO, COMENTADO ESTA ROTINA

	// Libera a saida da tela
	__Podesair  := "S"

	// Flag para identificar que o proximo atendimento ainda nao tera clicado no botao
	// de condicao de pagamento
	__lJaBotCPag := .F.
	__lJaBotPag2 := .F.
	//| Controla se houve alteração no Orçamento ... Já vem setada como alterado...
	_lAltOrc  := .T.

	// Zera o array com flag indicando itens em que o usuario ja digitou a quantidade,
	// liberando a digitacao para o proximo atendimento
	__aItDigQtd  := {}

	// Ate qual linha do aCols o sistema deve permitir a delecao de itens do aCols
	__nLibDel := 0

	// Indica que no proximo atendimento, ao se passar pelo campo UA_TABELA, a validacao
	// deve atualizar os precos dos itens do atendimento
	__cTabAtu	:= ""

	// Exibe mensagens
	If !Empty(__cMensagem)
		If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
			IW_MsgBox(__cMensagem, 'Atenção', 'STOP')
		Else
			ConOut(__cMensagem)
		EndIf
	EndIf
	__cMensagem := NIL

	//Projeto Abaulados
	If Len(aAbaulSimi)>0
		U_IMDA702(aAbaulSimi)
		aAbaulSimi:={}
	EndIf

	// Faz chamada ao programa de envio de e-mail
	If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
		//	MsAguarde({||SF4->(U_EmailHtml(M->UA_NUM,M->UA_CLIENTE,M->UA_LOJA,xFilial("SUA"),SUA->UA_NUMSC5,M->UA_OPER,Alltrim(M->UA_OCCLI),M->UA_TPFRETE,Alltrim(M->UA_DESCNT),M->UA_CODCONT,lTk271Auto))},"E-mail Vendas","Publicando e-mail...")
		//	MsAguarde({||SF4->(U_IMDA800(M->UA_NUM,M->UA_CLIENTE,M->UA_LOJA,xFilial("SUA"),SUA->UA_NUMSC5,M->UA_OPER,Alltrim(M->UA_OCCLI),M->UA_TPFRETE,Alltrim(M->UA_DESCNT),M->UA_CODCONT,lTk271Auto))},"E-mail Vendas","Enviando...")
	Else
		ConOut("Iniciando chamada do EmailHtml PARA VENDAS MAIL")
		SF4->(U_EmailHtml(M->UA_NUM,M->UA_CLIENTE,M->UA_LOJA,xFilial("SUA"),SUA->UA_NUMSC5,M->UA_OPER,Alltrim(M->UA_OCCLI),M->UA_TPFRETE,Alltrim(M->UA_DESCNT),M->UA_CODCONT,lTk271Auto))

		//Inicio teste Edi
		If SUA->UA_OPERADO='0445'//Pedido Vendas Mail
			SF4->(U_EmailVmail(M->UA_NUM,M->UA_CLIENTE,M->UA_LOJA,xFilial("SUA"),SUA->UA_NUMSC5,M->UA_OPER,Alltrim(M->UA_OCCLI),M->UA_TPFRETE,Alltrim(M->UA_DESCNT),M->UA_CODCONT,lTk271Auto))
		EndIf

		//Fim teste Edi
	EndIf
	// mostra o system tracker do pedido no caso de faturamento
	If  ( Type("lTk271Auto") = "U" .OR. !lTk271Auto )
		If M->UA_OPER == "1" .and. MsgYesNo('Visualiza System Tracker do Pedido!')
			U_IMDF080()
		EndIf
	EndIf

	Return
*******************************************************************************
Static Function RetStruct( _Alias_ )
*******************************************************************************

	Local aArea   := GetArea()
	Local aStruc  := Array(0)

	DbSelectArea('SX3')
	dbSetOrder(1)
	dbSeek( _Alias_ )
	Do While !Eof() .and. X3_ARQUIVO = _Alias_
		If X3Uso(X3_USADO) .and. cNivel >= X3_NIVEL .and. X3_PROPRI = 'U' .and. X3_CONTEXT != "V"
			Aadd(aStruc, {X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL})
		EndIf
		DbSelectArea('SX3')
		dbSkip()
	EndDo

	RestArea(aArea)

	Return(aStruc)

*******************************************************************************
Static Function fVeCodCli(cCodcli,cLojCli,cNumSC5,cNumFil) // Funcao auxiliar para ajustar codigo de cliente quando prospect para cliente 
*******************************************************************************
	_aArea:=GetArea()

	DbSelectArea("SA1")
	If DbSeek(XFILIAL("SA1")+cCodCli+cLojCli)
		cCgcCli:=SA1->A1_CGC
		fGravaPro(cCgcCli, cCodCli, cLojCli, cNumSC5, cNumFil)
	EndIf

	lRunProspect:=.F.
	RestArea(_aArea)

Return

//Codigo principal para ajustar o codigo do cliente para quando for Prospect para Cliente, para pegar o mesmo
//codigo do cliente quado existir os 11 primeiros digitos do CGC  
*******************************************************************************
Static Function fGravaPro(cCgcCli, cCodCli, cLojCli, cNumSC5, cNumFil)
*******************************************************************************
	///cNumSC5 e cNumFil, são o numero do Pedido Gerado....
	//Local _cArea := GetArea()
//	Local cCodPreCli :=' '
	//Local cLojPreCli :=' '

	Private cCodAuto :=cCodCli
	Private cLojAuto :=cLojCli

	cCGC:=cCgcCli
	cCGCF:=SUBSTR(cCGC,1,08)  //SUBSTR(cCGC,1,11)
	lAchouC:=.F.
	lAchouF:=.F.
	lGrava :=.F.
	cCODANT:=''
	cCGCANT:=''

	cQUERY:=""
	cQUERY+="SELECT * FROM "+RetSqlName('SA1')+" "
	//cQUERY+="WHERE SUBSTR(A1_CGC,1,11)='"+cCGCF+"' "
	cQUERY+="WHERE SUBSTR(A1_CGC,1,08)='"+cCGCF+"' "
	cQUERY+="ORDER BY A1_CGC "

	//cQUERY := ChangeQuery( cQUERY )

	If( Select("QRYDB") <> 0 ) // Se a area a ser utilizada estiver em uso, fecho a mesma
		QRYDB->( dbCloseArea() )
	EndIf

	//MEMOWRIT( "C:\SQLSIGA\JKTESTE1.SQL", cQUERY )

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQUERY),"QRYDB",.F.,.T.)

	DbSelectArea("QRYDB")
	QRYDB->(DBGOTOP())

	lOK    :=.F.
	cCODANT := QRYDB->A1_COD
	cLOJANT := QRYDB->A1_LOJA

	cCODATU := QRYDB->A1_COD
	cLOJATU := QRYDB->A1_LOJA

	nREC   := QRYDB->R_E_C_N_O_

	WHILE !EOF() .AND. cCGCF==SUBSTR(QRYDB->A1_CGC,1,08)   //SUBSTR(QRYDB->A1_CGC,1,11)
		IF cCGC<>QRYDB->A1_CGC
			cCODANT:=QRYDB->A1_COD
			nREC   :=QRYDB->R_E_C_N_O_
			LGRAVA :=.T.
			exit
		EndIf
		QRYDB->(DBSKIP())
	ENDDO

	DbCloseArea()

	///////////////////////////////////////////////////////////////////
	// SE lGrava=.T. ajusta o SA1
	///////////////////////////////////////////////////////////////////
	IF lGrava
		BEGIN TRANSACTION   //QUALQUER ERRO, NAO FAZ NADA, DEIXANDO

			//Atualiza o Cliente
			DbSelectArea("SA1")
			DBSETORDER(3) //CGC
			IF DBSEEK(XFILIAL("SA1")+cCGCCLI)
				IF RECLOCK("SA1",.F.)
					SA1->A1_COD   :=cCODANT
					SA1->A1_LOJA  :=SA1->(POSICIONE("SUS",4,XFILIAL("SUS")+cCGCCLI, "US_LOJA"))  ///BUSCAR PELO CGC
					SA1->A1_STATUS:=''
					MSUNLOCK()
				EndIf
			EndIf

			//Atualiza o Prospect
			///////////////Agora Ajusta o SUS o campo US_CLIENTE
			//DbSelectArea("SUS")
			//busca pro CGC
			DbSelectArea("SUS")
			DBSETORDER(4)
			IF DBSEEK(XFILIAL("SUS")+cCGCCLI)
				IF RECLOCK("SUS",.F.)
					SUS->US_CODCLI :=cCODANT
					SUS->US_LOJACLI:=SUS->US_LOJA
					MSUNLOCK()
				EndIf
			EndIf

			////////AGORA QUE AJUSTOU CLIENTE E PROSPECT, TEMOS DE AJUSTAR
			////////SC5,SC6,SC9 e SUA
			////////FAZER TESTE COM EDIVALDO PARA VERIFICAR SE
			////////SAO SOMENTE ESTES ARQUIVOS

			IF Alltrim(cNumSC5)<>'' ///SOMENTE SE HOUVER SC5
				/////Vou buscar o pedido, pegando o RECNO e Numero do SUA
				/////
				cQUERY:=''
				cQUERY+="SELECT SC5.R_E_C_N_O_ AS nRec, SC5.C5_NUMSUA AS cNSUA FROM "+RetSqlName('SC5')+" SC5 "
				cQUERY+="WHERE SC5.C5_NUM='"+cNumSC5+"' AND SC5.C5_FILIAL='"+cNumFIL+"' "

				//cQUERY := ChangeQuery( cQUERY )

				If( Select("QRY_001") <> 0 ) // Se a area a ser utilizada estiver em uso, fecho a mesma
					QRY_001->( dbCloseArea() )
				EndIf

				//MEMOWRIT( "C:\SQLSIGA\QRY001.SQL", cQUERY )

				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQUERY),"QRY_001",.F.,.T.)
				_nREC:=QRY_001->nREC
				_cNSUA:=QRY_001->cNSUA

				DbSelectArea("QRY_001")
				dBCloseArea()
				/////AGORA COMECA OS UPDATES NAS TABELAS
				/////COMECA PELO SC5

				//ALERT("VAI ALTERAR O SC5 N. "+cNumSC5+" Cli: "+cCODANT)
				cSql :=" UPDATE "+RetSqlName('SC5')
				cSql +=" SET "
				cSql +=" C5_CLIENTE = '"+cCODANT+"', "
				cSql +=" C5_LOJACLI = '"+SUS->US_LOJA+"', "
				cSql +=" C5_CLIENT  = '"+cCODANT+"'
				cSql +=" WHERE "
				cSql +=" R_E_C_N_O_= "+STR(_nRec)

				NRET:=	TCSQLExec( cSql )

				If nRet == 0
					//MsgAlert("Inseriu","Alerta")
				Else
					cRet = TCSQLERROR()
					MsgAlert(cRet,"Alerta")
				EndIf

				TCSQLExec('COMMIT')

				//////AGORA VAI PARA O SC6

				//ALERT("VAI ALTERA O SC6 N."+cNUMSC5+" CLI: "+cCODANT)
				cSql1 :=" UPDATE "+RetSqlName('SC6')
				cSql1 +=" SET "
				cSql1 +=" C6_CLI       = '"+cCODANT+"', "
				cSql1 +=" C6_LOJA       = '"+SUS->US_LOJA+"' "
				cSql1 +=" WHERE "
				cSql1 +=" C6_NUM        = '"+cNumSC5+"'
				cSql1 +=" AND C6_FILIAL = '"+cNumFIL+"' "

				NRET:=TCSQLExec( cSql1 )

				If nRet == 0
					//TCRefresh("ZAA990")
					//MsgAlert("Inseriu","Alerta")
				Else
					cRet = TCSQLERROR()
					MsgAlert(cRet,"Alerta")
				EndIf
				TCSQLExec('COMMIT')

				//////TROCA NO SC9 SE HOUVER

				//ALERT("VAI ALTERAR O SC9..SE HOUVER..")
				cSql2 :=" UPDATE "+RetSqlName('SC9')
				cSql2 +=" SET "
				cSql2 +=" C9_CLIENTE   = '"+cCODANT+"', "
				cSql2 +=" C9_LOJA      = '"+SUS->US_LOJA+"' "
				cSql2 +=" WHERE "
				cSql2 +=" C9_PEDIDO    = '"+cNumSC5+"'
				cSql2 +=" AND C9_FILIAL= '"+cNumFIL+"' "

				NRET:=TCSQLExec( cSql2 )

				If nRet == 0
					//MsgAlert("Inseriu","Alerta")
				Else
					cRet = TCSQLERROR()
					MsgAlert(cRet,"Alerta")
				EndIf

				TCSQLExec('COMMIT')

				//////E POR ULTIMO SUA
				fUpdateHistSua(cCODANT,SUS->US_LOJA)
			EndIf

		END TRANSACTION

	Else
		//Atualiza o Histórico dos Orçamentos SUA
		fUpdateHistSua(cCodCli,cLojCli)
	EndIf

	/////////////////////////////////////////////////////////////////////////////
	RestArea(_aArea)

	Return

*******************************************************************************
Static Function fUpdateHistSua(cNewCli,cLojaPro)// Atualiza o Histórico dos Orçamentos do Prospect para o Cliente ao qual foi Convertido
*******************************************************************************
	Local cQuery

	DbSelectArea("SUS")
	DbSetOrder(4)

	If DbSeek(XFILIAL("SUS")+cCGCCLI)
		
		cCodPreCli := SUS->US_COD  //Código de Prospect que será convertido o Historico do Orçamento  para o novo Código
		cLojPreCli := SUS->US_LOJA	//Loja   de Prospect que será convertido o Historico do Orçamento  para o novo Código

		cQuery :=" UPDATE "+RetSqlName('SUA')
		cQuery +=" SET "
		cQuery +=" UA_CLIENTE   = '"+cNewCli+"', "
		cQuery +=" UA_LOJA      = '"+SUS->US_LOJA+"' "
		cQuery +=" WHERE "
		cQuery +=" UA_FILIAL= '"+cNumFIL+"' "
		cQuery +=" AND (UA_CLIENTE= '"+cCodPreCli+"' AND UA_LOJA = '"+cLojPreCli+"' "
		cQuery +=" OR   UA_CLIENTE= '"+cCodAuto  +"' AND UA_LOJA = '"+cLojAuto+  "')"

		nRet:=TCSQLExec( cQuery )

		If nRet <> 0
			cRet = TCSQLERROR()
			MsgAlert(cRet,"Alerta")
		EndIf

		TCSQLExec('COMMIT')

	EndIf

	Return

*******************************************************************************
Static Function CLI_Atualiza()//³ Atualiza Cliente no Consultado (ZA0) Caso Tenha Sido alterado...
*******************************************************************************
	Local cSql 			:= ""
	Local cUA_CLIENTE	:= SUA->UA_CLIENTE
	Local cUA_LOJA		:= SUA->UA_LOJA
	Local cUA_NUM			:= SUA->UA_NUM
	Local cUA_FILIAL		:= xFilial("SUA")

	cSql  	+=	"Update ZA0010 "							;
	+	"Set "											;
	+	"ZA0_CLIENT = '"+cUA_CLIENTE		+"', "	;
	+	"ZA0_LOJACL = '"+cUA_LOJA			+"' "	;
	+ 	"Where ZA0_FILIAL = '"+cUA_FILIAL	+"' "	;
	+	"AND   ZA0_NUMORC = '"+cUA_NUM		+"' "

	U_ExecMySql(cSql, "", "E", .F.)

	Return()
*******************************************************************************
Static Function LogRegNeg()
*******************************************************************************
	Local _aArea  	 := GetArea()
	Local aNotDelZRD := {}
	Local nPItem 	 := Ascan(aHeader, {|x| Alltrim(x[2])=='UB_ITEM'})
	Local nX		 :=	0
	//				   1           2            3            4           5                          6                           7            8		   9  10
	//			    NUM.ATEND   COD.REGRA   (NEG\COM\DESC) CAMPO BLQ    ITEM ATEND             DESCONTO VENDEDOR              PRODUTO     DESC.RNEG   PV ITEMPV
	//Aadd(aATxRN, {M->UA_NUM, aBlq[nX][1], cDescAba,   aBlq[nX][4], aBlq[nX][5], GdFieldGet('UB_DESCVEN', Val(aBlq[nX][5])), aBlq[nX][6], aBlq[nX][7], '',''})

	/*
	Aadd(aRegDesc, {'Desc.Cliente', '', '', M->UA_DESC1 })
	Aadd(aRegDesc, {'Desc.RD - Cabec', '', cCodRegra, M->UA_DESC4 })
	Aadd(aRegDesc, {'Desc.Geral', '', '', M->UA_DESCG })
	Aadd(aRegDesc, {'ITEM RD',  n, cCodRegra, nDesconto })
	Aadd(aRegDesc, {'Fiscal', GdFieldGet('UB_ITEM', n), '', nDesconto })
	Aadd(aRegDesc, {'Fiscal', GdFieldGet('UB_ITEM', n), 'Comp.ST', nDesconto })
	Aadd(aRegDesc, {'Fiscal', GdFieldGet('UB_ITEM', n), 'ICMS', nPerDesc })
	'Fator'
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  			ATENDIMENTO   X   REGRA DE NEGOCIO  		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aATxRN) > 0

		For nX:=1 To Len(aATxRN)

			DbSelectArea('ZRN');DbSetOrder(1)	//	ZRN_FILIAL + ZRN_NUMAT + ZRN_ITEMAT  + ZRN_CODRN
			lGrava := !DbSeek(xFilial('ZRN')+ SUA->UA_NUM + aATxRN[nX][05] + aATxRN[nX][02], .F.)

			DbSelectArea('ZRN')
			Reclock('ZRN',lGrava)
			ZRN->ZRN_FILIAL	:=	xFilial('ZRN')
			ZRN->ZRN_NUMAT	:=	SUA->UA_NUM
			ZRN->ZRN_ITEMAT	:=	aATxRN[nX][05]
			ZRN->ZRN_PRODUT	:=	aATxRN[nX][07]
			ZRN->ZRN_VENDA	:=	Round(aATxRN[nX][06], TamSx3('ZRN_VENDA')[02])
			ZRN->ZRN_CODRN	:=	aATxRN[nX][02]
			ZRN->ZRN_REGRA	:=	Round(aATxRN[nX][08], TamSx3('ZRN_REGRA')[02])
			ZRN->ZRN_TPBLQ 	:=	aATxRN[nX][03]
			ZRN->ZRN_CPOBLQ	:=	aATxRN[nX][04]
			ZRN->ZRN_PEDIDO	:=	aATxRN[nX][09]
			ZRN->ZRN_ITEMPV	:=	aATxRN[nX][10]
			MsUnlock()

		Next

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  EXCLUI ITENS QUE NAO ESTAO BLOQUEADOS PELA REGRA DE NEGOCIO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aRetZRN) > 0

		For nX:=1 To Len(aRetZRN)

			// Aadd(aRetZRN, {Alltrim(SUB->UB_NUM), Alltrim(SUB->UB_ITEM) })
			cNumAt  := 	aRetZRN[nX][01]
			cItemAt := 	aRetZRN[nX][02]

			//	CASO NUM.ATENDIMENTO NAO EXISTA NA TABELA NAO HA NECESSIDADE DE VERIFICAR OS ITENS
			DbSelectArea('ZRN');DbSetOrder(1)	//	ZRN_FILIAL + ZRN_NUMAT + ZRN_ITEMAT  + ZRN_CODRN
			If !DbSeek(xFilial('ZRN')+ cNumAt, .F.)
				Exit
			EndIf

			DbSelectArea('ZRN');DbSetOrder(1)
			If DbSeek(xFilial('ZRN')+ cNumAt + cItemAt, .F.)
				Do While !Eof() .And. ZRN->ZRN_NUMAT == cNumAt .And. ZRN->ZRN_ITEMAT == cItemAt

					If SubStr(ZRN->ZRN_CODRN,1,3) <> 'BLM'
						Reclock('ZRN',.F.)
						DbDelete()
						MsUnlock()
					EndIf

					DbSkip()
				EndDo
			EndIf

		Next

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  			ATENDIMENTO   X   REGRA DE DESCONTO			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aRegDesc) > 0

		IIF(Len(aRegDesc) > 0, aSort(aRegDesc,,,{|X,Y| X[2] < Y[2]}), )
		For nX:=1 To Len(aRegDesc)

			// VERIFICAR SE LINHA DO ACOLS FOI DELETADA E RETIRAR DA ZRD
			// VERIFICAR ZRD X aCOLS DELETADOS

			// VERIFICAR SE DESCONTO FOI DADO, AT GRAVADO + F10 E RETIRADO DESCONTO
			// VERIFICAR ZRD X aRegDesc

			// VERIFICA SE LINHA DO ACOLS ESTA DELETADA... SE DELETADA NA GRAVAR NO ZRD
			cItemAT		:=	PadL(aRegDesc[nX][02], TamSx3('UB_ITEM')[1], '0')

			nLinAT		:=	Ascan(aCols, {|X| X[nPItem] == cItemAT  })
			lLinhaDel 	:=	IIF(nLinAT > 0, IIF(GdDeleted(nLinAT), .T., .F.), .T.)

			// NAO GRAVO DESCONTO GERAL PQ JA INCLUSO ESSE DESCONTO NO ITEM.
			If Upper(aRegDesc[nX][01]) $ 'DESC.GERAL' .Or. lLinhaDel
				Loop
			EndIf

			cCodRD	:=	IIF(Empty(aRegDesc[nX][03]), Space(TamSx3('ZRD_CODRD')[1]),  PadR(aRegDesc[nX][03], TamSx3('ZRD_CODRD')[1] , ''))
			cCodRD	:=	IIF(cCodRD=='Comp.ST','CompST', cCodRD)
			cItemRD	:=	IIF(Empty(aRegDesc[nX][05]), Space(TamSx3('ZRD_ITEMRD')[1]), PadR(aRegDesc[nX][05], TamSx3('ZRD_ITEMRD')[1], ''))
			cTpBloq	:=	PadR(aRegDesc[nX][01], TamSx3('ZRD_TPBLQ')[1] , '')

			IIF(Select('TMPZRD')!=0, TMPZRD->(DbCloseArea()), )
			cSql := " SELECT ZRD.R_E_C_N_O_ ZRD_RECNO, ZRD.* 		   			"+ENTER
			cSql += " FROM 	"+RetSqlName("ZRD")+" ZRD 				   			"+ENTER
			cSql += " WHERE ZRD.ZRD_FILIAL 		 =  '"+xFilial('ZRD')+"'	   	"+ENTER
			cSql += " AND	ZRD.ZRD_NUMAT		 =  '"+Alltrim(SUA->UA_NUM)+"'	"+ENTER
			cSql += " AND 	ZRD.ZRD_ITEMAT		 =  '"+Alltrim(cItemAT)+"'		"+ENTER
			cSql += " AND 	UPPER(ZRD.ZRD_TPBLQ) =  '"+Upper(cTpBloq)+"'		"+ENTER
			cSql += " AND 	ZRD.ZRD_CODRD		 = 	'"+Upper(cCodRD)+"'			"+ENTER
			cSql += " AND 	ZRD.ZRD_ITEMRD   	 =  '"+cItemRD+"'				"+ENTER
			cSql += " AND 	ZRD.D_E_L_E_T_ != '*'								"+ENTER

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'TMPZRD',.T.,.T.)
			DbSelectArea('TMPZRD');DbGoTop()
			lGrava 		:= 	IIF(Empty(TMPZRD->ZRD_TPBLQ), .T., .F.)
			nZRDRecno 	:=	TMPZRD->ZRD_RECNO
			IIF(Select('TMPZRD')!=0, TMPZRD->(DbCloseArea()), )

			IIF(!lGrava, ZRD->(DbGoTo(nZRDRecno)), )

			DbSelectArea('ZRD')
			RecLock('ZRD',lGrava)
			ZRD->ZRD_FILIAL	:=	xFilial('ZRD')
			ZRD->ZRD_NUMAT	:=	SUA->UA_NUM
			ZRD->ZRD_ITEMAT	:=	cItemAT
			ZRD->ZRD_CODRD	:=	StrTran(aRegDesc[nX][03], '.','')
			ZRD->ZRD_TPBLQ 	:=	Alltrim(aRegDesc[nX][01])
			ZRD->ZRD_DESCRD	:=	IIF(Alltrim(Upper(cTpBloq))=='DESC.VEND', 0, Round(aRegDesc[nX][04], TamSx3('ZRD_DESCRD')[02]))
			ZRD->ZRD_ITEMRD :=	cItemRD

			//							1						2						3				4				5             6         7=FLAG
			//	Aadd(aComplRD, {Alltrim(SUB->UB_ITEM), Alltrim(SUB->UB_PRODUTO), SUB->UB_DESCVEN, SUB->UB_NUMPV, SUB->UB_ITEMPV, SUB->UB_DESCRD, ''  })
			nPos := Ascan(aComplRD, {|X| Alltrim(X[01]) == Alltrim(cItemAT) .And. Empty(X[07]) })
			If nPos > 0
				ZRD->ZRD_PRODUT	:=	aComplRD[nPos][02]
				ZRD->ZRD_DESCVE	:=	IIF(Alltrim(Upper(cTpBloq))=='DESC.VEND', aComplRD[nPos][03], 0)

				ZRD->ZRD_PEDIDO	:=	aComplRD[nPos][04]
				ZRD->ZRD_ITEMPV	:=	aComplRD[nPos][05]
			EndIf
			MsUnLock()

			// aNotDelZRD UTILIZADO PARA DELETAR DO ZRD OS ITENS Q ESTAO ESTAO MAIS NO aRegDesc
			// VERIFICA SE O REGISTRO ZRD ESTA NO aNotDelZRD E NAO DELETA O ITEM.
			Aadd(aNotDelZRD, ZRD->(Recno()) )

		Next

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  EXCLUI DESCONTO(s) QUE ESTAO NA ZRD E FORAM RETIRADOS 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('ZRD');DbSetOrder(1)					//	[ 1-ITEM  ]	ZRD_FILIAL + ZRD_NUMAT + ZRD_ITEMAT  + ZRD_CODRD + ZRD_ITEMRD
	If DbSeek(xFilial('ZRD') + SUA->UA_NUM, .T.)		//	[ 2-CABEC ]	ZRD_FILIAL + ZRD_NUMAT + ZRD_ITEMAT  + ZRD_TPBLQ + ZRD_CODRD
		Do While ZRD->ZRD_NUMAT == SUA->UA_NUM

			lDeleta := IIF(Len(aNotDelZRD)==0, .T., IIF(Ascan(aNotDelZRD, ZRD->(Recno())) > 0, .F., .T.) )

			If lDeleta
				Reclock('ZRD',.F.)
				DbDelete()
				MsUnlock()
			EndIf

			DbSelectArea('ZRD')
			DbSkip()
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  EXCLUI DESCONTO(s) QUE FORAM DELETADOS DO aCOLS  [ZRN\ZRD] ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nIniDel := Ascan(aCols, {|X| X[Len(aHeader)+1]})
	If nIniDel > 0
		For nX:=nIniDel To Len(aCols)
			If GdDeleted(nX)

				DbSelectArea('ZRD');DbSetOrder(1)					//	[ 1-ITEM  ]	ZRD_FILIAL + ZRD_NUMAT + ZRD_ITEMAT  + ZRD_CODRD + ZRD_ITEMRD
				If DbSeek(xFilial('ZRD') + SUA->UA_NUM + GdFieldGet('UB_ITEM', nX), .T.)		//	[ 2-CABEC ]	ZRD_FILIAL + ZRD_NUMAT + ZRD_ITEMAT  + ZRD_TPBLQ + ZRD_CODRD
					Do While ZRD->ZRD_NUMAT == SUA->UA_NUM .And. ZRD->ZRD_ITEMAT == GdFieldGet('UB_ITEM', nX)

						Reclock('ZRD',.F.)
						DbDelete()
						MsUnlock()

						DbSelectArea('ZRD')
						DbSkip()
					EndDo
				EndIf

				DbSelectArea('ZRN');DbSetOrder(1)	//	ZRN_FILIAL + ZRN_NUMAT + ZRD_ITEMAT + ZRN_CODRN
				If DbSeek(xFilial('ZRN') + SUA->UA_NUM + GdFieldGet('UB_ITEM', nX), .T.)
					Do While ZRN->ZRN_NUMAT == SUA->UA_NUM .And. ZRN->ZRN_ITEMAT == GdFieldGet('UB_ITEM', nX)

						Reclock('ZRN',.F.)
						DbDelete()
						MsUnlock()

						DbSelectArea('ZRN')
						DbSkip()
					EndDo
				EndIf

			EndIf
		Next
	EndIf

	RestArea(_aArea)
	Return()
*******************************************************************************
Static Function ChkSC6Lib(cFilPV, cNumPV)
*******************************************************************************
	Local lRetorno := .F.

	IIF(Select('TMPPV')!=0, TMPM->(DbCloseArea()), )
	cQuery := "	SELECT 	C6_BLOQUEI, C6_NUM, C6_ITEM				   					"+ENTER
	cQuery += " FROM 	"+RetSqlName("SC6")+" SC6   			   					"+ENTER
	cQuery += " WHERE 	SC6.C6_FILIAL 	 =  '"+cFilPV+"' 							"+ENTER
	cQuery += " AND 	SC6.C6_NUM	 	 =  '"+cNumPV+"'							"+ENTER
	cQuery += " AND 	SC6.C6_BLOQUEI	!=  '"+Space(TamSx3('C6_BLOQUEI')[01])+"'	"+ENTER
	cQuery += " AND 	SC6.D_E_L_E_T_ 	!=  '*' 									"+ENTER

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPPV', .F., .T.)

	DbSelectArea('TMPPV');DbGoTop()
	lRetorno :=	IIF(Empty(TMPPV->C6_BLOQUEI), .T., .F.)

	IIF(Select('TMPPV')!=0, TMPPV->(DbCloseArea()), )
	Return(lRetorno)
	
/*******************************************************************************
Static Function ChkBlqLibSC9(cNumPV)
*******************************************************************************
	Local aAreaAnt := 	GetArea()
	Local lRetorno	:=	.F.

	IIF(Select('TMPSC9')!=0, TMPMSC9->(DbCloseArea()), )
	cQuery := " SELECT	C9_FILIAL, C9_PEDIDO, C9_PRODUTO, C9_LOCAL, C9_BLEST, C9_BLCRED, C9_BLWMS, C9_RESERVA, C9_QTDRESE, C9_SEQUEN "+ENTER
	cQuery += " FROM 	"+RetSqlName("SC9")+" SC9   			   	"+ENTER
	cQuery += " WHERE 	SC9.C9_FILIAL 	=  '"+xFilial('SC9')+"' 	"+ENTER
	cQuery += " AND 	SC9.C9_PEDIDO 	=  '"+cNumPV+"'				"+ENTER
	cQuery += " AND 	SC9.C9_ITEM 	=  '"+cItemPV+"'			"+ENTER
	cQuery += " AND 	SC9.C9_PRODUTO 	=  '"+cProdPV+"'			"+ENTER
	cQuery += " AND 	SC9.D_E_L_E_T_ 	!=  '*' 					"+ENTER

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPSC9', .F., .T.)

	DbSelectArea('TMPSC9');DbGoTop()
	lRetorno :=	IIF(Empty(TMPSC9->C9_BLEST).And.Empty(TMPSC9->C9_BLCRED), .T., .F.)

	IIF(Select('TMPSC9')!=0, TMPSC9->(DbCloseArea()), )
	RestArea(aAreaAnt)
	Return(lRetorno)
*/
*******************************************************************************
Static Function ExecMaLibDoFat()
*******************************************************************************
	Local xaArea := GetArea()

	Local lCredito	:=	.F.
	Local lEstoque	:=	.F.
	Local lAvalCre 	:= 	.T.
	Local lAvalEst 	:= 	.T.
	Local lLibParc	:=	.F.
	Local lTrfLocal	:=	.F.
	Local cDocRes	:=	PadR(Alltrim(SC6->C6_NUM+SC6->C6_ITEM), TamSx3('C0_DOCRES')[01])
	Local lCorreia 	:=	!Empty(A093VldBase(SC6->C6_PRODUTO))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³   VERIFICA SE EXISTE SC9 E REALIZA O ESTORNO	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ExecBlock('SC9Estorna', .F., .F., {SC6->C6_NUM, SC6->C6_ITEM}) //SC9Estorna(SUA->UA_NUMSC5)

	If lCorreia
		If ExecBlock('ChkResxSld', .F., .F., {cFilAnt, cDocRes, SC6->C6_PRODUTO})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//|	NAO VERIFICAR ESTOQUE QUANDO CORREIA TEM RESERVA				|
			//| OCORRENCIA DE BLOQUEIO DE ESTOQUE QDO ATENDIMENTO TEM RESERVA	|
			//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
			//| EX.:															|
			//| AO GRAVAR AT COM PRODUTO CORREIA, COM SALDO, Eh GRAVADO RESERVAS|
			//| Eh RESERVADO PARA QUE OUTRO VENDEDOR NAO "ROUBE" O SALDO		|
			//| AO BUSCAR AT VIA F10 E CONFIRMA O SISTEMA IRA BLOQUEAR O ITEM	|
			//| CORREIA PQ O SISTEMA IDENTIFICA INDEVIDAMENTE QUE NAO TEM SALDO	|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lEstoque	:=	.T.
			lAvalEst 	:= 	.F.
		EndIf
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Parametros³ExpN1: Registro do SC6                                      ³
	³          ³ExpN2: Quantidade a Liberar                                 ³
	³          ³ExpL3: Bloqueio de Credito                                  ³
	³          ³ExpL4: Bloqueio de Estoque                                  ³
	³          ³ExpL5: Avaliacao de Credito                                 ³
	³          ³ExpL6: Avaliacao de Estoque                                 ³
	³          ³ExpL7: Permite Liberacao Parcial                            ³
	³          ³ExpL8: Transfere Locais automaticamente                     ³
	³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³
	³          ³       apenas avalia ).                                     ³
	³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³
	³          ³ExpAB: Array com Empenhos previamente escolhidos            ³
	³          ³       (impede selecao dos empenhos pelas rotinas)          ³
	³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³
	³          ³ExpND: Valor a ser adicionado ao limite de credito          ³
	³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³
	ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/

	//				[01]			[02]		[03]      [04]    [05]     [06]    [07]    [08][09][10][11][12][13][14]
	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,lCredito,lEstoque,lAvalCre,lAvalEst,lLibParc,lTrfLocal,Nil,Nil,Nil,Nil,Nil,0)

	RestArea(xaArea)
	Return()
*******************************************************************************
Static Function SC9ExistReg(cNumPV)
*******************************************************************************
	Local xaArea := GetArea()
	Local lRetorno	:=	.F.

	IIF(Select('TMPSC9')!=0, TMPMSC9->(DbCloseArea()), )
	cQuery := " SELECT	C9_FILIAL, C9_PEDIDO, C9_PRODUTO, C9_LOCAL, C9_BLEST, C9_BLCRED, C9_BLWMS, C9_RESERVA, C9_QTDRESE, C9_SEQUEN "+ENTER
	cQuery += " FROM 	"+RetSqlName("SC9")+" SC9   			   	"+ENTER
	cQuery += " WHERE 	SC9.C9_FILIAL 	=  '"+xFilial('SC9')+"' 	"+ENTER
	cQuery += " AND 	SC9.C9_PEDIDO 	=  '"+cNumPV+"'				"+ENTER
	cQuery += " AND 	SC9.D_E_L_E_T_ 	!=  '*' 					"+ENTER

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPSC9', .F., .T.)

	DbSelectArea('TMPSC9');DbGoTop()
	lRetorno :=	IIF(Empty(TMPSC9->C9_PEDIDO), .F., .T.)

	IIF(Select('TMPSC9')!=0, TMPSC9->(DbCloseArea()), )
	RestArea(xaArea)
Return(lRetorno)

//Funcao para enviar numero do pedido de venda para o SimFrete nPesoB he a soma do b1_peso via sub
// nQtdNf he a soma ub_quant via sub Sera usada no PE_TMKVFIM no momento de alimentar SC5
nQuant += SUB->UB_QUANT"
nPesoB += POSICIONE("SB1",1,xFilial("SB1")+UB_PRODUTO,"B1_PESO") * UB_QUANT
*******************************************************************************
static Function ImdFPedSim(nPesoB,nQuant)
*******************************************************************************
	Local   cOrigem       := SM0->M0_CEPENT
	Local	cDestino      := SA1->A1_CEP
	Local 	cModal        := ""
	Local 	cCiffob       := SC5->C5_TPFRETE //"C"
	Local	cRemCNPJ      := SM0->M0_CGC
	Local	cRemNome      := ""
	Local 	cDesCNPJ      := SA1->A1_CGC
	Local	cDesNome      := ""
	Local	nTotalNF      := Alltrim(Transform(_NVLRNFF, "@E 999,999,999.99" ))
	Local	cPesoNF       := Alltrim(Transform(nPesoB, "@E 999999999.9999" ))
	Local	cVolNF        := cValToChar(SC5->C5_VOLUME1)
	Local	cQtdNF        := cValToChar(nQuant)
	Local	cClsProd      := ""
	Local   CATEND        := SC5->C5_NUM
	Local   cTipOper      :=""
	Local   aRetorno      :={}
	Local   lOk           :=.F.

	/////JULIO JACOVENKO, em 13/11/2017
	/////

	IF Alltrim(SA1->A1_VINCULO)$("#CM*CM*#PP*PP") .OR. (UPPER(SA1->A1_CLIFRTE) $ '1#X')  //CLIENTE CONTRATO OU ESPECIAL
		cTipOper      := "0"  //OUTBOUND (devolucao, entrega, etc)
	Else
		cTipOper      := "4"  //4 É COTACAO (pedido de venda menos ecommerce)      //"0"  OUTBOUND (devolucao, entrega, etc)    // aPedido[14] // * "0" // TEMPORARIO
	EndIf

	aPedido := { cOrigem,cDestino,cModal,cCiffob,cRemCNPJ,cRemNome,cDesCNPJ,cDesNome,nTotalNF,cPesoNF,cVolNF,cQtdNF,cClsProd,cTipOper,CATEND}

	aRetorno := U_IMDH010(aPedido)

	If Len(aRetorno) > 0
		lOk := .T.
	Else
		lOk := .F.
	EndIf

	Return lOk

	************************************************************
User Function TmkMailPed(cNumPed,cCodFil,dEmissao,aProds)
	************************************************************

	Local cServer 	:= SX6->(U_GetSx6("MV_RElseRV"	,""	,"mail.imdepa.com.br"		))
	Local cAccount 	:= SX6->(U_GetSx6("MV_RELACNT"	,""	,"protheus@imdepa.com.br"	))
	Local cPassword := SX6->(U_GetSx6("MV_RELPSW"	,""	,"mp8"						))
	Local lResult  	:= .T.


	//Local aMov       :={}
	Local cHtml      :=' '
	Local cMailSend  :=' ' //Lista de endereco de e-mails a serem enviados
	Local cEmailBcc  :=' ' //Lista de endereco de e-mails com copia Oculta
	Local cSubJect   :=' '
	Local cMailto  	:= GetMv('MV_DIVPRCV')  //'edivaldo@imdepa.com.br'

	#DEFINE nPos_Itprod   	1
	#DEFINE nPos_Prod     	2
	#DEFINE nPos_Prec    	3
	#DEFINE nPos_NewPrec    4

	cSubJect:='PEDIDO DE VENDA Nº '+cNumPed+' COM DIVERGÊNCIA '

	cHtml := '<html>'
	cHtml += '<head>'

	cHtml+='<title>PEDIDO DE VENDA  </title>'
	cHtml+='</head>'

	cHtml+='<body>'

	cHtml+='<table width="700" border="0" align="center" bgcolor="#FFFFFF">'
	cHtml+='<tr> <td><table width="680" border="0" align="center" cellpadding="0" cellspacing="0"> <tr bgcolor="#336699">'

	cHtml+='<tr bgcolor="#FFFFFF">        <td>&nbsp;</td>      </tr>'

	cHtml+='<table width="680" cellspacing="1" cellpadding="3" border="0" bgcolor="#FFFFCC">'
	cHtml+='<tr>'
	cHtml+='<td bgcolor="#FFFFCC">'
	cHtml+='<font face="verdana, arial, helvetica" size=2>'

	cHtml+='O Pedido abaixo possui itens que apresentaram divergência de Preço !'

	cHtml+='</font>'
	cHtml+='</td>'
	cHtml+='</tr>'
	cHtml+='</table>'

	cHtml+='<table width="680" border="0" align="left" cellpadding="0" cellspacing="0">'
	cHtml+='<tr> <td><table width="680" border="0" align="left" cellpadding="0" cellspacing="2" bordercolor="#FFFFFF" bgcolor="#FFFFFF">'

	cHtml+='<tr> <td colspan="6" bgcolor="#8DB6CD" class="formularioTit" align="center">PEDIDO N. '+cNumPed+'</td> </tr>'

	cHtml+='<tr> <td width="110">&nbsp;</td> </tr>'
	cHtml+='<tr> <td colspan="6" bgcolor="#8DB6CD" class="formularioTit" align="center">DADOS DO PEDIDO</td> </tr>'

	cHtml+='<tr> <td bgcolor="#ECF0EE" class="formulario">Filial:</td>'
	cHtml+='<td width="123" bgcolor="#F7F9F8" class="formulario2">'+cCodFil+' '+Alltrim(SM0->M0_FILIAL)+'</td>'

	cHtml+='<td width="119" bgcolor="#ECF0EE" class="formulario">Data do Pedido: </td>'
	cHtml+='<td width="121" bgcolor="#F7F9F8" class="formulario2">'+Dtoc(dEmissao)+'</td>'
	cHtml+='</tr>'

	cHtml+='</tr>'
	cHtml+='<tr> <td>&nbsp;</td> </tr> <tr bgcolor="#FCFCFC">'

	cHtml+='<td colspan="6" bgcolor="#8DB6CD" class="formularioTit" align="center">ITENS DO PEDIDO</td> </tr>'

	cHtml+='</tr> </table></td> </tr>'
	cHtml+='<tr> <td>&nbsp;</td> </tr>'

	cHtml+='<style type="text/css">'
	cHtml+='table.bordasimples {border-collapse: collapse;} '
	cHtml+='table.bordasimples tr td {border:1px solid #ccc; padding-left: 5px;} '
	cHtml+='</style>'
	cHtml+='<table style="width: 550px;" class="bordasimples"  '
	cHtml+='border="1" bordercolor="#cccccc"> <tbody><tr><td  '
	cHtml+='style="background-color: rgb(238, 238, 238); font-weight: bold;">Item</td> '
	cHtml+='<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Produto</td> '
	cHtml+='<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Preço</td> '
	cHtml+='<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Novo Preço</td> '

	cHtml+='</tr><tr>

	For i=1 to Len(aProds)
		cHtml+='<tr>'
		cHtml+='<td>'+aProds[i,nPos_Itprod]+'</td> '
		cHtml+='<td>'+aProds[i,nPos_Prod]+'</td> '
		cHtml+='<td>'+Str(aProds[i,nPos_Prec])+'</td> '
		cHtml+='<td>'+Str(aProds[i,nPos_NewPrec])+'</td> '
	Next i

	cHtml+='</tr></tbody></table>'

	cHtml+='</body>'
	cHtml+='</html>'

	cMailSend:=cMailto

	CONNECT SMTP SERVER Alltrim(cServer) ACCOUNT Alltrim(cAccount) PASSWORD Alltrim(cPassword) RESULT lResult

	SEND MAIL FROM cAccount  ;
	TO             cMailSend ;
	BCC     	   cEmailBcc ;
	SUBJECT        cSubJect  ;
	BODY           cHtml

	DISCONNECT SMTP SERVER

Return( )