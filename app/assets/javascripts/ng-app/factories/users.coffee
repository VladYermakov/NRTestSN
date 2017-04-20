'use strict'

angular.module 'nrTest'
.factory 'users', ($http) ->
  o =
    followedUsers: []
    feedArticles: []

  o.getFollowed = (user_id) ->
    $http.get(Routes.following_api_user_path(user_id, 'json')).then (res) ->
      angular.copy(res.data, o.followedUsers)
      res.data

  o.getFeed = ->
    $http.get(Routes.feed_api_user_path('json')).then (res) ->
      angular.copy(res.data, o.feedArticles)
      res.data

  o.getInfo = (user_id) ->
    $http.get(Routes.relationships_info_api_user_path(user_id, 'json')).then (res) ->
      o.following_count = res.data.following_count
      o.followers_count = res.data.followers_count

  o
