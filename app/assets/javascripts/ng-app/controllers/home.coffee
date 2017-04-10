app = angular.module 'nrTest'

app.controller 'HomeCtrl', ($scope, articles, Auth) ->
  $scope.articles = articles.articles
  $scope.signedIn = Auth.isAuthenticated
  $scope.toShow = false

  $scope.toggleShow = () ->
    $scope.toShow ^= true

  $scope.addArticle = () ->
    if !$scope.title || $scope.title == '' || !$scope.content || $scope.content == ''
      return

    articles.create \
      title: $scope.title,
      content: $scope.content
      
    $scope.title = ''
    $scope.content = ''
