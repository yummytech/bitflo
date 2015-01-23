
// These two lines are required to initialize Express in Cloud Code.
var express = require('express');
var parseExpressCookieSession = require('parse-express-cookie-session');
var app = express();

var moment = require('moment');

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(express.bodyParser());    // Middleware for reading request body
app.use(express.cookieParser('83dcb0288ee32cd75c6b1d9c4a3069e1'));
app.use(parseExpressCookieSession({ cookie: { maxAge: 3600000 } }));


// // Example reading from the request query string of an HTTP get request.
// app.get('/test', function(req, res) {
//   // GET http://example.parseapp.com/test?message=hello
//   res.send(req.query.message);
// });

// // Example reading from the request body of an HTTP post request.
// app.post('/test', function(req, res) {
//   // POST http://example.parseapp.com/test (with request body "message=hello")
//   res.send(req.body.message);
// });


  // The homepage renders differently depending on whether user is logged in.
  app.get('/', function(req, res) {
    if (Parse.User.current()) {
       res.redirect('/index');
      
    } else {
      // Render a public welcome page, with a link to the '/login' endpoint.
     res.redirect('/login');
    }
  });
  
   
  app.get('/test', function(req, res) {
    if (Parse.User.current()) {
       res.render('test.ejs', { });
      
    } else {
      // Render a public welcome page, with a link to the '/login' endpoint.
     res.redirect('/login');
    }
  });
  
  
/* ************************************************** INDEX GET/POST *************************************** */

  
  app.post('/index', function(req, res) {
    if (Parse.User.current()) {
       res.redirect('/index');
    } else {
     res.redirect('/login');
    }
  });

app.get('/index', function(req, res) {
	
	    if (Parse.User.current()) {
      // No need to fetch the current user for querying Note objects.

	           var objid = Parse.User.current().toJSON().objectId;
	        
	        	var Usr = Parse.Object.extend("User");
				var query = new Parse.Query(Usr);
				var message;
				var sendresult;
				var wallet;
				
				if(req.query.hasOwnProperty('j')){
					//message = JSON.stringify(req.query);
					message = req.query['j'];
				}
				
				query.get(objid, {
				  success: function(object) {
				    // object is an instance of Parse.Object.
				    usrStr = JSON.stringify(object.toJSON());
						
						  Parse.Cloud.run('showWalletAccountById', {id:object.toJSON().accountid }, {
							    success: function(result) {
							    //console.log("showWalletAccountById" + result);
							    //res.render('home', { message:message ,transactions:transresult.transactions,result:result,sendresult:sendresult});
							    
								    if(typeof result[0] != 'undefined' && result[0] == 'fail'){
										//Their was an Error
										if(result[1] == '503'){
											res.redirect('/logout');
										}else{
										   res.render('index', { message:result[2].error,result:result});	
										}
									}else{
										res.render('home', { message:message ,result:result,sendresult:sendresult,moment:moment});
									}
	
								},
								error: function(error) {
									console.error(error);
									res.redirect('/logout');
								}
							});
				    
				    
				  },
				
				  error: function(object, error) {
				    // error is an instance of Parse.Error.
				   console.error(error);
				   res.redirect('/logout');
				  }
				});
			  
      

    } else {
      // Render a public welcome page, with a link to the '/login' endpoint.
      message = "Please Login";
       res.render('login', { message: message });
    }
});




/* ************************************************** LOGIN GET/POST *************************************** */

  // You could have a "Log In" link on your website pointing to this.
  app.get('/login', function(req, res) {
    // Renders the login form asking for username and password.
    res.render('login.ejs');
  });

  // Clicking submit on the login form triggers this.
  app.post('/login', function(req, res) {
    Parse.User.logIn(req.body.username, req.body.password).then(function() {
      // Login succeeded, redirect to homepage.
      // parseExpressCookieSession will automatically set cookie.
      res.redirect('/index');
    },
    function(error) {
      // Login failed, redirect back to login form.
       res.redirect('/login?&error=' + error.message);
    });
  });

  // You could have a "Log Out" link on your website pointing to this.
  app.get('/logout', function(req, res) {
    Parse.User.logOut();
    res.redirect('/login');
  });
  
    // You could have a "Log Out" link on your website pointing to this.
  app.post('/logout', function(req, res) {
    Parse.User.logOut();
    res.redirect('/login');
  });


