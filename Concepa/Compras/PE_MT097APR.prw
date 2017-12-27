#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE_MT097APRºAutor  ³Valerio            º Data ³  07/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Envia e-mail aos aprovadores após primeira aprovacao      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT097APR()
Return



User Function MT097END()

	Local aArea     := GetArea() 
	Local aPed 		:= {}
	Private cPedido   :=  SC7->C7_NUM

    Dbselectarea("SC7")
	Dbsetorder(1)
	Dbseek( xFilial("SC7") + cPedido, .F.)
	
	nRecSC7 := RecNo()   
	
	Do while .not. eof()
	   If C7_FILIAL + C7_NUM <> xFilial("SC7") + cPedido
	      Exit
	   Endif
		aAdd(aPed, {SC7->C7_FILIAL, SC7->C7_NUM, SC7->C7_ITEM, SC7->C7_PRODUTO, SC7->C7_DESCRI, SC7->C7_QUANT, SC7->C7_TOTAL, SC7->C7_DATPRF, SC7->C7_PRECO })
		dbSkip()
	EndDo 
	dbGoTo(nRecSC7)     
	
    If SC7->C7_CONAPRO == "B"    
    
        Dbselectarea("SA2")
        Dbsetorder(1)
        Dbseek( xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA, .F.)
        Dbselectarea("SC7")
    
    	ApNivel(aPed) 
    	             
    EndIf

	RestArea(aArea)
return

Static Function ApNivel(aPed)
	Local aArea    := GetArea()
	Local cFornece := SA2->A2_COD+" - "+SA2->A2_NOME
	Local cTotPed  := ""
	Local nTotPed  := 0
	Local cBody    := ""
	Local cSubject := "Aprovar Pedido de Compra"
	Local nItens   := Len(aPed)
	
	cBody := '<font color="#ff0000" face="Arial" size="3"><strong>Pedido de Compra Pendente de libera&ccedil;&atilde;o</strong></font>'
	cBody += '<br><br>'
	cBody += '<table width="800" border="0" align="center" cellpadding="5" cellspacing="0" rules="all" style="border: 1px solid #063; border-collapse: collapse;">'
	cBody += ImpCab(aPed[1][2], cFornece)
	For xY :=1 To nItens
		aItem := {'','','','','','',''}
		aItem[1] := aPed[xY,3]
		aItem[2] := AllTrim(aPed[xY,4])
		aItem[3] := AllTrim(aPed[xY,5])
		aItem[4] := Transform(aPed[xY,6],"@E 9,999,999.99")
		aItem[5] := Transform((aPed[xY,7]/aPed[xY,6]),"@E 9,999,999.99")
		aItem[6] := Transform(aPed[xY,7],"@E 9,999,999.99")
		aItem[7] := DtoC(aPed[xY,8])
		cBody += ImpItem(aItem)
		nTotPed += aPed[xY,7]
	Next
	aItem := {'','','','','','',''}
	aItem[5] := 'Total Pedido: '
	aItem[6] := Transform(nTotPed,"@E 9,999,999.99")
	cImpItem = ImpItem(aItem)
	cBody += ImpItem(aItem)
		
	cBody += '</table>'
	cTo := ""      
	
cQuery := "SELECT TOP 1 * FROM "+RetSqlName("SCR")
cQuery += " WHERE CR_FILIAL  = '" + xFilial("SCR") +  "' "
cQuery += " AND   CR_NUM     = '" + cPedido  +  "' "
cQuery += " AND   CR_TIPO    = 'PC'                " 
cQuery += " AND   CR_USERLIB = '' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY CR_NIVEL "
DbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),'TMP', .F., .T.)   
DbSelectArea("TMP")
DbGotop()
	
	Do while .not. eof()
		    
		    If Alltrim(TMP->CR_USERLIB) <> ""
		       Dbskip()
		       Loop
		    Endif   
		    
			PswOrder(1)
			if PswSeek(TMP->CR_USER,.T.)
				aUser := PswRet(1)
			Endif
			if !Empty(aUser[1,14])
				If Len(cTo)>1
					cTo += ";"
				EndIf
				cTo += Alltrim(aUser[1,14])
			endif
		
			DBSelectArea("TMP")   // ALCADAS

			DBSkip() 
			
			// Sai porque deve enviar somente para primeiro nivel
			Exit
			
		Enddo

			DBSelectArea("TMP")   // ALCADAS
			Dbclosearea()


		U_ENVIAMAIL(cTo,'',cSubject,cBody)
	
	RestArea(aArea)

Return 

Static Function ImpItem(aItem)
	Local cRet := ''
	cRet += '<tr>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: left; 	border: 1px solid #063;">' + aItem[1] + '</td>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: left; 	border: 1px solid #063;">' + aItem[2] + '</td>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: left; 	border: 1px solid #063;">' + aItem[3] + '</td>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: right; 	border: 1px solid #063;">' + aItem[4] + '</td>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: right; 	border: 1px solid #063;">' + aItem[5] + '</td>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: right; 	border: 1px solid #063;">' + aItem[6] + '</td>'
	cRet += '	<td style="font-family: Verdana, Geneva, sans-serif; font-size: 12px; text-align: center; 	border: 1px solid #063;">' + aItem[7] + '</td>'
	cRet += '</tr>'
Return cRet

Static Function ImpCab(cPed, cFornece)
	Local cRet := ''
	cRet += '	<tr>'
	cRet += '		<th colspan="3" scope="col" style="border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px; border-top-style: none; border-right-style: none; border-bottom-style: solid; border-left-style: none; border-top-color: #063; border-right-color: #063; border-bottom-color: #FFF; border-left-color: #063;">Pedido de Compra: ' +  cPed + '</th>'
	cRet += '		<th colspan="4" scope="col" style="border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px; border-top-style: none; border-right-style: none; border-bottom-style: solid; border-left-style: none; border-top-color: #063; border-right-color: #063; border-bottom-color: #FFF; border-left-color: #063;">Fornecedor: ' +  cFornece + '</th>'
	cRet += '	</tr>'
	cRet += '	<tr style="font-family: Verdana, Geneva, sans-serif; font-size: 14px; font-weight: bold; color: #FFF; background-color: #063; text-align: center;	border: 1px solid #063;">'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Item</th>'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Codigo</th>'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Descricao</th>'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Quant.</th>'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Val.Unit. R$</th>'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Val.Total R$</th>'
	cRet += '		<th scope="col" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #FFF; border-right-color: #FFF; border-bottom-color: #FFF; border-left-color: #063;">Dt Entrega</th>'
	cRet += '	</tr>'
Return cRet
