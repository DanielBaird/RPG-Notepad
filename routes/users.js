/*
 * GET the users new page.
 */
exports.userNew = function(req, res){
  res.render('users/new.jade', {
    title: 'New User',
    user: new req.app.User()
  });
};

exports.userCreate = function(req, res) {
  var user = new req.app.User(req.body.user);

  function userSaveFailed() {
    req.flash('error', 'Account creation failed');
    res.render('users/new.jade', {
      title: 'New User',
      locals: { user: user }
    });
  }

  user.save(function(err) {
    if (err) return userSaveFailed();

      req.flash('info', 'Your account has been created');
//      emails.sendWelcome(user);

    switch (req.params.format) {
      case 'json':
        res.send(user.toObject());
      break;

      default:
        req.session.userId = user.id;
        res.redirect('/');
    }
  });
};
