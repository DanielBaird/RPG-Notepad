/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes/index.js')
  , testing_routes = require('./routes/test.js')

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
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

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Standard Routes

app.get('/', routes.index);

// Testing Routes
app.get('/test/unit', testing_routes.unit_test);
app.get('/test/render', testing_routes.render_test);

app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
