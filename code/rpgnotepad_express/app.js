/**
 * Module dependencies.
 */

// Require express (the web application framework)
var express = require('express');

// Require the crypto module
var crypto = require('crypto');

// Require modules for mongo database connections
var mongoose = require('mongoose');
var mongoStore = require('connect-mongodb');

// Create a variable for our database
var db;

// Require our models
// Require our user models
var userModels = require('./models/user.js');

// Require our routes (controllers)
var routes = require('./routes/index.js');
var testingRoutes = require('./routes/test.js');
var sessionRoutes = require('./routes/sessions.js');
var usersRoutes = require('./routes/users.js');

// Create the server
var app = module.exports = express.createServer();

helpers = require('./helpers.js');

// helpers are...
app.helpers(helpers.helpers);
// dynamic helpers are functions that are run when processing every request
app.dynamicHelpers(helpers.dynamicHelpers);


// Set the db-uri variable for the database
// Set it based on the deployment environment
app.configure('development', function(){
  app.set('db-uri', 'mongodb://localhost/rpg-notepad-development');
});

app.configure('production', function(){
  app.set('db-uri', 'mongodb://localhost/rpg-notepad-production');
});

app.configure('test', function(){
  app.set('db-uri', 'mongodb://localhost/rpg-notepad-test');
});


// Configuration
app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  // Note:
  // Using app.set with one arg acts as a get..
  app.use(express.session({ store: mongoStore(app.set('db-uri')), secret: 'topsecret' }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));

  // Tell the renderer to let us handle the layouts
  // We do this so as we can do more advanced block manipulations in jade.
  // e.g. block append head
  // which wouldn't be possible with the default layout handling
  app.set('view options', {
    layout: false
  });
});

// Error Handling Configuration
app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

app.configure('test', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

/**
  * Define our models, and then connect our database.
  */

// Define our user models
userModels.defineModels(mongoose, function() {
  // assign user and login token vars from the defined models
  app.User = User = mongoose.model('User');
  app.LoginToken = LoginToken = mongoose.model('LoginToken');

  // connect the db
  db = mongoose.connect(app.set('db-uri'));
})

// Standard Routes
app.get('/', userModels.loadUser, routes.index);

// Testing Routes
app.get('/test/unit', testingRoutes.unit_test);
app.get('/test/render', testingRoutes.render_test);

// Sessions Routes
app.get('/sessions/new', sessionRoutes.sessionsNew);
app.post('/sessions', sessionRoutes.sessionsCreate);
app.del('/sessions', userModels.loadUser, sessionRoutes.sessionsDestroy);

// Users Routes

// Process 'create' for a user
app.post('/users.:format?', usersRoutes.userCreate);
// Process 'new' for a user
app.get('/users/new', usersRoutes.userNew);

// Start listening on port 3000
app.listen(3000);
// Log that we're up and running
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
