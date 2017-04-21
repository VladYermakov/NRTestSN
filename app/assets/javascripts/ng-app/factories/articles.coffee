'use strict'

angular.module 'nrTest'
.factory 'articles', ($http) ->
  o =
    articles: []
    article: {}
    userArticles: []
    arr: []

  page = 1
  uPage = 1

  o.getAll = ->
    $http.get(Routes.api_articles_path('json'), params: page: page).then (res) ->
      angular.copy(res.data, o.arr)
      o.articles.push.apply o.articles, o.arr
      page += 1
      res.data

  o.getUserArticles = (user_id) ->
    $http.get(Routes.articles_api_user_path(user_id, 'json'), params: page: uPage).then (res) ->
      angular.copy(res.data, o.arr)
      o.userArticles.push.apply o.userArticles, o.arr
      uPage += 1
      res.data

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
      res.data

  o
