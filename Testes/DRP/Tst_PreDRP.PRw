#Include "Totvs.ch"

// Posicao Array __aPer
#Define _PERIODO 1  //Periodo em Quest√£o ....
#Define _DTPEINI 2  //Data inicial do Periodo em Quest√£o ....
#Define _DTPEFIM 3  //Data Final do Periodo em Quest√£o ....

//
#Define ENTER   Chr(10) + Chr(13)
#Define HEXA    16 

// Contorle LOG
#Define INICIO  1
#Define IPCWAI  2
#Define SELDEL  3
#Define REGINC  4
#Define RESETP  5
#Define PROPVE  6
#Define FIMPVA  7
#Define FIMJOB  8
#Define ERRRRO  9

#Define DRPSEMAFORO 'DRPSEMAPREV'

/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUN«√O   : PreVDRP.prw | AUTOR : Cristiano Machado | DATA : 10/06/2020    **
**---------------------------------------------------------------------------**
** DESCRI«√O: Atualiza Previs√£o de Vendas                                    **
**---------------------------------------------------------------------------**
** USO : Especifico para Imdepa Rolamentos - Projeto DRP                     **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
** ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                         **
**---------------------------------------------------------------------------**
** PROGRAMADOR | DATA | MOTIVO DA ALTERACAO                                  **
**---------------------------------------------------------------------------**
**   |  |                                                                    **
**   |  |                                                                    **
\*---------------------------------------------------------------------------*/
*******************************************************************************
User Function Tst_PreVDRP( )
*******************************************************************************


	Local cRpcEmp		:= "01"			// Empresa
	Local cRpcFil		:= "05"			// Filial Principal
	Local cEnvUser		:= "Admin"
	Local cEnvPass		:= "1md3p44dm"	
	Local cEnvMod		:= "EST"		// Modulo
	Local cFunName		:= "IAPreVen"	// Funcao 
    Local aTables 		:= {"ZD0","ZD1","SB1","ZA7","SC4"}
    
	Private cLog		:= "" 
    
	// Desativar posterior [ FORCA UMA EXECUCAO ]
	//Default _cTpOper := _MENSAL // _MENSAL // _SEMANAL // _DIARIO


	//O comando RpcSetEnv() È utilizado para abertura de ambiente em rotinas autom·tica 
	RpcSetEnv( cRpcEmp , cRpcFil , cEnvUser, cEnvPass, cEnvMod, cFunName , aTables, , , ,  )
	
	//Processo Principal Geracao Previsao de Vendas e Niveis de Estoque.
	ProcMain()

	// Encerra o Ambiente...
	RpcClearEnv()


Return 
*******************************************************************************
    Static Function ProcMain()
*******************************************************************************

    Private oHashMV := HMNew()
    
    Default __aPer      := {0,'20201215','20201215'}
    Default __nThread   := 0

    Private sDataIni    := ""       // Data Formato Sistema Inicial para SC4
    Private sDataFim    := ""       // Data Formato Sistema Final para SC4
    Private aPer        := __aPer     // Data Formato Sistema Inicial para SC4
    Private nThread     := __nThread  // Data Formato Sistema Final para SC4
    Private cLog        := " " + ENTER + ENTER

    Private cAES        := "TXPRO" 		// Alias da Tabela Auxiliar de Calulo dos Estoques... 
	Private cACP        := "TCLIXPRO" 	// Alias da Tabela Auxiliar de Relacao Cliente x Produto... 
	Private cAMV        := "TMEDVEND" 	// Alias da Tabela Auxiliar de Medias de Venda e Venda Revisada ...
	Private cAFK        := "FORMULAK" 	// Alias da Tabela Auxiliar que salva a Formala K

    sDataIni := aPer[_DTPEINI] // Data Formato Sistema Inicial para SC4
    sDataFim := aPer[_DTPEFIM] // Data Formato Sistema Final para SC4



    // Previs„o SintÈtica [ZD4]................................................
    // Seleciona Registros e os Remove da Tabela ZD4 Dentro de Um Periodo... 
    SelPSiDel(sDataIni, sDataFim ) //, @aRegDel)
    
    // Seleciona Registros e os Inclui na Tabela ZD4 Dentro de Um Periodo... 
    SelPSiInc(sDataIni, sDataFim ) //, @aRegInc)
    
    // Atualiza Todos os Registros da Previsao Sintetica ZD4
    ProPSiAtu(sDataIni, sDataFim ) // , @aRegPro)

 

