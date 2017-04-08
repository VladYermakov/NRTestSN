var app = angular.module('nrTest', ['ui.router', 'templates', 'Devise']);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider,
                    AuthProvider) {

  $stateProvider
      .state('home', {
        url: '/',
        templateUrl: 'home.html',
        controller: 'HomeCtrl',
        resolve: {
          article: function (articles) {
            return articles.getAll();
          }
        }
      })
      .state('login', {
        url: '/login',
        templateUrl: 'auth/login.html',
        controller: 'AuthCtrl',
        onEnter: function($state, Auth) {
          Auth.currentUser().then(function (){
            $state.go('home');
          })
        }
      })
      .state('register', {
        url: '/register',
        templateUrl: 'auth/register.html',
        controller: 'AuthCtrl',
        onEnter: function($state, Auth) {
          Auth.currentUser().then(function (){
            $state.go('home');
          })
        }
      });

  $urlRouterProvider.otherwise('/');

  $locationProvider.html5Mode(true);

  AuthProvider.loginPath('/api/users/sign_in.json');
  AuthProvider.logoutPath('/api/users/sign_out.json');
  AuthProvider.registerPath('/api/users.json');
});
