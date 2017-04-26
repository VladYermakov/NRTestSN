'use strict'

angular.module 'nrTest'
.controller 'FollowingCtrl', class FollowingCtrl

  constructor: ($location, Auth, users) ->

    @users = users.users
    @user = users.user

    console.log @users

    path = $location.path()
    [@action, @fol] = if path[path.length - 1] == 'g'
      ['Followed users of ', 'followed users']
    else
      ['Followers of ', 'followers']

    $(document).ready ->
      console.log 'following ready'
      $('.container').css 'width', '670'
      $('.container-navbar').css 'width', '670'
