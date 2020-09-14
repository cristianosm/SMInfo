#include "protheus.ch"
#include "fwmvcdef.ch"


#define MVC_VIEWDEF_NAME "VIEWDEF.MVCSOGRID"

// Define aHeadGrid
#Define AH_CPO  1 // Campo
#Define AH_TIP  2 // Tipo
#Define AH_TAM  3 // Tamanho
#Define AH_DEC  4 // Decimal 

*******************************************************************************
User function ILOTEZD(cAlias, cTitulo) // Função principal da Inclusão em LOTE ZD1 - Item Referencia 
*******************************************************************************

Private  oView as object    // View
Private oModel as object    // Model
Private nTotRegis := 0      // Total Registros Grid
Private aHeadGrid := {}     // Array Header do Grid 
Private MVC_ALIAS := cAlias
Private MVC_TITLE := cTitulo


//Inserção - Inclusão de itens
FWExecView( getTitle(MODEL_OPERATION_INSERT), MVC_VIEWDEF_NAME, MODEL_OPERATION_INSERT)

//Visualização - Verificar os itens incluídos
//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)

//Alteração - Por ser um grid, a alteração já vai permitir a exclusão
//FWExecView( getTitle(MODEL_OPERATION_UPDATE), MVC_VIEWDEF_NAME, MODEL_OPERATION_UPDATE)

//Visualização - Verificar os itens adicionados, alterados ou excluidos
//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)


Return Nil
*******************************************************************************
Static function getTitle(nOperation) //Retorna o título para a janela MVC, conforme operação
*******************************************************************************
local cTitle as char

if nOperation == MODEL_OPERATION_INSERT
    cTitle := "Inclusão em Lote"
elseif nOperation == MODEL_OPERATION_UPDATE
    cTitle := "Alteração"
else
    cTitle := "Visualização"
endif

Return cTitle

*******************************************************************************
Static function ModelDef() //Montagem do modelo dados para MVC
*******************************************************************************
//local oModel as object
local oStrField as object
local oStrGrid as object

Local bRegis := {|oModel,nTotalAtual,xValor,lSomando| CalcTot(oModel,nTotalAtual,xValor,lSomando)}

Local cCpoTot := Iif( MVC_ALIAS == "ZD1","ZD1_TNDPF","ZD0_CVVRIT" )  

// Estrutura Fake de Field
oStrField := FWFormModelStruct():New()

oStrField:addTable("", {"C_STRING1"}, MVC_TITLE, {|| ""})
oStrField:addField("String 01", "Campo de texto", "C_STRING1", "C", 15)

//Estrutura de Grid, alias Real presente no dicionário de dados
oStrGrid := FWFormStruct(1, MVC_ALIAS, { |X| U_SX3CoCpo(X,"X3_FOLDER") == '1' }  )
oModel := MPFormModel():New("ZDLOTE", /*bPre*/, /*bPost*/ , /*bCommit */, /*bCancel*/ )

oModel:addFields("CABID", /*cOwner*/, oStrField, /*bPre*/, /*bPost*/, {|oMdl| loadHidFld()})

oModel:addGrid("GRIDID", "CABID", oStrGrid, /*bLinePre*/,  /*bLinePost*/, /*bPre*/,  /*bPost*/, /*{|oMdl| loadGrid(oMdl)}*/ )

oModel:AddCalc('TREGISID', 'CABID', 'GRIDID', cCpoTot, 'TREGIS', 'FORMULA',bRegis,    ,'Total Registros' , bRegis)

oModel:setDescription(MVC_TITLE)

// É necessário que haja alguma alteração na estrutura Field
oModel:setActivate({ |oModel| onActivate(oModel)})

return oModel
*******************************************************************************
Static function onActivate(oModel) // Função estática para o activate do model
*******************************************************************************
   

//Só efetua a alteração do campo para inserção
if oModel:GetOperation() == MODEL_OPERATION_INSERT
    FwFldPut("C_STRING1", "FAKE" , /*nLinha*/, oModel)
endif

