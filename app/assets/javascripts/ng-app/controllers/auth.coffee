'use strict'

angular.module 'nrTest'
.controller 'AuthCtrl', class AuthCtrl

  constructor: ($state, Auth) ->

    @login = =>
      Auth.login(@user).then ->
        $state.go 'feed'

    @register = =>
      Auth.register(@user).then ->
        $state.go 'feed'
