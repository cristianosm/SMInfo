#INCLUDE 'VKEY.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'INKEY.CH'

//ajustado 04/09/2014
//testes com mauricio


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘
北砅rograma  ?TmkActive   ?Autor 矱xpedito Mendonca Jr?Data ?30/04/03 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢
北矰escri噭o ?Inicializa variaveis na entrada da tela de atendimento do  潮?
北?         ?Call Center                                                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ?U_TmkActive()                                              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?NIL                                                        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砇etorno   ?NIL                                                        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?Call Center                                                潮?
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢
北?ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     潮?
北媚哪哪哪哪哪哪穆哪哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?PROGRAMADOR  ?DATA   ?DESCRICAO                                     潮?
北媚哪哪哪哪哪哪呐哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?             ?       ?                                              潮?
北滥哪哪哪哪哪哪牧哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
/*/
User Function TmkActive()

	Public __PrimComp   := "N"	// Primeira compra do cliente
	Public __Podesair   := "S"	// Libera a saida da tela
	Public __lJaBotCPag := .F.  // Ja clicou no botao de condicao de pagamento neste atendimento?
	Public __lTranspPossuiRota 	:= .F.  // Transportadora possui rota
	Public __RodouRotas			:= .F.
	Public __ClienteAtual		:= SPACE(TamSx3("UA_CLIENTE")[1] + TamSx3("UA_LOJA")[1])
	Public __aItDigQtd  := {}   // Array com flag indicando itens em que o usuario ja digitou a quantidade
	Public __aItDigPrd  := {}   // Array contendo a linha e o produto digitado, para avaliar se houve modifica玢o no produto digitado
	Public __COPIATT	:= .F.  // Flag que indica que o atendimento atual da tela ?uma c髉ia
	Public __nLibDel	:= 0	// Ate qual linha o sistema permite a delecao de itens do aCols
	Public __cTabAtu	:= ""	// Tabela de precos atual, utilizada para definir se ao passar pela validacao do campo UA_TABELA,
	                            // deve-se ou nao atualizar os precos dos itens do atendimento
	Public __aProdCamp  := {}	// Array com a amarracao produtoxcampanha para posterior gravacao da tabela ZZI
	Public __cMensagem
	Public aPrecosCamp :={}    // Array com pre鏾s de campanha
	Public lFocusTlv := .F.
	Public __ClienteAtual		:= SPACE(TamSx3("UA_CLIENTE")[1] + TamSx3("UA_LOJA")[1])
	Public bSigaGotFocus
	Public bDel
	Public aAbaulSimi           :={} //Array com produtos Abaulados/Similares para posterior envio do e-mail ao cliente
	Public nFreteTabFix         := 0     
	Public _lAltOrc             :=.F.
	Public _ljaCPaCP						:= .F. //| Solicita o Click na Condi?o de Pagamento antes de emitir o Orcamento...
	
	Public aLogItens            :={} 
	Public nQtdLogDig           := SuperGetMV("MV_IMDF190"  , .F., 0)  //Gera um Log na Digita玢o das Quantidades para fins de Analise  
	Public nTimeBotao           :=0   
	Public lJaRegCons           := .T. //Define se j?foi registrado a consulta     
	
	Public _ljaCPIMC            := .F.   //Solicita o Click na Condicao de Pagamento quando F4
	
	//Public __CopaHeader					:= {} //:=  @aHeader     // Array com flag indicando itens em que o usuario ja digitou a quantidade
	Public __aCCols  		   		:= {} // Array contendo a linha e o produto digitado, para avaliar se houve modifica?o no produto digitado
	    
    ////JULIO JACOVENKO, em 11/08/2014 
    ////Variaveis globais para tratamento do frete
    ////
    Public _NFRETE              := 0
    Public _NVALFRT             := 0
    Public _NVLMETA             := 0
    Public _NVALSUG             := 0
    Public _LPEGATRAN           := .F.    ///ainda nao passou pelo transporte
    
    Public _LPEGATIMC           := .F.    ///ainda nao passou pelo transporte quando F4
    Public _NACOL               := 1
    ///////////////////////////////////         
    Public __lJaBotPag2        := .F. //CLICOU NA CONDICAO DE PAGAMENTO 2
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪
	//? SOLUTIO - FABIANO PEREIRA  - 23/09/2014                          ?
	//? ARRAY CRIADO PARA GUARDAR OS VALORES DOS IMPOSTOS - POR ITEM     ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪
		Public aProdxImp  	:= {}	//	PRODUTO X IMPOSTOS
		Public aContDesc 	:= {}	//	ARRAY UTILIZADO NA REGRA DE DESCONTO
		Public aHistTV		:= {}	//	HISTORICO DE ATENDIMENTO
		Public aRegDesc		:= {}	//	REGRA DE DESCONTO
		Public aImdCodR 	:= {}	//	CODIGO DA REGRA DE NEGOCIO   
		Public aATxRN	 	:= {}	//	ATENDIMENTO X REGRA DE NEGOCIO
		Public _nCopyAt 	:= 0	//	CONTROLE COPIA DE ATENDIMENTO - RAFAEL L. SCHEIBLER
		Public lBtnPgtOk 	:= .F.	//	VERIFICA SE USER CLICOU NO BTN OK DA TELA DE COND.PGTO
	 
        Public nDestaca     
        Public LCLISPFRT    :=.F.
        Public NCARRO       :=0
        Public LCLIENTESP   :=.F.     
        Public lRunProspect :=.F.   //Define que a grava玢o de um pedido veio de um Prospect e posteriormente atualizar o hist髍ico do cliente no ajuste do C骴igo do cliente  
        Public lRuningF11   :=.F.   //Define que o F11 est?em execu玢o
                       
        /////JULIO JACOVENKO, em 01/12/2017
		Public _nVlrNfF:= 0
        Public cXBTransp
        
        /////JULIO JACOVENKO, em 29/01/2018
        //Public cFRTCIFA1:=""
        //Public cFRTCIFA2:=""
        //Public cFRTCIFB1:=""
        //Public cFRTCIFB2:=""
        
        Public cFrCIB:=""	   //| Frete CIF Imdepa Mais Barato
        Public cFrCIR:=""	   //| Frete CIF Imdepa mais R醦ido 

        Public cFCIBPE:=""    //| Frete CIF Imdepa mais Barato Prazo de Entrega
        Public cFCIRPE:=""   //| Frete CIF Imdepa mais R醦ido Prazo de Entrega
        Public lAtuPrcOnLine   :=.T. //Determina se C醠cula o Pre鏾 OnLine ou OffLine 
        
        Public aOfertas   :={}  //Armazena os Itens de Oferta
        Public aChaveOfert:={}  //Armazena os Registros Chave da Oferta Automatica
        Public lCorreia   :=.F.
        
		SetKey(K_ALT_F2,  {|| ExecBlock('TelaImpostos', .F., .F.) })
		
		//SetKey(K_ALT_P,  {|| ExecBlock('IMDA2300') })
			
		// SetKey(K_CTRL_F2, {|| ExecBlock('TelaImpostos', .F., .F., {'RD'}) })
		// SetKey(K_SH_F2,    {||ExecBlock('TelaImpostos', .F., .F.) })
		//SetKey(K_SH_F2,    {||ExecBlock('TelaImpostos', .F., .F.) })



	    
	
If TkGetTipoAte() != "3" //Se nao for TELECOBRANCA

	If Type("lTk271Auto") == "U" .Or. !lTk271Auto
		bSigaGotFocus 				:= oGetTlv:oBrowse:bGotFocus
		bDel						:= oGetTlv:oBrowse:bDelete
		//oGetTlv:oBrowse:bGotFocus  	:=  { || Eval(bSigaGotFocus),lFocusTlv := .T.}		
		oGetTlv:oBrowse:bGotFocus  	:=  { || Eval(bSigaGotFocus),lFocusTlv := .T.,F11AutoExecute()}
		oGetTlv:oBrowse:bLostFocus	:=  { || lFocusTlv := .F. }   		
		oGetTlv:oBrowse:bRClicked := {||BlClickRunF11()} 
		bRefresh := {|| (IIf(!lTk271Auto,((U_MyTk273Refresh()),(Eval(bFolderRefresh)),Eval(bDoRefresh)),Tk273Refresh()))}	    	// Efetua o Refresh da NF	
	EndIf
	

	// Jorge Oliveira - 27/10/10 - Criada a variavel para ser recuperada sempre que foi utilizada a tecla na funcao IMDM100()
	__ClienteAtual := M->UA_CLIENTE + M->UA_LOJA

	Set key VK_F11 to
	SetKey(VK_F11, {|| U_IMDF190()})

	Set key VK_F12 to
	SetKey(VK_F12, {|| U_IMDM100()}) 
	



	//|ANALISTA: CRISTIANO MACHADO DESC.: PERCENTUAL DO FRETE   DATA: 31/07/13
	U_CAMPRODAPE()
	//FIM

	    /////JULIO JACOVENKO, em 30/10/2015
	    /////para testar IMC
	    ///// 
	//Set key K_SH_F1 to
	//SetKey(K_SH_F1, {|| U_FDEFMC()})
	
	Set key VK_F4 to
	SetKey(VK_F4, {|| U_FDEFMC()})


EndIf


Return .T.

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘
北砅rograma  ?IMDM100     ?Autor 矹orge Oliveira      ?Data ?05/10/10 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢
北矰escri噭o ?Coloca na tela o Codigo e Loja do ultimo Cliente utilizado 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ?U_IMDM100()                                                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?NIL                                                        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砇etorno   ?NIL                                                        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ?Call Center                                                潮?
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢
北?ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     潮?
北媚哪哪哪哪哪哪穆哪哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?PROGRAMADOR  ?DATA   ?DESCRICAO                                     潮?
北媚哪哪哪哪哪哪呐哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北?             ?       ?                                              潮?
北滥哪哪哪哪哪哪牧哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
/*/
User Function IMDM100()

	If !Empty( __ClienteAtual ) .And. __ClienteAtual <> M->UA_CLIENTE + M->UA_LOJA

		M->UA_CLIENTE := Left( __ClienteAtual, 6 )
		M->UA_LOJA    := Right( __ClienteAtual, 2 )

		oGetTlv:oBrowse:Refresh(.T.)

	EndIf

