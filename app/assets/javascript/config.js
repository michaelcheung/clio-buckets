var ui = require("lib-ThemisUI");
var app = angular.module("clioBucketsApp",[ui]);

// Setup an interceptor that detects unauthorized and sends them to the login page
app.service("loggedOutInterceptor", function($q){
  return {
    responseError: function(response){
      if(response.status == 401){
        window.location = "/unauthed.html"
      }
      return $q.reject(response)
    }
  }
});

app.config(function($httpProvider){
  $httpProvider.interceptors.push('loggedOutInterceptor');
});

app.controller("LogoutDirective", function($http){
  var ctrl = this;
  ctrl.logout = function(){
    $http.delete("logout.json").then(function(){
      window.location = "/unauthed.html"
    });
  }
})


