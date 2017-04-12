app = angular.module 'nrTest'

app.controller 'HomeCtrl', ($scope, articles, Auth, Upload) ->
  $scope.articles = articles.articles
  $scope.signedIn = Auth.isAuthenticated
  $scope.toShow = false
  $scope.toClear = false
  $scope.attachment_types = ['article', 'comment', 'file']

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
