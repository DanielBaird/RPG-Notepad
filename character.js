angular.module('character', ['mongolab']).
  config(function($routeProvider) {
    $routeProvider.
      when('/', {controller:ListCtrl, templateUrl:'list.html'}).
      when('/edit/:characterId', {controller:EditCtrl, templateUrl:'detail.html'}).
      when('/new', {controller:CreateCtrl, templateUrl:'detail.html'}).
      otherwise({redirectTo:'/'});
  });


function ListCtrl($scope, Character) {
  $scope.characters = Character.query();
}


function CreateCtrl($scope, $location, Character) {
  $scope.save = function() {
    Character.save($scope.character, function(character) {
      $location.path('/edit/' + character._id.$oid);
    });
  }
}


function EditCtrl($scope, $location, $routeParams, Character) {
  var self = this;

  Character.get({id: $routeParams.characterId}, function(character) {
    self.original = character;
    $scope.character= new Character(self.original);
  });

  $scope.isClean = function() {
    return angular.equals(self.original, $scope.character);
  }

  $scope.destroy = function() {
    self.original.destroy(function() {
      $location.path('/list');
    });
  };

  $scope.save = function() {
    $scope.character.update(function() {
      $location.path('/');
    });
  };
}
