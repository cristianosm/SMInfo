#include 'protheus.ch'

*******************************************************************************
User Function e_thread()
*******************************************************************************

  Local lret := .F.
  
  Local cName := "U_E_IniJob" 	//| Indica o nome do Job que será executado.
  Local cEnv  := GetEnvServer() //| Indica o nome do ambiente em que o Job será executado.
  Local lWait := .F. 			//| Indica se, verdadeiro (.T.), o processo será finalizado; caso contrário, falso (.F.).
  Local Par01 := lWait			 //| Os parâmetros (máximo 25 parâmetros) informados a partir deste ponto serão repassados para a função especificada no parâmetro cName. Caso informados parâmetros do tipo B (Code-Block) ou O (Object), no processo de destino receberá
  Local Par02 := Nil			 //| Os parâmetros (máximo 25 parâmetros) informados a partir deste ponto serão repassados para a função especificada no parâmetro cName. Caso informados parâmetros do tipo B (Code-Block) ou O (Object), no processo de destino receberá
  
  
  Par01 := lWait := .F.
  
  Conout(" TESTE - Chamada do StartJob com lWait = .F. - " + Time() )
  lret := StartJob( cName, cEnv , lWait , Par01, Par02 )
  Conout(" TESTE - Apos Chamada do StartJob com lWait = .F. " + Time() )
  
  
  Par01 := lWait := .T.
  
  Conout(" TESTE - Chamada do StartJob com lWait = .T. - " + Time() )
  lret := StartJob( cName, cEnv , lWait , Par01, Par02 )
  Conout(" TESTE - Apos Chamada do StartJob com lWait = .F. " + Time() )
   
   
   
Return Nil
*******************************************************************************
User function e_IniJob(Par01)
*******************************************************************************

	Local nSeg := 5
	Local nFat := 1000
	Local cTxt := "TESTE - Dentro do StarJob, lWait: "+cValToChar(Par01)+" - " + Time() 

	Sleep( nSeg * nFat )
	conout(cTxt)

Return .T.