Return                            

            


///////////------------------------------------------
///USADO NAS ROTINAS PARA CONTROLE 
///DA COBRANCA NO NOVO FRETE
///CAMPRODAPE.PRW
///MSTROT2.PRW
///PE_TK271OK.PRW
///PE_TMKVFIM.PRW
///M460FIM.PRW
///PE_TMKACTIVE.PRW (AQUI)
///VALROTA.PRW

USER FUNCTION LNFRT13()
Local lRet := .F.
//MV_FILFR13

	//XFILIAL('SUA')<>'07' .OR. XFILIAL('SUA')<>'11'	//.AND. (SA1->A1_CLFAMIN<>'S')

	//MV_FILFRT='05/11'
    //IF (XFILIAL('SUA') $ GETMV('MV_FILFRT') ) .AND. (SA1->A1_VINCULO<>'PP' .AND. SA1->A1_VINCULO<>'CM')
    IF (XFILIAL('SUA') $ GETMV('MV_FILFRT') ) .AND. (SA1->A1_VINCULO<>'PP' .AND. SA1->A1_VINCULO<>'CM') .AND. !(UPPER(SA1->A1_CLIFRTE) $ '1#X') .AND. M->UA_TPFRETE <> 'F'
    //IF (XFILIAL('SUA')=='05') .AND. (SA1->A1_VINCULO<>'PP' .OR. SA1->A1_VINCULO<>'CM')
       lRet := .T.
    ENDIF

