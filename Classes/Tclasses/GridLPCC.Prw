#Include "totvs.ch"

//------------------------------------------------------------------
//Exemplo de configuração de TGrid em array com navegação por linha
//------------------------------------------------------------------
#define GRID_MOVEUP       0
#define GRID_MOVEDOWN     1
#define GRID_MOVEHOME     2
#define GRID_MOVEEND      3
#define GRID_MOVEPAGEUP   4
#define GRID_MOVEPAGEDOWN 5

#Define P_LIN 1 //| Posicao da Linha Inicial 
#Define P_COL 2 //| Posicao da Coluna Inicial
#Define P_WID 3 //| Comprimento do Grid
#Define P_HEI 4 //| Altura do Grid

#Define NPPC 11 //| Numero de Pixel por Caracter 

#Define CONTROL_ALIGN_CENTER 0 

*******************************************************************************
CLASS GridLPCC
*******************************************************************************
	
	DATA oGrid
	DATA oFrame
	DATA oButtonsFrame		//| Barra Lateral para incluir os Botoes
	DATA oButtonHome		//| Botao ir ao Inicio do Grid
	DATA oButtonPgUp		//| Botao Subir uma pagina no Grid
	DATA oButtonUp			//| Botao subir um registro no Grid
	DATA oButtonDown		//| Botao descer um registro no Grid
	DATA oButtonPgDown		//| Botao descer uma pagina no Grid
	DATA oButtonEnd			//| Botao ir ao Final do Grid
	DATA aData				//| Array contendo Colunas do Grid
	DATA nLenData			//| Numero Total de Linhas do Grid
	DATA nRecNo				//| Armazena o registro do grid posicionado
	DATA nCursorPos
	DATA nVisibleRows		//| Define o Numero de linhas visíveis no Grid.
	DATA nFreeze
	DATA nHScroll

	Method New(oDlg, aHeader, aData, aPos, aTCol) CONSTRUCTOR
	Method onMove( o,nMvType,nCurPos,nOffSet,nVisRows )
	Method isBof()			//| Verifica se esta no Primeiro Registro
	Method isEof()			//| Verifica se esta no Ultimo Registro
	Method ShowData( nFirstRec, nCount ) 
	Method ClearRows()
	Method DoUpdate()
	Method SelectRow(n)		//| Posiciona na linha selecionada do objeto.
	Method GoHome()
	Method GoEnd()
	Method GoPgUp()
	Method GoPgDown()
	Method GoUp(nOffSet)
	Method GoDown(nOffSet)
	Method SetCSS(cCSS)
	Method SetFreeze(nFreeze)
	Method SetHScrollState(nHScroll)

