#include 'protheus.ch'
#include 'parmtype.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFunc  บAutor  ณCristiano Machado   บ Data ณ  10/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Executa Qualquer Funcao e mantem as ultimas 10 executados บฑฑ
ฑฑบ          ณordenadas.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*********************************************************************
User Function ExecMyFunc()//| Executa Qualquer Fun็ใo   Autor: Cristiano Machado   Data: 10/05/2011
*********************************************************************
	Private lContinua 	:= .T.
	Private cLastRun 	:= GetProfString( Lower("ExecMy_"+ GetComputerName()), "LastRun"		, "undefined", .T.)

	If cLastRun == "undefined"
		cLastRun := ""
	EndIf

	While lContinua
		MontaTela()

		WriteProfString( Lower("ExecMy_"+ GetComputerName()), "LastRun"		,cLastRun	,.T.)

	EndDo

Return()
*********************************************************************
Static Function MontaTela()
*********************************************************************
	Static oJanela
	Static oButton
	Static oGet
	Static oGroup
	Static oRadOpc
	Static oSay

	Private cAuxRun 	:= cLastRun
	Private lTrue 		:= .T.

	Private  nRadOpc := 1
	Private  cFunc 	:= Space(20)


	DEFINE MSDIALOG oJanela TITLE "New Dialog" FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL

	@ 004, 003 GROUP oGroup TO 050, 147 PROMPT "Executa Fun็๕es " 		   									OF oJanela COLOR  0, 16777215 	PIXEL
	@ 023, 047 MSGET oGet VAR cFunc SIZE 094, 016 	PICTURE "@E"							   				OF oJanela COLORS 0, 16777215 	PIXEL
	@ 023, 007 RADIO oRadOpc VAR nRadOpc ITEMS "Usuario","Sistema" SIZE 031, 019 							OF oJanela COLOR  0, 16777215 	PIXEL
	@ 013, 003 SAY oSay PROMPT "Tipo Fun็ใo" 	SIZE 034, 007 												OF oJanela COLORS 0, 16777215 	PIXEL
	@ 013, 046 SAY oSay PROMPT "Fun็ใo" 		SIZE 021, 007 												OF oJanela COLORS 0, 16777215 	PIXEL

	fDBTree()

	@ 055, 004 BUTTON oButton PROMPT "Executa" 	ACTION (oJanela:End() , Executa()       ) SIZE 046,012	OF oJanela 				   		PIXEL
	@ 055, 099 BUTTON oButton PROMPT "Sair" 	ACTION (oJanela:End() , lContinua := .F.) SIZE 046,012	OF oJanela 				   		PIXEL

	ACTIVATE MSDIALOG oJanela CENTERED


Return()
*********************************************************************
Static Function fDBTree()
*********************************************************************
	Static oRunTree
	True 	:= .T.
	nCount 	:= 1

	oRunTree := DbTree():New(004,155,068,245,oJanela,,,.T.)//fDBTree()
	oRunTree:AddItem(PadR("Ultimas Exec",15," "),"001", "FOLDER5" ,,,,1)

	While lTrue

		nPos := At(',',cAuxRun)
		nCount	+= 1
		If nPos <= 0
			lTrue := .F.
			Loop
		Endif

		cAuxFunc	:= 	PadR(Substr(cAuxRun,1,nPos - 1),15," ")
		cAuxCont	:= 	StrZero(nCount,3)

		oRunTree:AddItem(cAuxFunc ,cAuxCont, "FOLDER6",,,,2)

		cAuxRun	:= Substr(cAuxRun,nPos + 1)

	EndDo

	oRunTree:EndTree()

Return()
*********************************************************************
Static Function Executa()
*********************************************************************
	cFunc :=  Alltrim(cFunc)

	If Empty(cFunc)
		cFunc := Alltrim(oRunTree:GetPrompt(.T.))
	EndIf

	If nRadOpc == 1
		cFunc :=  "U_" + cFunc
	EndIf

	If At("(",cFunc) <= 0
		cFunc := cFunc + "()"
	EndIF

	&cFunc.

	Alert( " Fim da Execu็ใo da Rotina "+ cFunc )

	AtuUltFun() //| Atualiza Ultimas Funcoes Executadas

Return()
*********************************************************************
Static Function AtuUltFun()
*********************************************************************
	nVir := 0
	nPos := At("U_", cFunc )
	If nPos > 0
		cFunc :=  Substr(cFunc,3)
	EndIf

	nPos := At("(",	cFunc )
	If nPos > 0
		cFunc := Substr(cFunc,1,nPos-1)
	EndIF

	nPos := At(cFunc, cLastRun )


	If nPos <= 0
		cLastRun := cFunc + "," + cLastRun
	Else
		cLastRun := cFunc+ "," + Substr(cLastRun,1,nPos - 1) + Substr(cLastRun,nPos + Len(cFunc) + 1)
	EndIf

	nPos := 0
	For N := 1 To Len(cLastRun)

		If Substr(cLastRun,N,1) == ","
			nVir += 1
		Endif

		If nVir == 11
			nPos := N
			Exit
		EndIf

	Next

	If nPos <> 0
		cLastRun := Substr(cLastRun,1,nPos - 1)
	EndIf

	cFunc := ""

Return()