RETURN lRet

*********************************//-----------------------------------------------------------------
Static Function F11AutoExecute() // Abre a Tela de Pesquisa F11 Automaticamente |Edivaldo Goncalves |
*********************************//-----------------------------------------------------------------
Local lCleanTMK  := IsInCallStack("TKLIMPA")
Local nP_PROD    := Ascan( aHeader, {|x| AllTrim( x[2] ) == "UB_PRODUTO"} )
Local lFirtTime  := Iif(Len(aCols)==1 .AND. Empty(acols[1,2]),.T.,.F.)
       
    //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Ap髎 informar o cliente e loja , o sitema abre o F11 Automaticamente ao receber o Foco no Browse para o lan鏰mento do primeiro item \\ 
    //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  
   
    If (lFirtTime .AND. TkGetTipoAte() != "3" .AND. !lCleanTMK)     
       bAction :=SETKEY(VK_F11) //Coloca  a acao no F11 
       SUB->(EVAL(bAction))     //Executa a acao
       SETKEY(VK_F11,bAction)  //joga a acao novamente no F11                               
    Endif 
    
Return(.T.)

*******************************//-----------------------------------------------------------------
Static Function BlClickRunF11()// Abre a Tela de Pesquisa F11 no Double Click |Edivaldo Goncalves |
*******************************//-----------------------------------------------------------------
Local lRunF11 :=Iif(!lRuningF11,.T.,.F.)

If lRunF11  //S?Executa o F11 no Double Click se n鉶 estiver sendo executado via Foco do Brose
    //Checa se precisa criar uma nova linha
     lCreateLinha :=StaticCall( IMDF051 , FAddLinha )
   
     bAction :=SETKEY(VK_F11) //Coloca  a acao no F11 
     SUB->(EVAL(bAction))     //Executa a acao
     SETKEY(VK_F11,bAction)  //joga a acao novamente no F11     
Endif  

Return
