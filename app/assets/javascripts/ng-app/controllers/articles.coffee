app = angular.module 'nrTest'

app.controller 'ArticlesCtrl', ($state, $location, $timeout, $scope, $anchorScroll, Auth, articles, comments) ->
  $scope.comments = comments.comments
  $scope.signedIn = Auth.isAuthenticated
  $scope.article = articles.article
  $scope.hasAttachment = $scope.article.attachment_id isnt null

  $scope.focus = ->
    $(".create-comment .comment-content")[0].focus()

  $(document).ready ->
    comment_hash = $location.hash()
    $anchorScroll()

    $($("[name='#{comment_hash}']").parent()).css 'background', '#e4eaf0'

    $timeout ->
      $($("[name='#{comment_hash}']").parent()).css 'background', 'none'
    , 500

  $scope.change = ->
    value = $(".create-comment .comment-content")[0].innerHTML
    console.log value
    if !value || value == '' || value == '<br>'
      $(".create-comment .content.placeholder").css 'visibility', 'visible'
    else
      $(".create-comment .content.placeholder").css 'visibility', 'hidden'

  $(document).ready ->
    $(".create-comment .comment-content")[0].innerHTML = '<br>'
    $scope.change()

  if $scope.article.attachment_type == 'Article'
    $scope.article_link = '/articles/' + $scope.article.attachment_id
  else if $scope.article.attachment_type == 'Comment'
    comments.get($scope.article.attachment_id).then (com) ->
      $scope.article_link = '/articles/' +  com.article_id + '/#' + $scope.article.attachment_id
  else
    $scope.article_link = '/files/' + $scope.article.attachment_id

  $scope.createComment = ->
    if $scope.content then $scope.content = $scope.content.replace /<br>/g, '\n'

    if !$scope.content || $scope.content == '' then return

    comments.create($scope.article.id, content: $scope.content)
    # $('.article-comments').css('border-bottom', '1px solid lightgrey')

    $scope.content = '<br>'
    $(".create-comment .comment-content")[0].innerHTML = '<br>'
    $scope.change()