/* ************************************************** SEND GET/POST *************************************** */


   
  app.get('/send', function(req, res) {
    if (Parse.User.current()) {
       res.redirect('/index');
      
    } else {
      // Render a public welcome page, with a link to the '/login' endpoint.
     res.redirect('/login');
    }
  });


  // Clicking submit on the login form triggers this.
  app.post('/send', function(req, res) {
  	
  if(Parse.User.current()){
	    var objid = Parse.User.current().toJSON().objectId;
		var Usr = Parse.Object.extend("User");
		var query = new Parse.Query(Usr);
		var sendresult = "";
		var message = "";
		var showWalletAccountByIdResult = "";
					
			query.get(objid, {
			    success: function(object) {
			    	
			    	if(req.body.address != ''){
			    		var address = req.body.address;
			    	}else if(req.body.email != ''){
			    		var address = req.body.address;
			    	}else{
			    		res.redirect('/index?j=A BitCoin or E-Mail address is required. Address');
			    	}
			    	
					Parse.Cloud.run('send', {from:object.toJSON().accountid,to:address,amount:req.body.amount,notes:req.body.notes }, {
					    success: function(result) {
					    	sendresult = result;
							console.log("Results from Send Call:");		
							console.log(sendresult);
							
						 //Let's Grab the users coinbase account info
							Parse.Cloud.run('showWalletAccountById', {id:object.toJSON().accountid }, {
							    success: function(result) {
								// listTransactionsByAccountId
								  showWalletAccountByIdResult = result;
								  console.log("Results from showWalletAccountById Call:");		
								  console.log(showWalletAccountByIdResult);
							
								   res.render('home', { message:message,result:showWalletAccountByIdResult,sendresult:sendresult,moment:moment});
								  
								},
								error: function(error) {
									res.redirect('/index?error=' + error.message);
								}
							});
							
								
						},
						error: function(error) {
							console.log(error);
							res.redirect('/index?error=' + error.message);
						}
					});
					
					
			
			
			 }, error: function(object, error) {
		    // error is an instance of Parse.Error.
		    res.redirect('/index?error=' + error.message);
		  }
		});
	
	} else {
	      //If i can find the current user log them out for security purposes
	       res.redirect('/logout');
	 }	

    
  });

/* ************************************************** REQUEST GET/POST *************************************** */


   
  app.get('/request', function(req, res) {
    if (Parse.User.current()) {
       res.redirect('/index');
      
    } else {
      // Render a public welcome page, with a link to the '/login' endpoint.
     res.redirect('/login');
    }
  });


  // Clicking submit on the login form triggers this.
  app.post('/request', function(req, res) {
  	
  if(Parse.User.current()){
	    var objid = Parse.User.current().toJSON().objectId;
		var Usr = Parse.Object.extend("User");
		var query = new Parse.Query(Usr);
		var sendresult = "";
		var message = "";
		var showWalletAccountByIdResult = "";
					
			query.get(objid, {
			    success: function(object) {
			    	
			    	if(req.body.address != ''){
			    		var address = req.body.address;
			    	}else if(req.body.email != ''){
			    		var address = req.body.address;
			    	}else{
			    		res.redirect('/index?j=A BitCoin or E-Mail address is required. Address');
			    	}
			    	
					Parse.Cloud.run('requestmoney', {id:object.toJSON().accountid,from:req.body.email,amount:req.body.amount,notes:req.body.notes }, {
					    success: function(result) {
					    	sendresult = result;
							console.log("Results from Request Money Call:");		
							console.log(sendresult);
							
						 //Let's Grab the users coinbase account info
							Parse.Cloud.run('showWalletAccountById', {id:object.toJSON().accountid }, {
							    success: function(result) {
								// listTransactionsByAccountId
								  showWalletAccountByIdResult = result;
								  
								if(typeof result[0] != 'undefined' && result[0] == 'fail'){
									//Their was an Error
									res.render('home', { message:result[2].error});
								}else{
									res.render('home', { message:message,result:showWalletAccountByIdResult,sendresult:sendresult,moment:moment});
								}
								   
								  
								},
								error: function(error) {
									res.redirect('/index?error=' + error.message);
								}
							});
							
								
						},
						error: function(error) {
							console.log(error);
							res.redirect('/index?error=' + error.message);
						}
					});
					
					
			
			
			 }, error: function(object, error) {
		    // error is an instance of Parse.Error.
		    res.redirect('/index?error=' + error.message);
		  }
		});
	
	} else {
	      //If i can find the current user log them out for security purposes
	       res.redirect('/logout');
	 }	

    
  });









// Attach the Express app to Cloud Code.
app.listen();
