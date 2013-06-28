// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
    factory('Character', function($resource) {
      var Character = $resource('https://api.mongolab.com/api/1/databases' +
          '/rpg_notepad/collections/characters/:id',
          { apiKey: 'l5TeN9zjV9nEqvD_xrRMgAfjuLag2Ceq' }, {
            update: { method: 'PUT' }
          }
      );

      Character.prototype.update = function(cb) {
        return Character.update({id: this._id.$oid},
            angular.extend({}, this, {_id:undefined}), cb);
      };

      Character.prototype.destroy = function(cb) {
        return Character.remove({id: this._id.$oid}, cb);
      };

      return Character;
    });
