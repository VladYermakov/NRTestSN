app = angular.module 'nrTest'

app.directive 'fileDownload', ($window, $http, articles) ->
  restrict: 'A',
  scope:
    fileId: '@fileId'
  link: ($scope) ->
    articles.getAttachment($scope.fileId).then (res) ->
      console.log res
      $window.open(res)
