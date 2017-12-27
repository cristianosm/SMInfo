#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT097BUT  ºAutor  ³ Valerio           º Data ³  07/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apresenta observacoes memo na aprovacao                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Concepa                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT097BUT()   //SUBSTITUIDO PELO ABAIXO
//User Function MTA094RO()      

dbSelectArea("SC7")
dbSetOrder(1)
DbSeek( xFilial("SC7") + Substr(SCR->CR_NUM,1,6), .F.) 
ccNum := SC7->C7_NUM 
aList := {}

Do while .not. eof()
	If C7_FILIAL + C7_NUM <> xFilial("SC7") + Substr(SCR->CR_NUM,1,6)
		Exit
	Endif                 
	ccObsP01  := Alltrim(MemoLine(SC7->C7_OBSPRO,100,1))
	ccObsP02  := Alltrim(MemoLine(SC7->C7_OBSPRO,100,2))
	ccObsP03  := Alltrim(MemoLine(SC7->C7_OBSPRO,100,3)) 
	ccObsP99  := ccObsP01 + ccObsP02 + ccObsP03  
	
	dbSelectArea("SC7")  
    ccDCta   := ""
    ccDCusto := ""
    
    Dbselectarea("SZG")
    Dbsetorder(1)
    Dbseek( xFilial("SZG") + SC7->C7_CTAGER, .F.)
    If found()
      ccDCta := Alltrim(SC7->C7_CTAGER) + " - " + Alltrim(SZG->ZG_DESCR)
    Endif
    
    Dbselectarea("CTT")
    Dbsetorder(1)
    Dbseek( xFilial("CTT") + SC7->C7_CC, .F.)
    If found()
      ccDCusto := Alltrim(SC7->C7_CC) + " - " + Alltrim(CTT->CTT_DESC01)
    Endif

	dbSelectArea("SC7")  
	
	Aadd(aList, {	C7_ITEM  				,;  //01
					Str(C7_QUANT,12,2)		,;  //02
					C7_UM					,;  //03
					STR(C7_PRECO,14,2)		,;  //04
					STR(C7_TOTAL,14,2)		,;  //05
					Substr(C7_DESCRI,1,30)  ,;  //06
					ccObsP99				,;  //07
					""						,;  //08
					C7_CTAGER				,;  //09
					C7_CC					,;  //10
					ccDCta					,;  //11
					ccDCusto				})  //12

	Dbskip()
	Loop
Enddo 

If Len(aList) = 0
   Msgstop("Nao existem registros para apresentar.")
   Return
Endif
      
Define MsDialog oDlg1 From 000,000 To 550,1110+200 Title "Pedidos " + ccNum  Of oMainWnd Pixel
@ 005,005 Say "" Size 190,10 Of oDlg1 Pixel   
@ 015,005 ListBox oList Fields Header 'Item','CtaGer','C.Custo','Quant','Uni','Preco','Total','Descricao','Observacao item' ;                           
Size 045,250 Pixel Of oDlg1 On dblClick( aList := SQtd(oList:nAt,aList), oList:Refresh())
oList:SetArray(aList)                                                                                                                                        
oList:bLine:={|| { aList[oList:nAt,01],aList[oList:nAt,11],aList[oList:nAt,12],aList[oList:nAt,02], aList[oList:nAt,03],aList[oList:nAt,04],aList[oList:nAt,05],aList[oList:nAt,06], aList[oList:nAt,07],aList[oList:nAt,08] }}
oList:align:=3
oList:Refresh()
//oBtn := tButton():New(255,001,'Observacao completa'   ,oDlg1,{|| Retorna2(),oDlg1:End()} ,45,15,,,,.T.)
oBtn := tButton():New(255,010,'Sair'     ,oDlg1,{|| oDlg1:End()}             ,45,15,,,,.T.)   
Activate MsDialog oDlg1 Centered
Return

Static Function SQtd(nat,aList)  
Return(aList)