return
/*
*******************************************************************************
static function loadGrid(oModel) //Função estática para efetuar o load dos dados do grid
*******************************************************************************

local aData as array
local cAlias as char
local cWorkArea as char
local cTablename as char

cWorkArea := Alias()
cAlias := GetNextAlias()
cTablename := "%" + RetSqlName(MVC_ALIAS) + "%"

BeginSql Alias cAlias
    SELECT *, R_E_C_N_O_ RECNO
      FROM %exp:cTablename%
    WHERE D_E_L_E_T_ = ' '
EndSql

aData := FwLoadByAlias(oModel, cAlias, MVC_ALIAS, "RECNO", lCopy, .T.)

(cAlias)->(DBCloseArea())

if !Empty(cWorkArea) .And. Select(cWorkArea) > 0
    DBSelectArea(cWorkArea)
endif

Return aData
*/
*******************************************************************************
Static function loadHidFld(oModel) //Função estática para load dos dados do field escondido
*******************************************************************************

Return {""}
*******************************************************************************
static function viewDef() //Função estática do ViewDef
*******************************************************************************
//local oView as object
//local oModel as object
local oStrCab as object
local oStrGrid as object
Local oStrRegis as object
Local oStrValid as object
Local oStrInval as object

// Estrutura Fake de Field
oStrCab := FWFormViewStruct():New()

oStrCab:addField("C_STRING1", "01" , "String 01", "Campo de texto", , "C" )

//Estrutura de Grid
oStrGrid := FWFormStruct(2, MVC_ALIAS, { |X| U_SX3CoCpo(X,"X3_FOLDER") == '1' }  )


//oStrGrid:GetFields()
For n := 1 To Len(oStrGrid:aFields)
     If !oStrGrid:aFields[N][16] == .T. // Campo Virtual não adiciona... 
        cCpo := oStrGrid:aFields[N][1]
        AAdd( aHeadGrid ,  { cCpo , U_SX3CoCpo(cCpo,"X3_TIPO") , U_SX3CoCpo(cCpo,"X3_TAMANHO"), U_SX3CoCpo(cCpo,"X3_DECIMAL") }  )

    EndIf
Next 

oModel := FWLoadModel("MVCSOGRID")
oView := FwFormView():New()

oView:setModel(oModel)
oView:addField("CAB", oStrCab, "CABID")
oView:addGrid("GRID", oStrGrid, "GRIDID")
oView:createHorizontalBox("TOHIDE", 0 )
oView:createHorizontalBox("TOSHOW", 90 )
oView:CreateHorizontalBox("REGTOT", 10 )

oView:CreateVerticalBox("BOX_REG_VAZIO", 80, "REGTOT")
oView:CreateVerticalBox("BOX_REG_TOTAL", 20, "REGTOT")
//oView:CreateVerticalBox("BOX_REG_VALID", 20, "REGTOT")
//oView:CreateVerticalBox("BOX_REG_INVAL", 20, "REGTOT")

oStrRegis := FWCalcStruct( oModel:GetModel( 'TREGISID') ) // Total Registros 
//oStrValid := FWCalcStruct( oModel:GetModel( 'TVALIDID') ) // Total Validos
//oStrInval := FWCalcStruct( oModel:GetModel( 'TINVALID') ) // Total Invalidos

oView:AddField( 'TREGISVIEW', oStrRegis, 'TREGISID' )
//oView:AddField( 'TVALIDVIEW', oStrValid, 'TVALIDID' )
//oView:AddField( 'TINVALVIEW', oStrInval, 'TINVALID' )

oView:setOwnerView("CAB", "TOHIDE" )
//oView:setOwnerView("GRID", "TOSHOW")
oView:setOwnerView("GRID", "TOSHOW")

oView:setOwnerView("TREGISID", "BOX_REG_TOTAL")
//oView:setOwnerView("TVALIDID", "BOX_REG_VALID")
//oView:setOwnerView("TINVALID", "BOX_REG_INVAL")