Return Nil
*******************************************************************************
Static Function SelPSiDel(sDataIni, sDataFim )  // Seleciona Registros e os Remove da Tabela ZD4 Dentro de Um Periodo... 
*******************************************************************************
//Local cCursor   := CriaTrab(NIL, .F.) 
Local cSql      := ""
Local nDel      := 0

// Confere os Registros que devem ser removidos da Tabela SC4 Baseado na Tabela Auxiliar TCLIXPRO (cACP)...
    cSql += "SELECT ZD4.R_E_C_N_O_ ZD4REC "
    cSql += "FROM   ZD4010 ZD4  "
    cSql += "WHERE  D_E_L_E_T_ = ' '  "
    cSql += "       AND ZD4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' "  
    cSql += "       AND NOT EXISTS (SELECT SC4.C4_FILIAL,  "
    cSql += "                              PRO.SEQZD1,  "
    cSql += "                              SC4.C4_DATA  "
    cSql += "                       FROM   SC4010 SC4  "
    cSql += "                              INNER JOIN "+cAES+" PRO  "
    cSql += "                                       ON SC4.C4_FILIAL = PRO.FILIAL  "
    cSql += "                                       AND SC4.C4_PRODUTO = PRO.PRODUTO  "
    cSql += "                               INNER JOIN SA1010 SA1 " //-- NOVO
    cSql += "                                       ON SC4.C4_CLIENTE = SA1.A1_COD  " //-- NOVO
    cSql += "             						    AND SC4.C4_LOJACLI  = SA1.A1_LOJA "  //-- NOVO
    cSql += "                       WHERE  SC4.C4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' "  
    cSql += "                              AND SC4.D_E_L_E_T_ = ' '  "
    cSql += "                              AND SA1.D_E_L_E_T_ = ' ' " //-- NOVO
    cSql += "                              AND SC4.C4_FILIAL = ZD4.ZD4_FILIAL  "
    cSql += "                              AND SC4.C4_DATA = ZD4.ZD4_DATA  "
    cSql += "                              AND PRO.SEQZD1 = ZD4.ZD4_SEQZD1  "
    cSql += "                              AND SC4.C4_LOCAL = ZD4.ZD4_LOCAL "  //-- NOVO
    cSql += "                              AND SUBSTR(SA1.A1_GRPSEG,3,1) = ZD4.ZD4_CANAL " //-- NOVO
    cSql += "                       GROUP  BY SC4.C4_FILIAL,  "
    cSql += "                                 PRO.SEQZD1,  "
    cSql += "                                 SC4.C4_DATA,
    cSql += "                                 SC4.C4_LOCAL, "  //-- NOVO
    cSql += "                                 SUBSTR(SA1.A1_GRPSEG,3,1) )  "  //-- NOVO
    
    cSql += "UNION "
    //-- REMOVE OS REGISTROS PRIORIZADOS... 
    cSql += "SELECT ZD4.R_E_C_N_O_ SC4REC " 
    cSql += "FROM   ZD4010 ZD4 "
    cSql += "WHERE  D_E_L_E_T_ = ' ' "
    cSql += "   AND    ZD4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' "  
    cSql += "   AND    ZD4_TPREG <> 'O'  " // DIFERENTE DE ORIGINAIS... 

    U_ExecMySql( cSql, cCursor := CriaTrab(NIL, .F.) , cModo := "Q", lMostra := .F., lChange := .F. )


    DbSelectArea(cCursor)
    DbGotOP()
        While !EOF()
    
        DbSelectArea("ZD4")
        DbGoTo((cCursor)->ZD4REC)

        RecLock("ZD4", .F.)
        DbDelete()
        MsUnLock()
    
        nDel += 1 

        //aAdd( aRegDel , (cCursor)->SC4REC )

        DbSelectArea(cCursor)
        DbSkip()

    EndDo

    DbSelectArea(cCursor)
    DbCloseArea()

    //Monta Log  
    //MntLog( SELDEL , "Prv.Sin." + Alltrim(Transform( nDel , "@E 999,999 " )) + ".Regs" )

