<!--#include file="configurations.asp"-->

<%
Response.Charset = "UTF-8"
Response.ContentType = "text/html"
Response.CodePage = 65001

PagSeguroNotificationCode = request.form("notificationCode")
PagSeguroNotificationType = request.form("notificationType")

If PagSeguroNotificationCode <> "" And PagSeguroNotificationType = "transaction" Then

    PagSeguroUrlNotification = Replace(PagSeguroUrlNotification, "{PagSeguroNotificationCode}", PagSeguroNotificationCode)

	Set XmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP")
	XmlHttp.open "GET", PagSeguroUrlNotification, False
	XmlHttp.send
	PagSeguroNotificationXML = XmlHttp.responseText
	Set XmlHttp = Nothing

	Set XmlDom = Server.CreateObject("Microsoft.XMLDOM")
	XmlDom.Async = False
	XmlDom.LoadXml(PagSeguroNotificationXML)
	PagSeguroReference = XmlDom.selectSingleNode("transaction/reference").Text
	PagSeguroCode = XmlDom.selectSingleNode("transaction/code").Text
	PagSeguroStatus = XmlDom.selectSingleNode("transaction/status").Text
	Set XmlDom = Nothing

	If Status = 1 Then
		PagSeguroStatusText = "Aguardando"
	ElseIf Status = 2 Then
		PagSeguroStatusText = "Em análise"
	ElseIf Status = 3 Then
		PagSeguroStatusText = "Aprovado"
	ElseIf Status = 4 Then
		PagSeguroStatusText = "Disponível"
	ElseIf Status = 5 Then
		PagSeguroStatusText = "Em disputa"
	ElseIf Status = 6 Then
		PagSeguroStatusText = "Devolvida"
	ElseIf Status = 7 Then
		PagSeguroStatusText = "Cancelada"
	ElseIf Status = 8 Then
		PagSeguroStatusText = "Chargeback debitado"
	ElseIf Status = 9 Then
		PagSeguroStatusText = "Em contestação"
	End If

    ' Logic application...
    
End If
%>