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
        signedOut: ($q, $state, Auth) ->
          deferred = $q.defer()

          Auth.currentUser().then (res) ->
            deferred.reject()
            $state.go 'feed'
          , (res) ->
            deferred.resolve()

          deferred.promise
        articlePromise: (articles) ->
          articles.getAll()

    $stateProvider.state 'article',
      url: '/articles/:article_id'
      templateUrl: 'articles/article.html'
      controller: 'ArticlesCtrl as ctrl'
      resolve:
        commentPromise: (comments, $stateParams) ->
          comments.getComments($stateParams.article_id)
        articlePromise: (articles, $stateParams) ->
          articles.get($stateParams.article_id)
        currentUserPromise: (users) ->
          users.getCurrentUser()

    $stateProvider.state 'user',
      url: '/users/:user_id'
      templateUrl: 'users/user.html'
      controller: 'UsersCtrl as ctrl'
      resolve:
        articlePromise: (articles, $stateParams) ->
          articles.getUserArticles($stateParams.user_id)
        followResolve: (users, $stateParams) ->
          users.getInfo($stateParams.user_id)
        userResolve: (users, $stateParams) ->
          users.get($stateParams.user_id)

    $stateProvider.state 'feed',
      url: '/feed'
      templateUrl: 'feeds/feed.html'
      controller: 'FeedCtrl as ctrl'
      resolve:
        signedIn: ($q, $state, Auth) ->
          deferred = $q.defer()

          Auth.currentUser().then (res) ->
            deferred.resolve()
          , (res) ->
            deferred.reject()
            $state.go 'home'

          deferred.promise
        feedPromise: (users) ->
          users.getFeed()
        articlePromise: (articles) ->
          articles.getAll()
        commentPromise: (comments) ->
          comments.getAll()
        currentUserPromise: (users) ->
          users.getCurrentUser()

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