Return 
*******************************************************************************
Static Function SelPSiInc(sDataIni, sDataFim )   // Seleciona Registros e os Inclui na Tabela ZD4 Dentro de Um Periodo...
*******************************************************************************

Local cCursor   := ""
Local cSql      := ""
Local nInc      := 0
Local cObs      := "MRP_" + Substr(DToS(dDataBase),1,6) 

// Confere os Registros que devem ser removidos da Tabela SC4 Baseado na Tabela Auxiliar TCLIXPRO(cACP) ...
//cSql += "SELECT INC.REG INCREG, INC.FILIAL, INC.PRODUTO, INC.CLIENTE, INC.LOJA "


    cSql += "SELECT SC4.C4_FILIAL 		        FILIAL,  "
    cSql += "		PRO.SEQZD1 			        SEQZD1,  "
    cSql += "		SC4.C4_DATA 		        PSDATA,  "
    cSql += "		SC4.C4_LOCAL		        ALOCAL, "//-- NOVO
    cSql += "		SUBSTR(SA1.A1_GRPSEG,3,1)   CANAL, "//-- NOVO
    cSql += "		SUM(SC4.C4_PREVSUP) 	    QTDPRE, "
    cSql += "		SUM(SC4.C4_ESTSEG) 	        ESTSEG, "
    cSql += "		SUM(SC4.C4_ESTMIN) 	        ESTMIN, "
    cSql += "		SUM(SC4.C4_ESTOBJ) 	        ESTOBJ, "
    cSql += "		SUM(SC4.C4_ESTMAX) 	        ESTMAX, "
    cSql += "		SUM(SC4.C4_PREVSUP) 	    QTDPRE, "
    cSql += "		SUM(SC4.C4_PROGRAM) 	    QTDPRO, "
    cSql += "		SUM(SC4.C4_PRVDFIN) 	    QTDFIN  "
    cSql += "FROM SC4010 SC4 INNER JOIN "+cAES+" PRO  "
    cSql += "ON   SC4.C4_FILIAL = PRO.FILIAL "
    cSql += "AND  SC4.C4_PRODUTO = PRO.PRODUTO "
    cSql += "                INNER JOIN SA1010 SA1 " //-- NOVO
    cSql += "ON SC4.C4_CLIENTE = SA1.A1_COD  " //-- NOVO
    cSql += "AND SC4.C4_LOJACLI  = SA1.A1_LOJA "  //-- NOVO
    cSql += "WHERE  SC4.D_E_L_E_T_ = ' '  "
    cSql += "AND SA1.D_E_L_E_T_ = ' ' "  //-- NOVO
    cSql += "AND SC4.C4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' "  
    cSql += "AND NOT EXISTS (SELECT         ZD4.ZD4_FILIAL,  "
    cSql += "                               ZD4.ZD4_SEQZD1, " 
    cSql += "                               ZD4.ZD4_DATA  "
    cSql += "                       FROM    ZD4010 ZD4  "
    cSql += "                       WHERE   ZD4.ZD4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' "  
    cSql += "                               AND ZD4.D_E_L_E_T_ = ' '  "
    cSql += "                               AND SC4.C4_FILIAL = ZD4.ZD4_FILIAL " 
    cSql += "                               AND SC4.C4_DATA 	= ZD4.ZD4_DATA  "
    cSql += "                               AND SC4.C4_LOCAL = ZD4.ZD4_LOCAL "//-- NOVO
    cSql += "                               AND SUBSTR(SA1.A1_GRPSEG,3,1) = ZD4.ZD4_CANAL " //-- NOVO
    cSql += "                              AND PRO.SEQZD1 	= ZD4.ZD4_SEQZD1 )  "
    cSql += "GROUP  BY SC4.C4_FILIAL, PRO.SEQZD1, SC4.C4_DATA,  SC4.C4_LOCAL, SUBSTR(SA1.A1_GRPSEG,3,1)  "//-- NOVO

    //ConOut( "SelPSiInc : [ " + cSql + " ]")
    
    U_ExecMySql( cSql, cCursor := CriaTrab(NIL, .F.) , cModo := "Q", lMostra := .F., lChange := .F. )

    DbSelectArea(cCursor)
    DbGotOP()
    While !EOF()
    
    //ConOut("SC4->INCLUINDO : FILIAL["+(cCursor)->FILIAL +"] PRODUTO["+(cCursor)->PRODUTO +"] CLIENTE["+(cCursor)->CLIENTE +"]" )
    
        DbSelectArea("ZD4")
        RecLock("ZD4", .T.)

        ZD4->ZD4_FILIAL := (cCursor)->FILIAL
        ZD4->ZD4_SEQZD1 := (cCursor)->SEQZD1 
        ZD4->ZD4_DATA   := SToD( (cCursor)->PSDATA ) 
        ZD4->ZD4_OBS    := cObs
        ZD4->ZD4_QTDPRE := (cCursor)->QTDPRE
        ZD4->ZD4_QTDPRO := (cCursor)->QTDPRO
        ZD4->ZD4_QTDFIN := (cCursor)->QTDFIN
        ZD4->ZD4_ESTSEG := (cCursor)->ESTSEG
        ZD4->ZD4_ESTMIN := (cCursor)->ESTMIN
        ZD4->ZD4_ESTOBJ := (cCursor)->ESTOBJ
        ZD4->ZD4_ESTMAX := (cCursor)->ESTMAX
        ZD4->ZD4_LOCAL  := (cCursor)->ALOCAL
        ZD4->ZD4_CANAL  := (cCursor)->CANAL
        ZD4->ZD4_TPREG  := "O" // O-Original |  P-Priorizado
        MsUnLock()

        nInc += 1

        DbSelectArea(cCursor)
        DbSkip()

    EndDo

