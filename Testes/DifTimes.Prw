#Include "Totvs.ch"






User Function DifTimes()



cTimeI := Time()

Sleep(1000)

cTimeF := Time()

nDifTime := ElapTime( cTimeI, cTimeF )

Alert("Diferenša:" + cValToChar( nDifTime) )


Return Nil
