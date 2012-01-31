function setUser(req, res, next) {
  if (req.session.userId) {
    req.app.User.findById(req.session.userId, function(err, user) {
      if (user) {
        req.currentUser = user;
      }
      next();
    });
  } else if (req.cookies.logintoken) {
    setUserFromLoginToken(req, res, next);
  } else {
    next();
  }
}
exports.setUser = setUser;

function setUserFromLoginToken(req, res, next) {
  var cookie = JSON.parse(req.cookies.logintoken);

  req.app.LoginToken.findOne({ email: cookie.email,
                       series: cookie.series,
                       token: cookie.token }, (function(err, token) {
    if (!token) {
      next();
    } else {
      req.app.User.findOne({ email: token.email }, function(err, user) {
        if (user) {
          req.session.userId = user.id;
          req.currentUser = user;

          token.token = token.randomToken();
          token.save(function() {
            res.cookie('logintoken', token.cookieValue, { expires: new Date(Date.now() + 2 * 604800000), path: '/' });
            next();
          });
        } else {
          next();
        }
      });
    }
  }));
}

// Expects setUser to have already been ran against the req.
// Checks if req.currentUser is defined.
//
// If it isn't, redirects user to sessions/new
function authUser(req, res, next) {
  if(req.currentUser === undefined) {
    res.redirect('/sessions/new');
  } else {
    next();
  }
}
exports.authUser = authUser;

/*
 * GET the sessions new page.
 */
exports.sessionsNew= function(req, res){
  res.render('sessions/new', {
    title: 'Login',
    user: new req.app.User()
  });
};

exports.sessionsDestroy= function(req, res){
  if (req.session) {
    req.app.LoginToken.remove({ email: req.currentUser.email }, function() {});
    res.clearCookie('logintoken');
    req.session.destroy(function() {});
  }
  res.redirect('/sessions/new');
};


exports.sessionsCreate= function(req, res) {
  req.app.User.findOne({ email: req.body.user.email }, function(err, user) {
    if (user && user.authenticate(req.body.user.password)) {
      req.session.userId = user.id;

      // Remember me
      if (req.body.remember_me) {
        var loginToken = new req.app.LoginToken({ email: user.email });
        loginToken.save(function() {
          res.cookie('logintoken', loginToken.cookieValue, { expires: new Date(Date.now() + 2 * 604800000), path: '/' });
          req.flash('info', 'Welcome ' + user.email);
          res.redirect('/');
        });
      } else {
        req.flash('info', 'Welcome ' + user.email);
        res.redirect('/');
      }
    } else {
      req.flash('error', 'Incorrect credentials');
      res.redirect('/sessions/new');
    }
  }); 
};