oView:addUserButton("Importar Arquivo", "", {|| LocArqIR() } , "Importa arquivo para Cadastro em Lote", Nil , Nil, .T.)
oView:setDescription( MVC_TITLE )

return oView
*******************************************************************************
User Function SX3CoCpo(idSx3,cCampX3)// Retorna o Conteudo SX3 de um campo especifico 
*******************************************************************************
    Local aAreaAtu := GetArea()
    Local xConteudo := Nil 

    Default idSx3 := "B1_FILIAL"
    Default cCampX3 := "X3_ARQUIVO"

    DbSelectArea("SX3")
    xConteudo := SX3->( RetField('SX3',2, idSx3 ,cCampX3 ) )

    RestArea(aAreaAtu)

Return xConteudo
*******************************************************************************
Static Function LocArqIR()// Obtem Local do Arquivo... 
*******************************************************************************
    Local aPergs   	:= {}
    Local aRet	   	:= {}
    Local cArq     	:= padr("",150)
	
	Local cDrive	:= ""
	Local cDiretorio:= ""
	Local cNome		:= ""
	Local cExtensao	:= ""

	Local cFile 	:= ""

	aAdd( aPergs ,{6,"Arquivo: ",cArq,"",,"", 90 ,.T.,"Arquivos .csv |*.csv","C:\",GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE})

	If ParamBox(aPergs ,"Lote de Cadastro Item Referência ", @aRet)

		SplitPath( aRet[1], @cDrive, @cDiretorio, @cNome, @cExtensao ) 

        cFile := Alltrim( cDrive + cDiretorio + cNome + cExtensao ) 

		CarArqIR(cFile)// Carrega Arquivo Item Referencia... 

    Else
        Aviso("Processo cancelado")
    EndIf 

Return              
*******************************************************************************
Static Function CarArqIR(cFile)// Carrega Arquivo para Grid
*******************************************************************************
    
    Local nTFile	:=	0 	// Tamanho Arquivo em Linhas... 
    Local aCabArq   := {}   // Linha em Array do Cabecalho
    Local aDetArq   := {}   // Linha em Array dos Detalhes do Arquivo
    Local nPAFile   := 0    // Posicao atual no arquivo... 
    Local lValid    := .T.
    Local oGrid     := oModel:GetModel('GRIDID')

    Private aCabFxHeaG := {} // Array de Relacionamento entre aHeader e aCabFile 

    nTotRegis += 1 // O Grid já tras uma linha
    
    OpenFile(cFile, @nTFile) // Abre o Arquivo

    // Percorre Arquivo... 
	FT_FGoTop()
	While !FT_FEOF() 

        oModel  := FWModelActive()
	    oView  	:= FWViewActive()
        oGrid   := oModel:GetModel('GRIDID')

        AjusLin(@aCabArq, @aDetArq, @nPAFile) 	

        For nC := 1 To Len(aHeadGrid)
           
            If aCabFxHeaG[nC] > 0 // So adiciona campos com relacionamento... 

                cCpo        := aHeadGrid[nC][AH_CPO]
                cConteudo   := Iif( aHeadGrid[nC][AH_TIP]=="N" , Val( cValToChar(aDetArq[aCabFxHeaG[nC]]) ) , cValToChar( aDetArq[aCabFxHeaG[nC]]) )

               lValAtrib := oModel:SetValue( 'GRIDID', cCpo , cConteudo )
            EndIf

        Next

        lValid := oGrid:VldLineData(.F.) // Valida a Linha do Grid preenchida... 
        If !lValid
            //nTotInval += 1
            oGrid:DeleteLine() // Caso não Valida Deleta a Linha ...
        Else
            //nTotValid += 1
        EndIf       

        iF nPAFile < nTFile // So adiciona linhas caso necessario...
            oGrid:AddLine()
            nTotRegis += 1
        EndIf

        oView:Refresh()
        oView:Refresh('GRIDID')
       
        FT_FSKIP()

    EndDo 
    oModel  := FWModelActive()
	oView  	:= FWViewActive()
    oGrid   := oModel:GetModel('GRIDID')
    oView:Refresh()
    oView:Refresh('GRIDID')
    oGrid:GoLine(1)

    FT_FUse() // Fecha o Arquivo...

Return 
*******************************************************************************
Static Function OpenFile(cFile, nTFile) // Carrega o Arquivo pra Memória ....
*******************************************************************************

	Local lOk := .F.
	
	Default nTFile := 0
	
	//ConOut(cFileEN + cFile)
	nHandle := FT_FUse(Alltrim(cFile))
	
	If nHandle > 0 // Valida Abertura ... 
		nTFile 	:= FT_FLastRec()
		lok 	:= .T.
	EndIf

Return lok

*******************************************************************************
Static Function  AjusLin(aCabArq, aDetArq, nPAFile) 	
*******************************************************************************
    Local aFline := {}
    Local cFLine := ""


        If nPAFile == 0 // Deve Carregar Cabecalho...
            cFLine := FT_FReadLn() // Leitura da Linha no CSV
		    cFLine := StrTran( cFLine, '"', '', ) // Remove ASPAS do arquivo...
		    cFLine := StrTran( cFLine, ',', '.', ) // Troca (Virgula) por (Ponto) nos Decimais...
		    aFline := StrToKarr(cFLine, ";") // Converte linha em Array
            aCabArq := aFline
            nPAFile += 1
            FT_FSKIP()

            RelFiHEad(aCabArq) // Relaciona o Arquivo com o HEader do Grid 
        
        EndIf

        // Carga da Linha do Arquivo e tratamentos... 
		cFLine  := FT_FReadLn() // Leitura da Linha no CSV
		cFLine := StrTran( cFLine, '"', '', ) // Remove ASPAS do arquivo...
		cFLine := StrTran( cFLine, ',', '.', ) // Troca (Virgula) por (Ponto) nos Decimais...
		aFline := StrToKarr(cFLine, ";") // Converte linha em Array
        aDetArq := aFline
        nPAFile += 1

Return Nil
*******************************************************************************
Static Function RelFiHEad(aCabArq)// Alimenta Array com Relacao entre Header Grid e Cabecalho Arquivo 
*******************************************************************************
    
    aCabFxHeaG := {}

    For nR := 1 To Len(aHeadGrid)

       // If Len(aCabArq) >= nR
            nPos := AScan(aCabArq, aHeadGrid[nR][AH_CPO] )

            If At( "GETSXENUM", U_SX3CoCpo(aHeadGrid[nR][AH_CPO],"X3_RELACAO") ) > 0   // Campos de AUTO INCREMENTO nao alimenta... 
                nPos := 0
            EndIf

       // Else
            
       //     nPos := 0
        
       // EndIf
        
        Aadd(aCabFxHeaG, nPos)
        
    Next

Return Nil
*******************************************************************************
Static Function CalcTot(oModel,nTotalAtual,xValor,lSomando)
*******************************************************************************
    //Local nRetTot := 0
    oGrid       := oModel:GetModel('GRIDID')

    nTotRegis   := oGrid:GetQTDLine()

    //If cQuem == "TREGIS"
    //    nRetTot := nTotRegis
    //ElseIf cQuem == "TVALID"
    //    nRetTot := nTotValid 
    //ElseIf cQuem == "TINVAL"
    //    nRetTot := nTotInval
    //EndIf
    oView  	:= FWViewActive()
    //oView:Refresh()
    //oView:Refresh('GRIDID')
    oView:Refresh( 'TREGISID' )

Return nTotRegis
*******************************************************************************
User Function ZDLOTE()// PE para a Model...
*******************************************************************************

	local aparam := PARAMIXB
	local lRet   := .T.
	
	//Alert("Exec: " + aParam[2])
	If aParam <> NIL
		//Alert(aParam[2] )
		If Alltrim( aParam[2] ) == "FORMCOMMITTTSPOS"
            Alert(aParam[2] )
			//U_CaixaTexto(VarInfo("aparam",aparam))
			U_CompD0D1("ZD1", aparam)
		EndIf
		
	EndIf
	
Return lRet 
