<?php
require_once("configurations.php");

header("content-type: text/html; charset=UTF-8", true);

$PagSeguroPaymentUserMail = "";

$PagSeguroPaymentOrderReference = "123456789";

$PagSeguroPaymentItemId = "0001";
$PagSeguroPaymentItemDescription = "Product Teste 0001";
$PagSeguroPaymentItemValue = "10.00";
$PagSeguroPaymentItemQuantity = "1";

$PagSeguroPaymentXML = "<?xml version=\"1.0\"?>";
$PagSeguroPaymentXML .= "<checkout>";
    $PagSeguroPaymentXML .= "<sender>";
        $PagSeguroPaymentXML .= "<email>$PagSeguroPaymentUserMail</email>";
    $PagSeguroPaymentXML .= "</sender>";
    $PagSeguroPaymentXML .= "<currency>BRL</currency>";
    $PagSeguroPaymentXML .= "<items>";
        $PagSeguroPaymentXML .= "<item>";
            $PagSeguroPaymentXML .= "<id>$PagSeguroPaymentItemId</id>";
            $PagSeguroPaymentXML .= "<description>$PagSeguroPaymentItemDescription</description>";
            $PagSeguroPaymentXML .= "<amount>$PagSeguroPaymentItemValue</amount>";
            $PagSeguroPaymentXML .= "<quantity>$PagSeguroPaymentItemQuantity</quantity>";
        $PagSeguroPaymentXML .= "</item>";
    $PagSeguroPaymentXML .= "</items>";
    $PagSeguroPaymentXML .= "<redirectURL>$PagSeguroUrlRedirect</redirectURL>";
    $PagSeguroPaymentXML .= "<reference>$PagSeguroPaymentOrderReference</reference>";
    $PagSeguroPaymentXML .= "<receiver>";
        $PagSeguroPaymentXML .= "<email>$PagSeguroMailAuthentication</email>";
    $PagSeguroPaymentXML .= "</receiver>";
$PagSeguroPaymentXML .= "</checkout>";

$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, $PagSeguroUrlCheckout);
curl_setopt($curl, CURLOPT_HTTPHEADER, array("content-type: application/xml", "charset: ISO-8859-1"));
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $PagSeguroPaymentXML);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
$PagSeguroCheckoutXML = curl_exec($curl);
curl_close($curl);

$PagSeguroCheckoutXMLArray = simplexml_load_string($PagSeguroCheckoutXML);
$PagSeguroCheckoutCode = $PagSeguroCheckoutXMLArray->code;
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pagamento básico com o PagSeguro</title>

<script type="text/javascript" src="<?=$PagSeguroLightboxScript?>"></script>
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

<button onclick="PagSeguroOpenLightbox('<?=$PagSeguroCheckoutCode?>');">Pagar!</button>

</body>
</html>