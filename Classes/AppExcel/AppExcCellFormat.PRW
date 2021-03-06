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

#Include "Totvs.ch"                 
#Include "AppExcel.ch"
                 

/*/{Protheus.doc} AppExcCellFormat
Classe respons�vel por gerenciar os formatos da c�lula 
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type class
/*/
CLASS AppExcCellFormat FROM LongClassName
	DATA nFormat AS INTEGER

	//Class Properties
	DATA cClassName AS STRING HIDDEN         
                                                
	METHOD New( nTypeFormat ) CONSTRUCTOR
	METHOD HasFormat()
	METHOD SetFormat( nTypeFormat )      
	METHOD GetFormat( )      
	METHOD FormatToString()         
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()

ENDCLASS                  
  
/*/{Protheus.doc} AppExcCellFormat:New
M�todo construtor da classe AppExcCellFormat
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type constructor
@param nFormat, inteiro, c�digo do formato a ser utilizado, os formatos suportados s�o:|ul||li|NUMBER_CURRENCY_REAL		-> Numero formato moeda em R$|/li||li|NUMBER_CURRENCY_RED_REAL    -> Numero formato moeda em R$, negativos em vermelho|/li||/ul|
/*/
METHOD New( nTypeFormat ) CLASS AppExcCellFormat
	DEFAULT nTypeFormat := 0             
	
	::cClassName := "AppExcCellFormat"

	::nFormat	:= nTypeFormat 

RETURN     
  
   

/*/{Protheus.doc} AppExcCellFormat:HasFormat
M�todo para indicar se algum formato foi especificado
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@type method
@version 1.0                        
@return, l�gico, indica se algum formato foi especificado
/*/
METHOD HasFormat() CLASS AppExcCellFormat
RETURN ::nFormat > 0
  
                                                         
/*/{Protheus.doc} AppExcCellFormat:SetFormat
M�todo para alterar o formato
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nFormat, inteiro, c�digo do formato a ser utilizado, os formatos suportados s�o:|ul||li|NUMBER_CURRENCY_REAL		-> Numero formato moeda em R$|/li||li|NUMBER_CURRENCY_RED_REAL    -> Numero formato moeda em R$, negativos em vermelho|/li||/ul|
/*/
METHOD SetFormat( nTypeFormat ) CLASS AppExcCellFormat
	::nFormat := nTypeFormat
RETURN
  
   

/*/{Protheus.doc} AppExcCellFormat:GetFormat
M�todo de acesso para obter o formato da c�lula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return, inteiro, retorna o identificador da formata��o
/*/
METHOD GetFormat( ) CLASS AppExcCellFormat
RETURN ::nFormat
                                                       
  
  
/*/{Protheus.doc} AppExcCellFormat:FormatToString
Serializa��o da formata��o da c�lula para o padr�o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, n�mero da linha que ser� serializada
@return caractere, String contendo a formata��o da c�lula especificada no padr�o XML
/*/
METHOD FormatToString( ) CLASS AppExcCellFormat
	Local cStringFormat := ""       

	If ::HasFormat()
		cStringFormat := GetStringFormat( ::nFormat )                    
	EndIf

RETURN cStringFormat             

       
/*/{Protheus.doc} AppExcCellFormat:ClassName
M�todo respons�vel por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@type method
@version 1.0     
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcCellFormat
RETURN ::cClassName

  
/*/{Protheus.doc} AppExcCellFormat:Destroy
M�todo destrutor do objeto, respons�vel pela desaloca��o da mem�ria
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
/*/
METHOD Destroy() CLASS AppExcCellFormat  
	FreeObj(self)
RETURN 

 
/*/ GetStringFormat
Fun��o est�tica para convers�o do identificador da formata��o com a string utilizada pelo XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014                                                                                  
@version 1.0                                                                                       
@type function
@param, inteiro, identificador da forma��o
@return, caractere, string utilizada pelo XML Excel
/*/
Static Function GetStringFormat( nFormat )       
	Local cFormat := ""
	                          
	Do Case
		Case nFormat == NUMBER_CURRENCY_REAL
	   		cFormat := '<NumberFormat ss:Format="&quot;R$&quot;\ #,##0.00"/>'
	   	Case nFormat == NUMBER_CURRENCY_RED_REAL   
	   		cFormat := '<NumberFormat ss:Format="&quot;R$&quot;\ #,##0.00;[Red]&quot;R$&quot;\ #,##0.00"/>'
	EndCase      

Return cFormat