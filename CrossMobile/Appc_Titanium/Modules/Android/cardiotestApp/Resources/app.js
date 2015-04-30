// open a single window
var win = Ti.UI.createWindow({
	backgroundColor : 'white'
});
var label = Ti.UI.createLabel();
label.text = "card details not received";
win.add(label);
win.open();

// TODO: write your module tests here
var codestrong_android = require('com.ashish.cardioandroid');
Ti.API.info("module is => " + JSON.stringify(codestrong_android.LCAT, null, 2));


var proxy = codestrong_android.createCardio({
	"APP_TOKEN" : "cardioscanninghefre123456789",
	"REQUIRE_EXPIRY" : true,
	"REQUIRE_CVV" : true,
	"REQUIRE_ZIP" : false,
	"SUPPRESS_MANUAL_ENTRY" : false,
	"KEEP_APPLICATION_THEME" : true

});

label.addEventListener("click",function(){
	proxy.doScan({
	success : function(resp) {
		alert(resp + "ashish");
		Ti.API.info(' back in success');
		var s = JSON.stringify(resp, null, 2);
		label.text = s;
	},
	error : function(resp) {
		alert(resp + "nigam");
		var s = JSON.stringify(resp, null, 2);
		label.text = s;
	},
	cancel : function(resp) {
		alert(resp + "nigam- canceleed");
		var s = JSON.stringify(resp, null, 2);
		label.text = s;
	}
});
});

