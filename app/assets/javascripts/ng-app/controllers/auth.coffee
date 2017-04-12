app = angular.module 'nrTest'

app.controller 'AuthCtrl', ($scope, $state, Auth) ->
  $scope.login = ->
    Auth.login($scope.user).then ->
      $state.go 'home'

  $scope.register = ->
    Auth.register($scope.user).then ->
      $state.go 'home'
