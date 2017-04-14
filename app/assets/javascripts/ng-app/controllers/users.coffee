app = angular.module 'nrTest'

app.controller 'UsersCtrl', ($state, $scope, $http) ->
  user_id = $state.params.user_id

  $http.get(Routes.following_api_user_path(user_id, 'json')).then (res) ->
    console.log res
