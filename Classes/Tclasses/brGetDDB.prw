#include 'totvs.ch'
 
user function brGetDDB()
 
  local oDlg := nil
 
  DEFINE DIALOG oDlg TITLE "Exemplo BrGetDDB" FROM 180, 180 TO 550, 700 PIXEL   
 
    dbSelectArea('SA1')  
    oBrowse := BrGetDDB():new( 1,1,260,184,,,,oDlg,,,,,,,,,,,,.F.,'SA1',.T.,,.F.,,, )  
    oBrowse:addColumn( TCColumn():new( 'Codigo', { || SA1->A1_COD  },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Loja', { || SA1->A1_LOJA },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Nome', { || SA1->A1_NOME },,,, 'LEFT',, .F., .F.,,,, .F. ) )
 
  ACTIVATE DIALOG oDlg CENTERED
 
return nil