ENDCLASS
*******************************************************************************
Method New(oDlg, aHeader, aData, aPos, aTCol) CLASS GridLPCC
*******************************************************************************
	Local oFont

	::oFrame		:= tPanel():New(aPos[P_LIN],aPos[P_COL],,oDlg,,,,,,aPos[P_WID],aPos[P_HEI] )
	::nRecNo		:= 1
	::nCursorPos	:= 0
	::nVisibleRows 	:= 12		//| Define o Numero de linhas visíveis no Grid.

	::aData			:= aData
	::nLenData		:= Len(aData)
	
	::oGrid			:= TGrid():New( ::oFrame,aPos[P_LIN],aPos[P_COL],aPos[P_WID],aPos[P_HEI]) // Criacao do GRID
	
	::oGrid:Align	:= CONTROL_ALIGN_ALLCLIENT //| Indica o alinhamento do texto na coluna.

	oFont := TFont():New('Arial',,-14,.T.)
	::oGrid:SetFont(oFont)
	
	// Define o a Alterura da Linha do Grid
	::oGrid:setRowHeight(30)

	// Criacao e Definicao da Barra Lateral para receber botoes de Controle... 
	::oButtonsFrame			:= tPanel():New(0,0,, ::oFrame,,,,,, 10,aPos[P_HEI],.F.,.T. )
	::oButtonsFrame:Align 	:= CONTROL_ALIGN_RIGHT
	
	// Criacao e Definicao do Botao da  Lateral para ... 
	::oButtonHome			:= tBtnBmp():NewBar( "VCTOP.BMP"	,,,,, {||::GoHome()}	,,::oButtonsFrame )
	::oButtonHome:Align		:= CONTROL_ALIGN_TOP
	
	// Criacao e Definicao do Botao da  Lateral para ... 
	::oButtonPgUp			:= tBtnBmp():NewBar( "VCPGUP.BMP"	,,,,, {||::GoPgUp()}	,,::oButtonsFrame )
	::oButtonPgUp:Align		:= CONTROL_ALIGN_TOP
	
	// Criacao e Definicao do Botao da  Lateral para ... 
	::oButtonUp				:= tBtnBmp():NewBar( "VCUP.BMP"		,,,,,{||::GoUp(1)}		,,::oButtonsFrame )
	::oButtonUp:Align		:= CONTROL_ALIGN_TOP
	
	// Criacao e Definicao do Botao da  Lateral para ... 
	::oButtonEnd			:= tBtnBmp():NewBar( "VCBOTTOM.BMP"	,,,,, {||::GoEnd()}		,,::oButtonsFrame )
	::oButtonEnd:Align		:= CONTROL_ALIGN_BOTTOM
	
	// Criacao e Definicao do Botao da  Lateral para ... 
	::oButtonPgDown			:= tBtnBmp():NewBar( "VCPGDOWN.BMP"	,,,,, {||::GoPgDown()}	,,::oButtonsFrame )
	::oButtonPgDown:Align	:= CONTROL_ALIGN_BOTTOM
	
	// Criacao e Definicao do Botao da  Lateral para ... 
	::oButtonDown			:= tBtnBmp():NewBar( "VCDOWN.BMP"	,,,,, {||::GoDown(1)}	,,::oButtonsFrame )
	::oButtonDown:Align		:= CONTROL_ALIGN_BOTTOM
	
	// Adiciona colunas no objeto.
	For nC := 1 To len(aHeader)
		::oGrid:addColumn( nC, aHeader[nC] , aTCol[nC] * NPPC , CONTROL_ALIGN_CENTER )
	Next
	
	// Configura o Movimento do Scroll do Mause 
	::oGrid:bCursorMove:= {|o,nMvType,nCurPos,nOffSet,nVisRows| ::onMove(o,nMvType,nCurPos,nOffSet,nVisRows) }
	
	//| Confgura os dados que serão apresentados em determinada linha do objeto.
	::ShowData(1)
	
	::SelectRow( ::nCursorPos )
	// configura acionamento do duplo clique
	::oGrid:bLDblClick:= {|| MsgStop("oi") }

Return
*******************************************************************************
Method isBof() CLASS GridLPCC
*******************************************************************************
Return  ( ::nRecno==1 )
*******************************************************************************
Method isEof() CLASS GridLPCC
*******************************************************************************
Return ( ::nRecno==::nLenData )
*******************************************************************************
Method GoHome() CLASS GridLPCC
*******************************************************************************
	if ::isBof()
		Return
	EndIf
	::nRecno = 1
	::oGrid:ClearRows()
	::ShowData( 1, ::nVisibleRows )
	::nCursorPos:= 0
	::SelectRow( ::nCursorPos )
	
Return
*******************************************************************************
Method GoEnd() CLASS GridLPCC
*******************************************************************************
	if ::isEof()
		Return
	EndIf

	::nRecno := ::nLenData
	::oGrid:ClearRows()
	::ShowData( ::nRecno - ::nVisibleRows + 1, ::nVisibleRows )
	::nCursorPos:= ::nVisibleRows - 1
	::SelectRow( ::nCursorPos )
	
Return
*******************************************************************************
Method GoPgUp() CLASS GridLPCC
*******************************************************************************
	if ::isBof()
		Return
	EndIf

	// força antes ir para a 1a linha da grid
	if ::nCursorPos != 0
		::nRecno -= ::nCursorPos
		if ::nRecno <= 0
			::nRecno:=1
		EndIf
		::nCursorPos:= 0
		::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } )
	else
		::nRecno -= ::nVisibleRows
		if ::nRecno <= 0
			::nRecno:=1
		EndIf
		::oGrid:ClearRows()
		::ShowData( ::nRecno, ::nVisibleRows )
		::nCursorPos:= 0
	EndIf
	::SelectRow( ::nCursorPos )
	
Return
*******************************************************************************
Method GoPgDown() CLASS GridLPCC
*******************************************************************************
	Local nLastVisRow

	if ::isEof()
		Return
	EndIf

	// força antes ir para a última linha da grid
	nLastVisRow:= ::nVisibleRows-1

	if ::nCursorPos!=nLastVisRow

		if ::nRecno+nLastVisRow > ::nLenData
			nLastVisRow:= ( ::nRecno+nLastVisRow ) - ::nLenData
			::nRecno:= ::nLenData
		else
			::nRecNo += nLastVisRow
		EndIf

		::nCursorPos:= nLastVisRow
		::ShowData( ::nRecNo - ::nVisibleRows + 1, ::nVisibleRows )
	else
		::oGrid:ClearRows()
		::nRecno += ::nVisibleRows

		if ::nRecno > ::nLenData
			::nVisibleRows = ::nRecno-::nLenData
			::nRecno:= ::nLenData
		EndIf

		::ShowData( ::nRecNo - ::nVisibleRows + 1, ::nVisibleRows )
		::nCursorPos:= ::nVisibleRows-1
	EndIf

	::SelectRow( ::nCursorPos )
	
