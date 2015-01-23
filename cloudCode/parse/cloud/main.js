
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

require('cloud/app.js');

//var crypto = require("cloud/hmac-sha256.js");
var crypto = require("crypto");
var base_url = 'https://api.coinbase.com/v1/';
//var base_url = 'https://coinbase.com/api/v1/';

//AllynAlford@gmail.com Coinbase keys
//var base_api_key = 'UZ8VgttSFHLiFmYk';
//var base_api = 'iPaStfQMgBA97eEzJxeZ25HUCqXIO5OM';



var base_api_key = 'Zgou7qurlB8ZnfHp';
var base_api = 'h6HKiSDQooKDksjUjXqoldxHky6dYAcK';

Parse.Cloud.define("noncecheck", function (request, response) {
    var nonce = String(Date.now() * 1e6);
    response.success(nonce);
});


Parse.Cloud.define("addTrans", function (request, response) {
	
	  var Trans = Parse.Object.extend("Trans");
	  var trans = new Trans();
	  //trans.setACL(custom_acl);
	  trans.id = 'idtest';
	  trans.accountid = 'accountidtest';
	  trans.data = 'datatest';
	  //trans.set('id','idtest');
	  //trans.set('accountid','accountidtest');
	  //trans.set('data','datatest');
	  //trans.add('id','idtest');
	  //trans.add('accountid','accountidtest');
	  //trans.add('data','datatest');
	  trans.save(null, {
			  success: function(result) {
			  	console.log(result);
			   response.success(result);
			  },
			  error: function(result, error) {
			  	console.error(error);
			   response.success(error);
			  }
			});
});



