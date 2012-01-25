
/*
 * GET unit test page.
 */

exports.unit_test = function(req, res){
  res.render('unit_test', { layout: false, title: 'Unit Test' })
};

/*
 * GET render test page.
 */

exports.render_test = function(req, res){
  res.render('render_test', { layout: false, title: 'Render Test' })
};
