/*
Copyright 2015 AppSoft - Fabrica de Software

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#Include "Protheus.ch"
#Include "AppExcel.ch"
*******************************************************************************
User Function tstExcel()
*******************************************************************************

	Local oExcel 	:= nil
	Local oCell1 	:= nil
	Local oCell2 	:= nil
	Local oCell3 	:= nil
	Local oCellF1 	:= nil
	Local oCellF2 	:= nil
	Local oCellA1 	:= nil
	Local oCellA2 	:= nil

	Local oFont1B 	:= nil

	//instancia do objeto
	oExcel := AppExcel():New()

	//objeto das celulas
	oCell1 := AppExcCell():New()
	oCell2 := AppExcCell():New()
	oCell3 := AppExcCell():New()

	oCell4 := AppExcCell():New()

	oCellF1 := AppExcCell():New()
	oCellF2 := AppExcCell():New()

	oCellA1	:= AppExcCell():New()
	oCellA2	:= AppExcCell():New()

	//Configuração das fontes
	oFont1 := AppExcFont():New("Arial","16","#363636")
	oFont1:SetBold(.T.)

	//personalização das celulas
	oCell1:SetCellColor("#696969")

	oCell2:SetABorders(.T.)
	oCell2:SetALineBorders(BORDER_LINE_DOT)

	oCell3:SetFont( oFont1 )

	oCell4:SetBorder(BORDER_POSITION_TOP	, .T.)
	oCell4:SetBorder(BORDER_POSITION_BOTTOM	, .T.)
	oCell4:SetLineBorder(BORDER_POSITION_BOTTOM	, BORDER_LINE_DOUBLE)
	oCell4:SetCellColor("#66CDAA")

	oCellF1:SetFormat(NUMBER_CURRENCY_REAL)
	oCellF2:SetFormat(NUMBER_CURRENCY_RED_REAL)

	oCellA1:SetHorzAlign( HORIZONTAL_ALIGN_CENTER )
	oCellA2:SetVertAlign( VERTICAL_ALIGN_CENTER )

	//adiciona linhas a aba atual, com a configuração de celulas padrão
	oExcel:AddCell(1,1,"Celula 1-1",oCell1)
	oExcel:AddCell(1,2,"Celula 1-2",oCell1)
	oExcel:AddCell(1,3,"Celula 1-3",oCell1)
	oExcel:AddCell(2,1,"Celula 2-1",oCell1)
	oExcel:AddCell(6,1,"Celula 6-1",oCell1)
	oExcel:AddCell(3,1,"Celula 3-1",oCell1)

	//adiciona uma nova aba
	oExcel:AddSheet("Nova Sheet")

	//adiciona linhas na aba atual
	oExcel:AddCell(1,1,"No Format")
	oExcel:AddCell(2,1,MsDate())

	//adiciona uma nova aba
	oExcel:AddSheet("Border sheet")

	//adiciona linha na planilha com celulas com borda (objeto criado acima)
	oExcel:AddCell(1,1,"Top",oCell1)
	oExcel:AddCell(1,2,"All",oCell2)

	oExcel:AddCell(2,1,"Top",oCell1)
	oExcel:AddCell(2,2,"All",oCell2)

	oExcel:AddCell(5,2,"Teste",oCell4)

	//adiciona uma nova linha
	oExcel:AddSheet("Teste Font")

	//adiciona uma nova linha
	oExcel:AddCell(1,1,"Teste",oCell3)

	//adiciona uma nova linha
	oExcel:AddSheet("Caracteres especiais")
	oExcel:AddCell(1,1,"A->")
	oExcel:AddCell(1,2,"ã")
	oExcel:AddCell(1,3,"à")
	oExcel:AddCell(1,4,"á")
	oExcel:AddCell(1,5,"ä")
	oExcel:AddCell(1,6,"Ã")
	oExcel:AddCell(1,7,"À")
	oExcel:AddCell(1,8,"Á")
	oExcel:AddCell(1,9,"Ä")

	oExcel:AddCell(2,1,"E->")
	oExcel:AddCell(2,2,"è")
	oExcel:AddCell(2,3,"é")
	oExcel:AddCell(2,4,"ë")
	oExcel:AddCell(2,5,"È")
	oExcel:AddCell(2,6,"É")
	oExcel:AddCell(2,7,"Ë")

	oExcel:AddSheet("Teste Merge")

	oExcel:AddCell(1,1,"Celula 1-1",oCell1)
	oExcel:Merge( 1, 2, 6, 0)
	oExcel:Merge( 3, 2, 6, 1)
	oExcel:Merge( 6, 2, 6, 1,"Teste",oCell2)
	oExcel:Merge( 2, 1, 0, 6,"Teste Down",oCell3)

	oExcel:AddSheet("Teste Format")
	oExcel:AddCell(1,1,2.3,oCellF1)
	oExcel:AddCell(1,2,-2.3,oCellF1)
	oExcel:AddCell(2,1,2.3,oCellF2)
	oExcel:AddCell(2,2,-2.3,oCellF2)

	oExcel:AddSheet("Teste Align")
	oExcel:AddCell(1,1,"A1",oCellA1)
	oExcel:AddCell(1,2,"A2",oCellA2)

	//gera a planilha excel
	oExcel:Make()

	//apresenta a planilha gerada
	oExcel:OpenXML()

	oExcel:Destroy()

Return
*******************************************************************************
User Function TstExcStress()
*******************************************************************************

	Local oExcel := AppExcel():New("Stress Test")
	Local nX	 := 0
	Local nY	 := 0


	//objeto das celulas
	Local oCell1 := AppExcCell():New()
	Local oCell2 := AppExcCell():New()

	//Configuração das fontes
	Local oFont1 := AppExcFont():New("Arial","12","#000000")

	Local lCellPainted := .F.

	oCell1:SetABorders(.T.)
	oCell1:SetCellColor("#808080")
	oCell1:SetFont(oFont1)

	oCell2:SetABorders(.T.)
	oCell2:SetFont(oFont1)

	For nX := 1 to 1000

		For nY := 1 to 1000

			If lCellPainted
				oExcel:AddCell(nX,nY,"Row: " + cValToChar(nX) + " Col: " + cValToChar(nY), oCell1)
			Else
				oExcel:AddCell(nX,nY,"Row: " + cValToChar(nX) + " Col: " + cValToChar(nY), oCell2)
			EndIf

		Next

		lCellPainted := !lCellPainted
	Next

  	//gera a planilha excel
	oExcel:Make()

	//apresenta a planilha gerada
	oExcel:OpenXML()

	Alert("Verifique a memória utilizada")

	oExcel:Destroy()

	Alert("Verifique novamente")

Return()
*******************************************************************************
User Function tstIndex()
*******************************************************************************

	Local oExcel := AppExcel():New("Stress Test")

	oExcel:AddCell(1 ,1,"Row 1 Col 1" )
	oExcel:AddCell(1 ,2,"Row 1 Col 2" )
	oExcel:AddCell(3 ,2,"Row 3 Col 2" )
	oExcel:AddCell(3 ,8,"Row 3 Col 8" )
	oExcel:AddCell(3 ,9,"Row 3 Col 9" )
	oExcel:AddCell(5 ,1,"Row 5" )
	oExcel:AddCell(10,1,"Row 10")
	oExcel:AddCell(20,1,"Row 20")

	oExcel:SetHorzFrozen(1)
	oExcel:SetVertFrozen(1)

  	//gera a planilha excel
	oExcel:Make()

	//apresenta a planilha gerada
	oExcel:OpenXML()

Return()