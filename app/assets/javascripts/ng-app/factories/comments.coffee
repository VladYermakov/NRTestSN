'use strict'

angular.module 'nrTest'
.factory 'comments', ($http) ->
  o =
    comments: []
    allComments: []
    arr: []

  page = 1
  aPage = 1

  o.getComments = (article_id) ->
    $http.get(Routes.api_article_comments_path(article_id, 'json'), params: page: page).then (res) ->
      angular.copy(res.data, o.arr)
      o.comments.push.apply o.comments, o.arr
      page += 1
      res.data

  o.getAll = () ->
    $http.get(Routes.api_comments_path('json'), params: page: aPage).then (res) ->
      angular.copy(res.data, o.arr)
      o.allComments.push.apply o.allComments, o.arr
      aPage += 1
      res.data

  o.get = (id) ->
    $http.get(Routes.api_comment_path(id, 'json')).then (res) ->
      res.data

  o.create = (article_id, comment) ->
    $http.post(Routes.api_article_comments_path(article_id, 'json'), comment).then (res) ->
      o.comments.push(res.data)
      res.data.id

  o.update = (id, comment) ->
    $http.put(Routes.api_comment_path(id, 'json'), comment)

  o.destroy = (id) ->
    $http.delete(Routes.api_comment_path(id, 'json'))

  o
