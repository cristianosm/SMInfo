#include 'protheus.ch'
#include 'parmtype.ch'

//|Detalhes: http://tdn.totvs.com/display/tec/Acesso+a+Web+Services+que+exigem+certificados+de+CA|
// https://www.webdanfe.com.br/danfe/WebDanfeApi.aspx


*******************************************************************************
User function TWsdlManager_SM()
	*******************************************************************************

	Private lRet    	:= Nil
	Private cXml    	:= ""  //| Monta a Estrutura do XML.
	Private oWsdl   	:= Nil
	Private cXmlRet 	:= ""
	Private oXmlRet 	:= ""
	Private cXmlError 	:= ""
	Private cXmlWarning := ""

	OP_NfeConsultaDest("L") //| Lista

	OP_NfeDownloadNF("N") //| Nota

	Return()
	*******************************************************************************
Static Function OP_NfeConsultaDest(cQuem)
	*******************************************************************************

	oWsdl := TWsdlManager():New()
	oWsdl:cSSLCACertFile := "\csm\000001_ca.pem"
	oWsdl:cSSLCertFile   := "\csm\000001_cert.pem"
	oWsdl:cSSLKeyFile    := "\csm\000001_key.pem"
	oWsdl:cSSLKeyPwd     := "FISCAL" //se necessario
	oWsdl:nSSLVersion    := 1
	oWsdl:nTimeout       := 120

	//| Sefaz-RS
	xRet := oWsdl:ParseURL("https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx?wsdl")
	If xRet == .F.
		conout("Erro ParseURL: " + oWsdl:cError)
		Return()
	Endif

	// Define a operacao
	lRet := oWsdl:SetOperation("nfeConsultaNFDest") //--> Operacao do WS
	If lRet == .F.
		conout("Erro SetOperation: " + oWsdl:cError)
		return
	EndIf
	cXml := cQuem
	MontaXml( @cXml ) //| Monta a estrutura do XML conforme layout

	//cXml := U_Caixa(cXml)

	// Envia uma mensagem SOAP personalizada ao servidor
	lRet := oWsdl:SendSoapMsg( cXml )
	If lRet == .F.
		conout( "Erro SendSoapMsg: " + oWsdl:cError )
		conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
	EndIf

	cXmlRet := oWsdl:GetSoapResponse()

	oXmlRet := XmlParser (cXmlRet, "", @cXmlError, @cXmlWarning )

	U_CaixaTexto (VarInfo( "OBJETO" , oXmlRet , /*nMargem*/ , lHtml := .F. , lEcho := .F. ))

	Return()
	*******************************************************************************
Static Function OP_NfeDownloadNF(cQuem)
	*******************************************************************************

	oWsdl := TWsdlManager():New()
	oWsdl:cSSLCACertFile := "\csm\000001_ca.pem"
	oWsdl:cSSLCertFile   := "\csm\000001_cert.pem"
	oWsdl:cSSLKeyFile    := "\csm\000001_key.pem"
	oWsdl:cSSLKeyPwd     := "FISCAL" //se necessario
	oWsdl:nSSLVersion    := 1
	oWsdl:nTimeout       := 120

	//| Sefaz-RS
	xRet := oWsdl:ParseURL("https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx?wsdl")
	If xRet == .F.
		conout("Erro ParseURL: " + oWsdl:cError)
		Return()
	Endif

	// Define a operacao
	lRet := oWsdl:SetOperation("nfeDownloadNF") //--> Operacao do WS
	If lRet == .F.
		conout("Erro SetOperation: " + oWsdl:cError)
		return
	EndIf

	cXml := cQuem
	MontaXml( @cXml ) //| Monta a estrutura do XML conforme layout

	//cXml := U_Caixa(cXml)

	// Envia uma mensagem SOAP personalizada ao servidor
	lRet := oWsdl:SendSoapMsg( cXml )
	If lRet == .F.
		conout( "Erro SendSoapMsg: " + oWsdl:cError )
		conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
	EndIf

	cXmlRet := oWsdl:GetSoapResponse()

	oXmlRet := XmlParser (cXmlRet, "", @cXmlError, @cXmlWarning )

	U_CaixaTexto (VarInfo( "OBJETO" , oXmlRet , /*nMargem*/ , lHtml := .F. , lEcho := .F. ))

	return()
	*******************************************************************************
Static Function MontaXml( cXml )
	*******************************************************************************
	//| SOAP 1.2

	If cXml == "L" // Lista

		cXml := '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:nfec="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest">' + CRLF
		cXml += '   <soap:Header>' 																	+ CRLF
		cXml += '      <nfec:nfeCabecMsg>' 															+ CRLF
		cXml += '         <nfec:cUF>43</nfec:cUF>' 													+ CRLF
		cXml += '         <nfec:versaoDados>1.01</nfec:versaoDados>' 								+ CRLF
		cXml += '      </nfec:nfeCabecMsg>' 														+ CRLF
		cXml += '   </soap:Header>' 																+ CRLF
		cXml += '   <soap:Body>' 																	+ CRLF
		cXml += '      <nfec:nfeDadosMsg>' 															+ CRLF
		cXml += '         <consNFeDest versao="1.01" xmlns="http://www.portalfiscal.inf.br/nfe" >' 	+ CRLF
		cXml += '	   	  <tpAmb>1</tpAmb>' 														+ CRLF
		cXml += '	   	  <xServ>CONSULTAR NFE DEST</xServ>' 										+ CRLF
		cXml += '	   	  <CNPJ>88613922001278</CNPJ>' 												+ CRLF
		cXml += '	   	  <indNFe>0</indNFe>' 														+ CRLF
		cXml += '	   	  <indEmi>1</indEmi>' 														+ CRLF
		cXml += '	   	  <ultNSU>0</ultNSU>' 														+ CRLF
		cXml += '	   </consNFeDest>' 																+ CRLF
		cXml += '      </nfec:nfeDadosMsg>' 														+ CRLF
		cXml += '    </soap:Body>' 																	+ CRLF
		cXml += '</soap:Envelope>' 																	+ CRLF

	ElseIf cXml == "N" // NF

		cXml := '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:nfed="http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF">' + CRLF
		cXml += '	<soap:Header>' + CRLF
		cXml += '		<nfed:nfeCabecMsg>' + CRLF
		cXml += '			<nfed:cUF>43</nfed:cUF>' + CRLF
		cXml += '			<nfed:versaoDados>1.01</nfed:versaoDados>' + CRLF
		cXml += '		</nfed:nfeCabecMsg>' + CRLF
		cXml += '	</soap:Header>' + CRLF
		cXml += '	<soap:Body>' + CRLF
		cXml += '		<nfed:nfeDadosMsg>' + CRLF
		cXml += '          <downloadNFe versao="1.01" xmlns="http://www.portalfiscal.inf.br/nfe">' + CRLF
		cXml += '				<tpAmb>1</tpAmb>' + CRLF
		cXml += '				<xServ>DOWNLOAD NFE</xServ>' + CRLF
		cXml += '				<CNPJ>88613922001278</CNPJ>' + CRLF
		cXml += '				<chNFe>43160608029317000162550010000116621000116622</chNFe>' + CRLF
		cXml += '				</downloadNFe>' + CRLF
		cXml += '       </nfed:nfeDadosMsg>' + CRLF
		cXml += '    </soap:Body>' + CRLF
		cXml += '</soap:Envelope>' + CRLF

	EndIF

Return ( cXml )