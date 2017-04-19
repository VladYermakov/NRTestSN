'use strict'

angular.module 'nrTest'
.factory 'articles', ($http) ->
  o =
    articles: []
    article: {}
    userArticles: []

  o.getAll = ->
    $http.get(Routes.api_articles_path('json')).then (res) ->
      angular.copy(res.data, o.articles)

  o.getUserArticles = (user_id) ->
    $http.get(Routes.articles_api_user_path(user_id, 'json')).then (res) ->
      angular.copy(res.data, o.userArticles)

  o.create = (article) ->
    $http.post(Routes.api_articles_path('json'), article).then (res) ->
      o.articles.unshift(res.data)
      res.data

  o.get = (id) ->
    $http.get(Routes.api_article_path(id, 'json')).then (res) ->
      o.article = res.data

  o.update = (id, article) ->
    $http.put(Routes.api_article_path(id, 'json'), article).then (res) ->
      res

  o.destroy = (id) ->
    $http.delete(Routes.api_article_path(id, 'json')).then (res) ->
      res

  o.updateAttachment = (id, type, attachment) ->
    params = type: type
    params[type] = attachment
    $http.put(Routes.api_article_attachment_path(id, 'json'), attachment: params)

  o.getAttachment = (attachment_id) ->
    $http.get(Routes.file_attachment_path(attachment_id, 'json')).then (res) ->
      res

  o
