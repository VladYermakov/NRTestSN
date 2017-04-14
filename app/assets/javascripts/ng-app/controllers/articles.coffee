app = angular.module 'nrTest'

app.controller 'ArticlesCtrl', ($state, $scope, articles, comments) ->
  article_id = $state.params.article_id
  articles.get(article_id).then (res) ->
    article = res
    $scope.article = article

    $scope.hasAttachment = article.attachment_id isnt null

    if article.attachment_type == 'Article'
      $scope.article_link = '/articles/' + article.attachment_id
    else if article.attachment_type == 'Comment'
      comments.get(article.attachment_id).then (com) ->
        $scope.article_link = '/articles/' +  com.article_id + '/#' + article.attachment_id
    else
      $scope.article_link = '/files/' + article.attachment_id

  comments.getAll(article_id).then (res) ->
    $scope.comments = res

  $scope.createComment = ->
    console.log $scope.content
