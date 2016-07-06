#include 'protheus.ch'
#include 'parmtype.ch'

User function TWsdlManager_SM()
//|Detalhes: http://tdn.totvs.com/display/tec/Acesso+a+Web+Services+que+exigem+certificados+de+CA|
// U_TWsdlManager_SM()
  Local lRet    := Nil
  Local cMsg    := ""
  Local oWsdl   := Nil
  Local cMsgRet := ""

  oWsdl := TWsdlManager():New()
  oWsdl:cSSLCACertFile := "\CSM\000001_ca.pem"
  oWsdl:cSSLCertFile   := "\CSM\000001_cert.pem"
  oWsdl:cSSLKeyFile    := "\CSM\000001_key.pem"
  oWsdl:cSSLKeyPwd     := "FISCAL2015" //se necessário
  oWsdl:nSSLVersion    := 1
  oWsdl:nTimeout       := 120

  xRet := oWsdl:ParseURL("https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl")
  if xRet == .F.
    conout("Erro ParseURL: " + oWsdl:cError)
    Return
  endif

  // Define a operação
  lRet := oWsdl:SetOperation("nfeDownloadNF")
  If lRet == .F.
    conout("Erro SetOperation: " + oWsdl:cError)
    return
  EndIf

  // Mensagem enviada com namespace de SOAP 1.1, que dará erro, pois, como o WSD possui SOAP 1.1 e 1.2, a classe utilizará SOAP 1.2
  // cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nfed="http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF">' + CRLF
  // cMsg += '    <soapenv:Header>' + CRLF
  // cMsg += '       <nfed:nfeCabecMsg>' + CRLF
  // cMsg += '          <nfed:versaoDados>1.00</nfed:versaoDados>' + CRLF
  // cMsg += '          <nfed:cUF>31</nfed:cUF>' + CRLF
  // cMsg += '       </nfed:nfeCabecMsg>' + CRLF
  // cMsg += '    </soapenv:Header>' + CRLF
  // cMsg += '    <soapenv:Body>' + CRLF
  // cMsg += '       <nfed:nfeDadosMsg>' + CRLF
  // cMsg += '          <downloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe"><tpAmb>1</tpAmb><xServ>DOWNLOAD NFE</xServ><CNPJ>86501400000104</CNPJ><chNFe>31150502806413000274550010000074971000042278</chNFe></downloadNFe>' + CRLF
  // cMsg += '       </nfed:nfeDadosMsg>' + CRLF
  // cMsg += '    </soapenv:Body>' + CRLF
  // cMsg += '</soapenv:Envelope>'

  // Mesma mensagem que a anterior, mas com namespace de SOAP 1.2
  cMsg := '<soapenv:Envelope xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope" xmlns:nfed="http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF">' + CRLF
  cMsg += '   <soapenv:Header>' + CRLF
  cMsg += '      <nfed:nfeCabecMsg>' + CRLF
  cMsg += '          <nfed:versaoDados>1.00</nfed:versaoDados>' + CRLF
  cMsg += '          <nfed:cUF>31</nfed:cUF>' + CRLF
  cMsg += '       </nfed:nfeCabecMsg>' + CRLF
  cMsg += '    </soapenv:Header>' + CRLF
  cMsg += '    <soapenv:Body>' + CRLF
  cMsg += '       <nfed:nfeDadosMsg>' + CRLF
  cMsg += '          <downloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe"><tpAmb>1</tpAmb><xServ>DOWNLOAD NFE</xServ><CNPJ>88912613001278</CNPJ><chNFe>31150502806413000274550010000074971000042278</chNFe></downloadNFe>' + CRLF
  cMsg += '       </nfed:nfeDadosMsg>' + CRLF
  cMsg += '    </soapenv:Body>' + CRLF
  cMsg += '</soapenv:Envelope>'

  // Envia uma mensagem SOAP personalizada ao servidor
  lRet := oWsdl:SendSoapMsg( cMsg )
  If lRet == .F.
    conout( "Erro SendSoapMsg: " + oWsdl:cError )
    conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
    Return
  EndIf

  cMsgRet := oWsdl:GetSoapResponse()
  conout( cMsgRet )

return()