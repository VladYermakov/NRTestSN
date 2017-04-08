var app = angular.module('nrTest');

app.factory('articles', function($http) {
  var o = { articles: [] }

  o.getAll = function() {
    return $http.get('/api/articles.json').then(function(res) {
      angular.copy(res.data, o.articles);
    });
  };

  o.create = function(article) {
    return $http.post('/api/articles.json', article).then(function(res) {
      o.articles.push(res.data);
    });
  };

  o.get = function(id) {
    return $http.get('/api/articles/' + id + '.json').then(function(res) {
      return res.data;
    });
  };

  o.update = function(id, article) {
    return $http.put('/api/articles/' + id + '.json', article);
  };

  o.destroy = function(id) {
    return $http.delete('/api/articles/' + id + '.json');
  };

  return o;
})
