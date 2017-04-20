'use strict'

angular.module 'nrTest'
.config class Config

  constructor: ($stateProvider, $urlRouterProvider, $locationProvider,
                $httpProvider, AuthProvider) ->

    $stateProvider.state 'home',
      url: '/'
      templateUrl: 'home.html'
      controller: 'HomeCtrl as ctrl'
      resolve:
        articlePromise: (articles) ->
          articles.getAll()
      onEnter: ($state, Auth) ->
        Auth.currentUser().then ->
          $state.go 'feed'

    $stateProvider.state 'article',
      url: '/articles/:article_id'
      templateUrl: 'articles/article.html'
      controller: 'ArticlesCtrl as ctrl'
      resolve:
        commentPromise: (comments, $stateParams) ->
          comments.getComments($stateParams.article_id)
        articlePromise: (articles, $stateParams) ->
          articles.get($stateParams.article_id)

    $stateProvider.state 'users',
      url: '/users/:user_id'
      templateUrl: 'users/user.html'
      controller: 'UsersCtrl as ctrl'
      resolve:
        articlePromise: (articles, $stateParams) ->
          articles.getUserArticles($stateParams.user_id)
        followResolve: (users, $stateParams) ->
          users.getInfo($stateParams.user_id)

    $stateProvider.state 'feed',
      url: '/feed'
      templateUrl: 'feeds/feed.html'
      controller: 'FeedCtrl as ctrl'
      onEnter: ($state, Auth) ->
        Auth.currentUser().then null, (res) ->
          $state.go 'home'
      resolve:
        feedPromise: (Auth, users) ->
          Auth.currentUser().then (res) ->
            users.getFeed(res.id)
          , (err) ->
            console.log err
        articlePromise: (articles) ->
          articles.getAll()
        commentPromise: (comments) ->
          comments.getAll()

    $stateProvider.state 'following',
      url: '/users/:user_id/following'
      templateUrl: 'followings/following.html'
      controller: 'FollowingCtrl as ctrl'
      resolve:
        followingPromise: ($stateParams, users) ->
          users.getFollowed($stateParams.user_id)
        userPromise: ($stateParams, users) ->
          users.get($stateParams.user_id)

    $stateProvider.state 'followers',
      url: '/users/:user_id/followers'
      templateUrl: 'followings/following.html'
      controller: 'FollowingCtrl as ctrl'
      resolve:
        followersPromise: ($stateParams, users) ->
          users.getFollowers($stateParams.user_id)
        userPromise: ($stateParams, users) ->
          users.get($stateParams.user_id)

    # $urlRouterProvider.otherwise '/feed'
    $urlRouterProvider.otherwise '/'

    $locationProvider.html5Mode true

    AuthProvider.loginPath    Routes.new_user_session_path      'json'
    AuthProvider.logoutPath   Routes.destroy_user_session_path  'json'
    AuthProvider.registerPath Routes.new_user_registration_path 'json'
