'use strict'

angular.module 'nrTest'
.factory 'users', ($http) ->
  o =
    users: []
    feedArticles: []
    user: {}
    arr: []

  page = 1

  o.get = (user_id) ->
    $http.get(Routes.api_user_path(user_id, 'json')).then (res) ->
      o.user = res.data

  o.getFollowed = (user_id) ->
    $http.get(Routes.following_api_user_path(user_id, 'json')).then (res) ->
      angular.copy(res.data, o.users)
      res.data

  o.getFollowers = (user_id) ->
    $http.get(Routes.followers_api_user_path(user_id, 'json')).then (res) ->
      angular.copy(res.data, o.users)
      res.data

  o.getFeed = ->
    $http.get(Routes.feed_api_user_path('json'), params: page: page).then (res) ->
      angular.copy(res.data, o.arr)
      o.feedArticles.push.apply o.feedArticles, o.arr
      page += 1
      res.data

  o.getInfo = (user_id) ->
    $http.get(Routes.relationships_info_api_user_path(user_id, 'json')).then (res) ->
      o.following_count = res.data.following_count
      o.followers_count = res.data.followers_count

  o.follow = (other_id) ->
    $http.post(Routes.api_relationships_path('json'), followed_id: other_id)

  o.unfollow = (other_id) ->
    $http.delete(Routes.api_relationships_path('json'), params: followed_id: other_id)

  o.following = (other_id) ->
    $http.get(Routes.api_relationships_path('json'), params: followed_id: other_id)

  o