DbSelectArea(cCursor)
DbCloseArea()

//MntLog( REGINC , "Prv.Sin." + Alltrim(Transform( nInc , "@E 999,999 " )) + ".Regs" )

Return Nil
*******************************************************************************
Static Function ProPSiAtu(sDataIni, sDataFim )  // Atualiza Todos os Registros da Previsao Sintetica ZD4
*******************************************************************************

    Local cCursor   := ""
    Local cSql      := ""
    Local nAtu      := 0
    Local cObs      := "MRP_" + Substr(DToS(dDataBase),1,6) 


    cSql += "SELECT ZD4.R_E_C_N_O_  ZD4REC, "
    cSql += "       SC4.SC4_QTDPRE  QTDPRE, "
    cSql += "       SC4.SC4_PROGRAM QTDPRO, "
    cSql += "       SC4.SC4_PRVDFIN QTDFIN, "
    cSql += "       SC4.SC4_ESTSEG  ESTSEG, "
    cSql += "       SC4.SC4_ESTMIN  ESTMIN, "
    cSql += "       SC4.SC4_ESTOBJ  ESTOBJ, " 
    cSql += "       SC4.SC4_ESTMAX  ESTMAX "
    cSql += "FROM   ZD4010 ZD4  "
    cSql += "       INNER JOIN (SELECT SC4.C4_FILIAL      		 SC4_FILIAL, "
    cSql += "                          PRO.SEQZD1         		 SC4_SEQZD1, "
    cSql += "                          SC4.C4_DATA        		 SC4_DATA, "
    cSql += "                          SC4.C4_LOCAL 		 	 SC4_LOCAL, "
    cSql += "                          SUBSTR(SA1.A1_GRPSEG,3,1) SC4_CANAL, "
    //cSql += "                          SUM(SC4.C4_ANASUP) 		 SC4_QTDPRE, "
    cSql += "		                   SUM(SC4.C4_PREVSUP) 	     SC4_QTDPRE, "
    cSql += "		                   SUM(SC4.C4_PROGRAM) 	     SC4_PROGRAM, "
    cSql += "		                   SUM(SC4.C4_PRVDFIN) 	     SC4_PRVDFIN,  "
    cSql += "                          SUM(SC4.C4_ESTSEG) 		 SC4_ESTSEG, "
    cSql += "                          SUM(SC4.C4_ESTMIN) 		 SC4_ESTMIN, "
    cSql += "                          SUM(SC4.C4_ESTOBJ) 		 SC4_ESTOBJ, "
    cSql += "                          SUM(SC4.C4_ESTMAX) 		 SC4_ESTMAX "
    cSql += "                   FROM   SC4010 SC4 "
    cSql += "                          INNER JOIN "+cAES+" PRO "
    cSql += "                            ON SC4.C4_FILIAL = PRO.FILIAL "
    cSql += "                           AND SC4.C4_PRODUTO = PRO.PRODUTO "
    cSql += "                          INNER JOIN SA1010 SA1 "
    cSql += "                            ON SC4.C4_CLIENTE = SA1.A1_COD  "
    cSql += "        					AND SC4.C4_LOJACLI  = SA1.A1_LOJA  "
    cSql += "                   WHERE  	SC4.D_E_L_E_T_ = ' ' "
    cSql += "                       AND SA1.D_E_L_E_T_ = ' ' "
    cSql += "                       AND SC4.C4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' "  
    cSql += "                   GROUP  BY SC4.C4_FILIAL, "
    cSql += "                             PRO.SEQZD1, "
    cSql += "                             SC4.C4_DATA, "
    cSql += "                             SC4.C4_LOCAL, "
    cSql += "                             SUBSTR(SA1.A1_GRPSEG,3,1) ) SC4 "
    cSql += "         ON SC4.SC4_FILIAL = ZD4.ZD4_FILIAL "
    cSql += "            AND SC4.SC4_SEQZD1 = ZD4.ZD4_SEQZD1 "
    cSql += "            AND SC4.SC4_LOCAL  = ZD4.ZD4_LOCAL  "
    cSql += "            AND SC4.SC4_CANAL = ZD4.ZD4_CANAL  "
    cSql += "WHERE  ZD4.D_E_L_E_T_ = ' ' "
    cSql += "AND ZD4.ZD4_DATA BETWEEN '" + sDataIni + "' AND '" + sDataFim + "' " 
    cSql += "AND ZD4.ZD4_TPREG = 'O'  "

    U_ExecMySql( cSql, cCursor := CriaTrab(NIL, .F.) , cModo := "Q", lMostra := .F., lChange := .F. )


    DbSelectArea(cCursor)
    DbGotOP()
    While !EOF()
    
    //ConOut("SC4->INCLUINDO : FILIAL["+(cCursor)->FILIAL +"] PRODUTO["+(cCursor)->PRODUTO +"] CLIENTE["+(cCursor)->CLIENTE +"]" )
        
        DbSelectArea("ZD4")
        DbGoto( (cCursor)->ZD4REC )
        
        If !EOF()
            // SÛ atualiza se houve mudanÁa de valores... 
            If Alltrim(ZD4->ZD4_OBS) <> Alltrim(cObs) 	  .Or. ZD4->ZD4_QTDPRE <> (cCursor)->QTDPRE .Or. ZD4->ZD4_QTDPRO <> (cCursor)->QTDPRO .Or.;
		             ZD4->ZD4_QTDFIN <> (cCursor)->QTDFIN .Or. ZD4->ZD4_ESTSEG <> (cCursor)->ESTSEG .Or. ZD4->ZD4_ESTMIN <> (cCursor)->ESTMIN .Or.;
		             ZD4->ZD4_ESTOBJ <> (cCursor)->ESTOBJ .Or. ZD4->ZD4_ESTMAX <> (cCursor)->ESTMAX
            
                RecLock("ZD4", .F.)

                //ZD4->ZD4_FILIAL := (cCursor)->FILIAL
                //ZD4->ZD4_DATA   := (cCursor)->PSDATA
                ZD4->ZD4_OBS    := cObs
                ZD4->ZD4_QTDPRE := (cCursor)->QTDPRE
                ZD4->ZD4_QTDPRO := (cCursor)->QTDPRO
                ZD4->ZD4_QTDFIN := (cCursor)->QTDFIN
                ZD4->ZD4_ESTSEG := (cCursor)->ESTSEG
                ZD4->ZD4_ESTMIN := (cCursor)->ESTMIN
                ZD4->ZD4_ESTOBJ := (cCursor)->ESTOBJ
                ZD4->ZD4_ESTMAX := (cCursor)->ESTMAX
                ZD4->ZD4_TPREG  := "O" // Original 
                MsUnLock()

                nAtu += 1
            EndIf
        EndIf

        DbSelectArea(cCursor)
        DbSkip()

    EndDo

    DbSelectArea(cCursor)
    DbCloseArea()

   // MntLog( PROPVE , "Prv.Sin." + Alltrim(Transform( nAtu , "@E 999,999 " )) + ".Regs" )


Return 
