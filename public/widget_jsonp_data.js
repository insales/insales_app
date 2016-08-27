function getId(id, account_id, app_host, callback) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (xhttp.readyState == 4 && xhttp.status == 200) {
      callback(xhttp.responseText);
    }
  };
  xhttp.open("GET", "http://"+app_host+"/api/v1/insales_products/"+id+"?account_id="+account_id, true);
  xhttp.send();
}
