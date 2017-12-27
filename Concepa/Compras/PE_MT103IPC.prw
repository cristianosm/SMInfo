#include "rwmake.ch"   
#include "protheus.ch"   
                       
User Function MT103IPC

_nLinha 	:= PARAMIXB[1]  
_cDescr 	:= SC7->C7_DESCRI 
_cCtaGer 	:= SC7->C7_CTAGER    
_cGrupo 	:= SC7->C7_GRUPCRI
                             
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_DESCRI"})] := _cDescr
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_CTAGER"})] := _cCtaGer    
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_GRUPCRI"})] := _cGrupo    

Return(.t.)                    
