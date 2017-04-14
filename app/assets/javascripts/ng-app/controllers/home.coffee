app = angular.module 'nrTest'

app.controller 'HomeCtrl', ($scope, articles, comments, Auth, Upload) ->
  $scope.articles = articles.articles
  $scope.signedIn = Auth.isAuthenticated
  $scope.toShow = false
  $scope.toClear = false
  $scope.attachment_types = ['article', 'comment', 'file']
  $scope.article_link = {}

  $scope.hasAttachment = (article)->
    article.attachment_id isnt null

  attachLink = (article) ->
    if article.attachment_type == 'Article'
      $scope.article_link[article.id] = '/articles/' + article.attachment_id
    else if article.attachment_type == 'Comment'
      comments.get(article.attachment_id).then (com) ->
        $scope.article_link[article.id] = '/articles/' +  com.article_id + '#' + article.attachment_id
    else
      $scope.article_link[article.id] = '/files/' + article.attachment_id

  for article in $scope.articles
    attachLink(article)

  $scope.upload = (article_id, file) ->
    options =
      url:    Routes.api_attachments_path('json')
      method: 'POST'
      headers:
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      file: file
      data:
        source: file

    Upload.upload(options).then (res) ->
      articles.updateAttachment article_id, 'attachment_file', id: res.data.id

  $scope.capitalize = (str) ->
    str.charAt(0).toUpperCase() + str.slice(1)

  $scope.clearShowings = ->
    for att in $scope.attachment_types
      $scope['show' + $scope.capitalize(att)] = false

  $scope.clearShowings()

  $scope.chooseAttachment = (att_type) ->
    $scope.clearShowings()
    $scope['show' + $scope.capitalize(att_type)] = true

  $scope.toggleShow = ->
    $scope.toShow ^= true

  $scope.addArticle = ->
    if !$scope.title || $scope.title == '' || !$scope.content || $scope.content == ''
      return

    attachment =
      file:    $scope.file
      article: $scope.article
      comment: $scope.comment

    articles.create(title: $scope.title, content: $scope.content).then (article_id) ->
      if attachment.file && attachment.file != ''
        $scope.upload article_id, attachment.file

      if attachment.article && attachment.article != ''
        articles.updateAttachment article_id, 'article', id: attachment.article

      if attachment.comment && attachment.comment != ''
        articles.updateAttachment article_id, 'comment', id: attachment.comment

    $scope.title = ''
    $scope.content = ''
    $scope.article = ''
    $scope.comment = ''
    $scope.file = ''
