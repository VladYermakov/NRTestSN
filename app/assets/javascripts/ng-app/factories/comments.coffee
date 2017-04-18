app = angular.module 'nrTest'

app.factory 'comments', ($http) ->
  o =
    comments: []

  o.getAll = (article_id) ->
    $http.get(Routes.api_article_comments_path(article_id, 'json')).then (res) ->
      angular.copy res.data, o.comments
      res.data

  o.get = (id) ->
    $http.get(Routes.api_comment_path(id, 'json')).then (res) ->
      res.data

  o.create = (article_id, comment) ->
    $http.post(Routes.api_article_comments_path(article_id, 'json'), comment).then (res) ->
      o.comments.push res.data
      res.data.id

  o.update = (id, comment) ->
    $http.put Routes.api_comment_path(id, 'json'), comment

  o.destroy = (id) ->
    $http.delete Routes.api_comment_path(id, 'json')

  o
