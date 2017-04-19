'use strict'

angular.module 'nrTest'
.controller 'NavCtrl', class NavCtrl

  constructor: ($scope, $rootScope, Auth) ->

    @signedIn = Auth.isAuthenticated
    @logout = Auth.logout
    
    Auth.currentUser().then (user) =>
      @user = user

    $scope.$on 'devise:new-registration', (e, user) =>
      @user = user

    $scope.$on 'devise:login', (e, user) =>
      @user = user

    $scope.$on 'devise:logout', (e, user) =>
      @user = {}