Parse.Cloud.define("transfer", function (request, response) {

    var dt = new Date();


    var parameters = {
        "account_id" : request.params.from,
        "transaction": {
            "to": request.params.to,
            "amount": request.params.amount,
            "notes": request.params.notes,
            "user_fee": '0.0001'
        }
    }
    
    var params = JSON.stringify(parameters);

    //console.log('params: ' + params);

    //var nonce = dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);

    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'transactions/transfer_money' + params;
     //console.log('message: ' + message);

   
    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);

     

    Parse.Cloud.httpRequest({
        method: "POST",
        url: base_url + 'transactions/transfer_money',
        body: params,
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
                     console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});



Parse.Cloud.define("PullFromMerchant", function (request, response) {

    var dt = new Date();



    var parameters = {
        "account_id": request.params.from,
        "transaction": {
            "to": request.params.to,
            "amount": request.params.amount,
            "notes": request.params.notes,
            "user_fee": '0.0001'
        }
    }

    var params = JSON.stringify(parameters);

    //console.log('params: ' + params);

    //var nonce = dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);
   // console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'transactions/send_money' + params;
    //console.log('message: ' + message);


    var signature = crypto.createHmac("sha256", request.params.srt).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({
        method: "POST",
        url: base_url + 'transactions/send_money',
        body: params,
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': request.params.key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});


Parse.Cloud.define("send", function (request, response) {

    var dt = new Date();



    var parameters = {
        "account_id": request.params.from,
        "transaction": {
            "to": request.params.to,
            "amount": request.params.amount,
            "notes": request.params.notes,
            "user_fee": '0.0001'
        }
    }

    var params = JSON.stringify(parameters);

    //console.log('params: ' + params);

    //var nonce = dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'transactions/send_money' + params;
    //console.log('message: ' + message);

 
    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);

    


    Parse.Cloud.httpRequest({
        method: "POST",
        url: base_url + 'transactions/send_money',
        body: params,
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});



Parse.Cloud.define("createuser", function (request, response) {

    var dt = new Date();



    var parameters = {"user": {
            "email": request.params.email,
            "password": request.params.pswrd
        }
    }

    var params = JSON.stringify(parameters);

    //console.log('params: ' + params);

    //var nonce = dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'users' + params;
    //console.log('message: ' + message);


    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({
        method: "POST",
        url: base_url + 'users',
        body: params,
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});


Parse.Cloud.define("createwalletaccount", function (request, response) {

    var dt = new Date();



    var parameters = {"account": {
            "name": request.params.accountname
        }
    }

    var params = JSON.stringify(parameters);

    //console.log('params: ' + params);

    //var nonce = dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);

    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'accounts' + params;
    //console.log('message: ' + message);


    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({
        method: "POST",
        url: base_url + 'accounts',
        body: params,
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});




Parse.Cloud.define("balance", function (request, response) {

    var dt = new Date();

    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'accounts/'+ request.params.id +'/balance';
    //console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);

    


    Parse.Cloud.httpRequest({

        url: base_url + 'accounts/'+ request.params.id +'/balance',
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});


Parse.Cloud.define("currentuser", function (request, response) {

    var dt = new Date();

    //var nonce =  dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'users/self';
    //console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({

        url: base_url + 'users/self',
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});

Parse.Cloud.define("listaccounts", function (request, response) {

    var dt = new Date();

   // var nonce = dt.getSeconds() + (60 * dt.getMinutes()) + (60 * 60 * dt.getHours()); // TODO smarter nonce
    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'accounts';
    //console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({

        url: base_url + 'accounts',
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});


Parse.Cloud.define("accountbalance", function (request, response) {

    var dt = new Date();

    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'accounts/' + request.params.id + '/balance';
    //console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({

        url: base_url + 'accounts/' + request.params.id + '/balance',
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            //          response.success(httpResponse.text);
            //var json = JSON.parse(response.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});

Parse.Cloud.define("showWalletAccountById", function (request, response) {

    var dt = new Date();

    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);

    var message = nonce + base_url + 'accounts/' + request.params.id;
    //console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({

        url: base_url + 'accounts/' + request.params.id,
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});

Parse.Cloud.define("listTransactionsByAccountId", function (request, response) {

    var dt = new Date();
    
    
    var parameters = {"account_id" : request.params.id}
    
     
 
    var params = JSON.stringify(parameters);
    

    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);
    
    var message = nonce + base_url + 'transactions?account_id=' + request.params.id;
    //var message = nonce + base_url + 'transactions';
    //console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({

        url: base_url + 'transactions?account_id=' + request.params.id,
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});

Parse.Cloud.define("getBitCoinAddressByAccountId", function (request, response) {

    var dt = new Date();

    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);
    
    var message = nonce + base_url + 'accounts/' + request.params.id + '/address';
    //accounts/536a541fa9393bb3c7000034/address
   console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({

        url: base_url + 'accounts/' + request.params.id + '/address',
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});

Parse.Cloud.define("requestmoney", function (request, response) {

    var dt = new Date();
    
    var parameters = {
    				 "account_id": request.params.id,
  					 "transaction": {
    				 				"from": request.params.from,
   					 				"amount": request.params.amount,
   					 				"notes": request.params.notes
  									}
					 }
    
     
 
    var params = JSON.stringify(parameters);
    

    var nonce = String(Date.now() * 1e6);
    //console.log('nonce: ' + nonce);
    
    var message = nonce + base_url + 'transactions/request_money' + params;
    //accounts/536a541fa9393bb3c7000034/address
   console.log('message: ' + message);

    var signature = crypto.createHmac("sha256", base_api).update(message).digest("hex");

    //console.log('signature: ' + signature);




    Parse.Cloud.httpRequest({
		method: "POST",
        url: base_url + 'transactions/request_money',
        body: params,
        headers: {

            'Content-Type': 'application/json;charset=utf-8',
            'Accept': '*/*',
            'ACCESS_KEY': base_api_key,
            'ACCESS_SIGNATURE': signature,
            'ACCESS_NONCE': nonce,
            'User-Agent': 'BitFlo'
        },
        success: function (httpResponse) {
            console.log(httpResponse.text);
            response.success(httpResponse.data);
        },
        error: function (httpResponse) {
            var failer = new Array();
            failer[0] = "fail";
            failer[1] = httpResponse.status;
            failer[2] = httpResponse.text;
            response.success(failer);
        }
    });
});


