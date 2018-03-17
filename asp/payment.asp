<!--#include file="configurations.asp"-->

<%
Response.Charset = "UTF-8"
Response.ContentType = "text/html"
Response.CodePage = 65001

PagSeguroPaymentUserMail = ""

PagSeguroPaymentOrderReference = "123456789"

PagSeguroPaymentItemId = "0001"
PagSeguroPaymentItemDescription = "Product Test 0001"
PagSeguroPaymentItemValue = "10.00"
PagSeguroPaymentItemQuantity = "1"

PagSeguroPaymentXML = "<?xml version=""1.0""?>"
PagSeguroPaymentXML = PagSeguroPaymentXML & "<checkout>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "<sender>"
        PagSeguroPaymentXML = PagSeguroPaymentXML & "<email>"& PagSeguroPaymentUserMail &"</email>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "</sender>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "<currency>BRL</currency>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "<items>"
        PagSeguroPaymentXML = PagSeguroPaymentXML & "<item>"
            PagSeguroPaymentXML = PagSeguroPaymentXML & "<id>"& PagSeguroPaymentItemId &"</id>"
            PagSeguroPaymentXML = PagSeguroPaymentXML & "<description>"& PagSeguroPaymentItemDescription &"</description>"
            PagSeguroPaymentXML = PagSeguroPaymentXML & "<amount>"& PagSeguroPaymentItemValue &"</amount>"
            PagSeguroPaymentXML = PagSeguroPaymentXML & "<quantity>"& PagSeguroPaymentItemQuantity &"</quantity>"
        PagSeguroPaymentXML = PagSeguroPaymentXML & "</item>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "</items>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "<redirectURL>"& PagSeguroUrlRedirect &"</redirectURL>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "<reference>"& PagSeguroPaymentOrderReference &"</reference>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "<receiver>"
        PagSeguroPaymentXML = PagSeguroPaymentXML & "<email>"& PagSeguroMailAuthentication &"</email>"
    PagSeguroPaymentXML = PagSeguroPaymentXML & "</receiver>"
PagSeguroPaymentXML = PagSeguroPaymentXML & "</checkout>"

Set XmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP")
XmlHttp.open "POST", PagSeguroUrlCheckout, False
XmlHttp.setRequestHeader "content-type", "application/xml; charset=ISO-8859-1"
XmlHttp.send PagSeguroPaymentXML
PagSeguroCheckoutXML = XmlHttp.responseText
Set XmlHttp = Nothing

Set ObjXMLDOM = Server.CreateObject("Microsoft.XMLDOM")
ObjXMLDOM.Async = False
ObjXMLDOM.LoadXml(PagSeguroCheckoutXML)
PagSeguroCheckoutCode = ObjXMLDOM.selectSingleNode("checkout/code").Text
Set ObjXMLDOM = Nothing
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pagamento básico com o PagSeguro</title>

<script type="text/javascript" src="<%=PagSeguroLightboxScript%>"></script>
<script type="text/javascript">
function PagSeguroOpenLightbox (PagSeguroCheckoutCode) {
    var isOpenLightbox = PagSeguroLightbox({
            code: PagSeguroCheckoutCode
        }, {
            success : function(transactionCode) {
                alert("success - " + transactionCode);
            },
            abort : function() {
                alert("abort");
            }
        });
    if (!isOpenLightbox) {
        location.href = PagSeguroUrlPaymentMobile.replace("PagSeguroTransactionCode", PagSeguroCheckoutCode);
    }
}
</script>

</head>
<body>

<button onclick="PagSeguroOpenLightbox('<%=PagSeguroCheckoutCode%>');">Pagar!</button>

</body>
</html>