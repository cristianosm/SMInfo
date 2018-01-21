#Include "totvs.ch"
      

#define CLR_GRAY RGB( 220, 220, 220 )

//------------------------------------------------------------------     
*******************************************************************************   
user function TGrid()                                  
*******************************************************************************
    Local oDlg	:= Nil
    Local oGrid	:= Nil
    Local oGrouB:= Nil
    Local oGrouC:= Nil
    Local oFont := Nil
    Local oSay  := Nil
    
    Local oTGDocto := Nil
    Local oTGEmiss := Nil
    Local oTGForne := Nil
    Local oTGAprov := Nil
    Local oTGDataR := Nil
    Local oTGObser := Nil
   
    Local aPos 	:= {075,05,568,246}			//| Acols Posicao do Grid (Lin, Col, Comp, Altura)
    Local aTCol := {0,0,0,0,0,0,0,0,0,0}	//| Acols contendo Largura das Colunas
       
    Local aHeader 	:= {}
    Local aCols		:= {}
  
    GetAHeader( @aHeader, @aTCol ) 	//| Monta AHeader
    GetAcols( @aCols, @aTCol )		//| Monta ACols
     
	oDlg 	:= TDialog():New(050,050,700,1200,'Liberação de Docto',,,,,CLR_BLACK,CLR_WHITE,,,.T.,,,,,,)
    
    oGrouC	:= TGroup():New(005,005,070,500,'',oDlg,,,.T.)
    oGrouB	:= TGroup():New(005,505,070,571,'',oDlg,,,.T.)
    
    oFontS := TFont():New('Calibri',,-15,.T.,lBolt := .T.) // Fonte Say
    oFontG := TFont():New('Calibri',,-15,.T.,lBolt := .F.) // Fonte Get
    
    oSay := TSay():New(013,014,{||"Número do Dcto : "}	,oDlg,,oFontS,,,,.T.,,,400,300,,,,,,.F.)
    oSay := TSay():New(013,180,{||"Aprovador : "}		,oDlg,,oFontS,,,,.T.,,,400,300,,,,,,.F.)
    
    oSay := TSay():New(033,014,{||"Emissão : "}			,oDlg,,oFontS,,,,.T.,,,400,300,,,,,,.F.)
    oSay := TSay():New(033,180,{||"Fornecedor : "}		,oDlg,,oFontS,,,,.T.,,,400,300,,,,,,.F.)
    
    oSay := TSay():New(053,014,{||"Data de Ref : "}		,oDlg,,oFontS,,,,.T.,,,400,300,,,,,,.F.)
    oSay := TSay():New(053,180,{||"Observação : "}		,oDlg,,oFontS,,,,.T.,,,400,300,,,,,,.F.)
    
    cTexto := ""
    oTGDocto := TGet():New( 010,075,{||cTexto},oDlg,096,015,"@!",,CLR_GRAY,,oFontG,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTexto,,,, )
    oTGAprov := TGet():New( 010,225,{||cTexto},oDlg,265,015,"@!",,CLR_GRAY,,oFontG,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTexto,,,, )
    
    oTGEmiss := TGet():New( 030,075,{||cTexto},oDlg,096,015,"@!",,CLR_GRAY,,oFontG,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTexto,,,, )
    oTGForne := TGet():New( 030,225,{||cTexto},oDlg,265,015,"@!",,CLR_GRAY,,oFontG,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTexto,,,, )
    
    oTGDataR := TGet():New( 050,075,{||cTexto},oDlg,096,015,"@!",,CLR_GRAY,,oFontG,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTexto,,,, )
    oTGObser := TGet():New( 050,225,{||cTexto},oDlg,265,015,"@!",,CLR_GRAY,,oFontG,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTexto,,,, )
    
    oTBApro := TButton():New( 010, 513, "Aprovar"  ,oDlg,{||alert("Aprovar")} , 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTBBloq := TButton():New( 030, 513, "Bloquear" ,oDlg,{||alert("Bloquear")}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTBCanc := TButton():New( 050, 513, "Cancelar" ,oDlg,{||alert("Cancelar")}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
    
    
    oGrid  	:= GridLPCC():New(oDlg,aHeader,aCols,aPos,aTCol)
        
    oDlg:Activate(,,,.T.,{||msgstop('Validou'),.T.},,{||msgstop('Iniciando')} )
       
Return
*******************************************************************************
Static Function GetAHeader(aHeader, aTCol)
*******************************************************************************
	
	aTCol[01] := Len("ITEM" )  
    aTCol[02] := Len("CTA GER")  
    aTCol[03] := Len("C. CUSTO")  
    aTCol[04] := Len("QUANTIDADE")  
    aTCol[05] := Len("UNI")  
    aTCol[06] := Len("PREÇO")  
    aTCol[07] := Len("TOTAL")  
    aTCol[08] := Len("DESCRIÇÃO")  
    aTCol[09] := Len("OBSERVAÇÀO")  
	
	AAdd(aHeader, "ITEM" )
	AAdd(aHeader, "CTA GER" )
	AAdd(aHeader, "C. CUSTO" )
	AAdd(aHeader, "QUANTIDADE" )
	AAdd(aHeader, "UNI" )
	AAdd(aHeader, "PREÇO" )
	AAdd(aHeader, "TOTAL" )
	AAdd(aHeader, "DESCRIÇÃO" )
	AAdd(aHeader, "OBSERVAÇÀO" )
	AAdd(aHeader, " " )
	
Return Nil
*******************************************************************************
Static Function GetAcols(aCols, aTCol)// Obtem os Dados e Alimento o Acols
*******************************************************************************
	Local cSql := ""

	cSql += "SELECT C7_FILIAL, C7_NUM, C7_ITEM, 'C7_CTAGER + ZG_DESCR ' C7_CTAGER, 'C7_CC' C7_CC, C7_QUANT, C7_UM, C7_PRECO, C7_TOTAL, C7_DESCRI, ' ' C7_OBSPRO "  
	cSql += "FROM SC7010 "
	cSql += "WHERE D_E_L_E_T_ = ' ' "
	cSql += "AND C7_NUM = '000011' "
	cSql += "AND C7_FILIAL = '09' "
	
	U_ExecMySql( cSql, cCursor := "TPED" , lModo := "Q", lMostra := .T., lChange := .F. )
	
     
    // Cria os Dados                     
                             
    DbSelectArea(cCursor)
    DbGoTop()
    While !EOF()
    
       cItemPC := Alltrim(TPED->C7_ITEM) 	//| Item Pedido de Compra	
       cCtaGer := Alltrim(TPED->C7_CTAGER) 	//| Conta Gerente
       cCenCus := Alltrim(TPED->C7_CC) 		//| Contro de Custo
       cQtdPed := Transform( TPED->C7_QUANT , "@E 99,999,999.99" )	//| Quantidade
       cUniMed := Alltrim(TPED->C7_UM) 		//| Unidade de Medida
       cPrecoU := Transform( TPED->C7_PRECO , "@E 99,999,999.99" ) 	//| Preço Unitario
       cValTot := Transform( TPED->C7_TOTAL , "@E 999,999,999.99" ) 	//| Total 
       cDescri := Alltrim(TPED->C7_DESCRI) 	//| Descricao
       cObsPro := Alltrim(TPED->C7_OBSPRO) 	//| Observação Produto
       
 
       // Defini o Tamanho Maximo de Cada Coluna
       aTCol[01] := If( Len(cItemPC) > aTCol[01] , Len(cItemPC) , aTCol[01] ) 
       aTCol[02] := If( Len(cCtaGer) > aTCol[02] , Len(cCtaGer) , aTCol[02] ) 
       aTCol[03] := If( Len(cCenCus) > aTCol[03] , Len(cCenCus)	, aTCol[03] ) 
       aTCol[04] := If( Len(cQtdPed) > aTCol[04] , Len(cQtdPed) , aTCol[04] ) 
       aTCol[05] := If( Len(cUniMed) > aTCol[05] , Len(cUniMed) , aTCol[05] ) 
       aTCol[06] := If( Len(cPrecoU) > aTCol[06] , Len(cPrecoU)	, aTCol[06] ) 
       aTCol[07] := If( Len(cValTot) > aTCol[07] , Len(cValTot) , aTCol[07] ) 
       aTCol[08] := If( Len(cDescri) > aTCol[08] , Len(cDescri)	, aTCol[08] ) 
       aTCol[09] := If( Len(cObsPro) > aTCol[09] , Len(cObsPro)	, aTCol[09] ) 
       aTCol[10] := 2 
       
       AADD( aCols, { cItemPC, cCtaGer, cCenCus, cQtdPed, cUniMed, cPrecoU, cValTot, cDescri, cObsPro, ' ' } )
       
       DbSelectArea(cCursor)
       DbSkip()
       
      EndDo
      

Return Nil
