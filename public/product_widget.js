var product_widget = document.getElementById('product_widget');
var account_id = product_widget.getAttribute('data-current-account-id');
var app_host = product_widget.getAttribute('data-app-host');
var product_id_field = document.getElementById('product_id');

var script = document.createElement('script');
script.src = 'http://'+app_host+'/widget_jsonp_data.js';
document.documentElement.appendChild(script);

var url = window.location.href;
var matches = url.match(/product_id=([^&]*)/);
var id = matches[1];
script.onload = function() {
getId(id, account_id, app_host, function(res) {
  var res_id = JSON.parse(res).product.id;
  product_id_field.innerHTML = res_id;
  });
};