Return
*******************************************************************************
Method GoUp(nOffSet) CLASS GridLPCC
*******************************************************************************
	Local lAdjustCursor:= .F.
	if ::isBof()
		Return
	EndIf
	if ::nCursorPos==0
		::oGrid:scrollLine(-1)
		lAdjustCursor:= .T.
	else
		::nCursorPos -= nOffSet
	EndIf
	::nRecno -= nOffSet

	// atualiza linha corrente
	::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } )

	if lAdjustCursor
		::nCursorPos:= 0
	EndIf
	::SelectRow( ::nCursorPos )
	
Return
*******************************************************************************
Method GoDown(nOffSet) CLASS GridLPCC
*******************************************************************************
	Local lAdjustCursor:= .F.
	if ::isEof()
		Return
	EndIf

	if ::nCursorPos==::nVisibleRows-1
		::oGrid:scrollLine(1)
		lAdjustCursor:= .T.
	else
		::nCursorPos += nOffSet
	EndIf
	::nRecno += nOffSet

	// atualiza linha corrente
	::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } )
	if lAdjustCursor
		::nCursorPos:= ::nVisibleRows-1
	EndIf
	::SelectRow( ::nCursorPos )
	
Return
*******************************************************************************
Method onMove( oGrid,nMvType,nCurPos,nOffSet,nVisRows ) CLASS GridLPCC
*******************************************************************************
	::nCursorPos	:= nCurPos
	::nVisibleRows	:= nVisRows

	if nMvType == GRID_MOVEUP
		::GoUp(nOffSet)
	ElseIf nMvType == GRID_MOVEDOWN
		::GoDown(nOffSet)
	ElseIf nMvType == GRID_MOVEHOME
		::GoHome()
	ElseIf nMvType == GRID_MOVEEND
		::GoEnd()
	ElseIf nMvType == GRID_MOVEPAGEUP
		::GoPgUp()
	ElseIf nMvType == GRID_MOVEPAGEDOWN
		::GoPgDown()
	EndIf
	
Return
*******************************************************************************
Method ShowData( nFirstRec, nCount ) CLASS GridLPCC
*******************************************************************************
	Local  i, nRec, ci
	Default nCount:=30

	for i := 0 to ( nCount - 1 )
		nRec := nFirstRec + i
		if nRec > ::nLenData
			Return
		EndIf
		ci := cValToChar( nRec )
		//cb:= "{|o| { Self:aData["+ci+",1], Self:aData["+ci+",2], Self:aData["+ci+",3] } }"
		
		//SetRowData ( < nRow>, < bData> ) : Confgura os dados que serão apresentados em determinada linha do objeto.
		//::oGrid:setRowData( i, &cb ) 
		::oGrid:setRowData( i , {|o| { Self:aData[&ci][1], Self:aData[&ci][2], Self:aData[&ci][3] } } )
		
	next i
Return
*******************************************************************************
Method ClearRows() CLASS GridLPCC
*******************************************************************************

	::oGrid:ClearRows()
	::nRecNo := 1
	
Return
*******************************************************************************
Method DoUpdate() CLASS GridLPCC  
*******************************************************************************

	::nRecNo := 1
	::Showdata(1)
	::SelectRow(0)
	
Return
*******************************************************************************
Method SelectRow(n) CLASS GridLPCC //| Posiciona na linha selecionada do objeto para apresentar os dados 
*******************************************************************************

	valor := n - ::nCursorPos
	::nRecno += valor
	if ::nRecno <= 0
		::nRecno = 1
	EndIf
	::nCursorPos := n
	::oGrid:setSelectedRow(n) 
	
Return
*******************************************************************************
Method SetCSS(cCSS) CLASS GridLPCC
*******************************************************************************

	::oGrid:setCSS(cCSS)
	
Return
*******************************************************************************
Method SetFreeze(nFreeze) CLASS GridLPCC
*******************************************************************************

	::nFreeze := nFreeze
	::oGrid:nFreeze := nFreeze
	
Return
*******************************************************************************
Method SetHScrollState(nHScroll) CLASS GridLPCC
*******************************************************************************

	::nHScroll := nHScroll
	::oGrid:nHScroll := nHScroll
	
Return