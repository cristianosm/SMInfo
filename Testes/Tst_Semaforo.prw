#Include 'Protheus.ch'

#DEFINE SEMAFORO 'IDUNICOTESTE'
 
User Function Tst_Semaforo()

  StartJob("U_ipcjobs",GetEnvServer(),.F.)

  StartJob("U_ipcjobs",GetEnvServer(),.F.)
   
  Sleep( 7000 )
   
  IPCGo( SEMAFORO, "Data atual " + cvaltochar(date()) )
   
Return()
 

User Function ipcjobs()

  Local cPar

  while !killapp()
    lRet := IpcWaitEx( SEMAFORO, 5000, @cPar )

    If lRet
      conout(cPar)
      exit
    endif
  
  enddo

Return()