<?php
require_once("configurations.php");

header("content-type: text/html; charset=UTF-8", true);

$PagSeguroNotificationCode = $_POST["notificationCode"];
$PagSeguroNotificationType = $_POST["notificationType"];

if ($PagSeguroNotificationCode !== "" && $PagSeguroNotificationType === "transaction") {

    $PagSeguroUrlNotification = str_replace("{PagSeguroNotificationCode}", $PagSeguroNotificationCode, $PagSeguroUrlNotification);

	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $PagSeguroUrlNotification);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	$PagSeguroNotificationXML = curl_exec($curl);
	curl_close($curl);

	$PagSeguroNotificationXMLArray = simplexml_load_string($PagSeguroNotificationXML);
	
	$PagSeguroReference = $PagSeguroNotificationXMLArray->transaction->reference;
	$PagSeguroCode = $PagSeguroNotificationXMLArray->transaction->code;
	$PagSeguroStatus = $PagSeguroNotificationXMLArray->transaction->status;

	if ($PagSeguroStatus == 1) {
		$PagSeguroStatusText = "Aguardando";
	} else if ($PagSeguroStatus == 2) {
		$PagSeguroStatusText = "Em análise";
	} else if ($PagSeguroStatus == 3) {
		$PagSeguroStatusText = "Aprovado";
	} else if ($PagSeguroStatus == 4) {
		$PagSeguroStatusText = "Disponível";
	} else if ($PagSeguroStatus == 5) {
		$PagSeguroStatusText = "Em disputa";
	} else if ($PagSeguroStatus == 6) {
		$PagSeguroStatusText = "Devolvida";
	} else if ($PagSeguroStatus == 7) {
		$PagSeguroStatusText = "Cancelada";
	} else if ($PagSeguroStatus == 8) {
		$PagSeguroStatusText = "Chargeback debitado";
	} else if ($PagSeguroStatus == 9) {
		$PagSeguroStatusText = "Em contestação";
	}

    // Logic application...
    
}
?>