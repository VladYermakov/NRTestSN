app = angular.module 'nrTest', ['ui.router', 'templates', 'Devise',
                                'ngFileUpload', 'contenteditable']

app.config ($stateProvider, $urlRouterProvider, $locationProvider,
                    AuthProvider) ->

  $stateProvider.state 'home',
    url: '/',
    templateUrl: 'home.html',
    controller: 'HomeCtrl',
    resolve:
      article: (articles) ->
        return articles.getAll()

  $stateProvider.state 'login',
    url: '/login',
    templateUrl: 'auth/login.html',
    controller: 'AuthCtrl',
    onEnter: ($state, Auth) ->
      Auth.currentUser().then ->
        $state.go 'home'

  $stateProvider.state 'register',
    url: '/register',
    templateUrl: 'auth/register.html',
    controller: 'AuthCtrl',
    onEnter: ($state, Auth) ->
      Auth.currentUser().then ->
        $state.go 'home'

  $stateProvider.state 'article',
    url: '/articles/:article_id',
    templateUrl: 'articles/article.html',
    controller: 'ArticlesCtrl'

  $stateProvider.state 'users',
    url: '/users/:user_id',
    templateUrl: 'users/user.html',
    controller: 'UsersCtrl'

  $urlRouterProvider.otherwise '/'

  $locationProvider.html5Mode true

  AuthProvider.loginPath    Routes.new_user_session_path      'json'
  AuthProvider.logoutPath   Routes.destroy_user_session_path  'json'
  AuthProvider.registerPath Routes.new_user_registration_path 'json'
