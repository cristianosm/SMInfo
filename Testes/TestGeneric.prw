
#Include "Totvs.ch"

User Function TestGeneric()

    Local  hexa := 16
    Local  nMExec := Month(dDataBase) 

   cMark := NToC( nMExec , HEXA , NIl, Nil )


    Alert(cMark)
Return 
