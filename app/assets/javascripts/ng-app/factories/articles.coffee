app = angular.module 'nrTest'

app.factory 'articles', ($http) ->
  o = { articles: [] }

  o.getAll = () ->
    $http.get(Routes.api_articles_path('json')).then (res)->
      angular.copy res.data, o.articles

  o.create = (article) ->
    $http.post(Routes.api_articles_path('json'), article).then (res)->
      o.articles.push res.data

  o.get = (id) ->
    $http.get(Routes.api_article_path(id, 'json')).then (res)->
      res.data

  o.update = (id, article) ->
    $http.put(Routes.api_article_path(id, 'json'), article)

  o.destroy = (id)->
    $http.delete(Routes.api_article_path(id, 'json'))

  o
