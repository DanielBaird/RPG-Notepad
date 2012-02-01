
/*
 * GET /games.
 */
exports.index = function(req, res){
  res.render('games/index.jade', { title: 'RPG Notepad - Games' })
};
