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

	Private cAss		:= ""


	OP_NfeConsultaDest("L") //| Lista

	OP_NfeDownloadNF("N") //| Nota

	CaixaTexto( "Tag Xml para formar Assinatura", @cXml )

	cAss := Assinatura(cXml)

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

	CaixaTexto ( VarInfo( "OBJETO" , oXmlRet , /*nMargem*/ , lHtml := .F. , lEcho := .F. ) )

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

	CaixaTexto ( VarInfo( "OBJETO" , oXmlRet , /*nMargem*/ , lHtml := .F. , lEcho := .F. ) )

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
*********************************************************************
Static Function CaixaTexto( cTitulo, cTexto )
*********************************************************************

	Default cMail := ""

	__cFileLog := MemoWrite(Criatrab(,.F.)+".log",cTexto)

	Define FONT oFont NAME "Tahoma" Size 6,12
	Define MsDialog oDlgMemo Title cTitulo From 3,0 to 340,550 Pixel

	@ 5,5 Get oMemo  Var cTexto MEMO Size 265,145 Of oDlgMemo Pixel
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	//Define SButton  From 153,205 Type 6 Action Send(cTexto)   Enable Of oDlgMemo Pixel
	Define SButton  From 153,245 Type 1 Action oDlgMemo:End() Enable Of oDlgMemo Pixel

	Activate MsDialog oDlgMemo Center

Return()
*******************************************************************************
Static Function Assinatura(cXml)
*******************************************************************************
	Local cRUI	:= ObtemRefUI(cXml)  	//| Monta Chave RUI
	Local cDVl	:= DigestValue(cXml) 	//| Monta DigestValue
	Local cSVl	:= SignatValeu(cXml) 	//| Signature Value
	Local cX50  := X509Cert(cXml)		//| X509 Certificate

	cXml := '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
	cXml += '	<SignedInfo>'
	cXml += '   	<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />'
	cXml += '       <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />'
	cXml += '       <Reference URI="'+cRUI+'">'
	cXml += '       	<Transforms>
	cXml += '       		<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>'
	cXml += '           	<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
	cXml += '       	</Transforms>'
	cXml += '       	<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>'
	//           			<!--> ->>> Deve ser aplicada na Tag <InfEvento> :-->
	cXml += '           	<DigestValue>'+cDVl+'</DigestValue>'
	cXml += '       </Reference>'
	cXml += '	</SignedInfo>'
	cXml += '   <SignatureValue>'+cSVl+'</SignatureValue>'
	cXml += '   	<KeyInfo>'
	cXml += '       	<X509Data>'
	cXml += '           	<X509Certificate>'+cX50+'</X509Certificate>'
	cXml += '           </X509Data>'
	cXml += '		</KeyInfo>'
	cXml += '	</Signature>'

Return(cXml)
*******************************************************************************
Static Function ObtemRefUI(cXml)
*******************************************************************************

Return('')
*******************************************************************************
Static Function DigestValue(cXml)
*******************************************************************************
Local cXmlC14N 	:= ""
Local cError	:= ""
local cWarning 	:= ""
Local cDigest	:= ""
Local cEnco64	:= ""

	//Esta função permite aplicar o algoritmo canonicalization C14N na string que contém um XML.
	cXmlC14N := XmlC14N( cXml, cOption:="", @cError, @cWarning )
	Iw_MsgBox( cXmlC14N , "XML apos Canonical XmlC14N","INFO")

	//SHA1 (Secure Hash Algorithm) gera o hash (ou digest) de um conteúdo, com base no algoritmo definido em FIPS PUB 180-1 published April 17, 1995.
	cDigest := SHA1( cXmlC14N, nRetType := 2 )
	Iw_MsgBox( cDigest , "XML apos Digest","INFO")

	//Converte uma string texto ou binária (Contendo caracteres da tabela ASCII) para uma nova string codificada segundo o padrão BASE64
	cEnco64 := Encode64( cDigest )
	Iw_MsgBox( cEnco64 , "XML apos Encode64","INFO")


Return(cEnco64)
*******************************************************************************
Static Function SignatValeu(cXml)
*******************************************************************************

Return('')
*******************************************************************************
Static Function X509Cert(cXml)
*******************************************************************************


Return('')