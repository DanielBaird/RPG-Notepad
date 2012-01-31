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
    req.LoginToken.remove({ email: req.currentUser.email }, function() {});
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

