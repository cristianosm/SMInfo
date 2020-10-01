#Include 'Protheus.ch'

 
User Function TOperPrev(sData)

    dDataBase := STod("2020" + sData)

    cRet := StaticCall( IAPREVEN , MntOp )

    Do Case 
        Case cRet == "D"
            cRet := "Diario" 
         Case cRet == "S"
            cRet := "Semanal" 
         Case cRet == "M"
            cRet := "Mensal" 
         Case cRet == "N"
            cRet := "Nao Executa" 
        OtherWise
            cRet := "Invalido"
    End Case

    Alert("Retorno: " + cRet)

Return 
