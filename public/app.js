var app = angular.module("clioBucketsApp", []);

// Setup an interceptor that detects unauthorized and sends them to the login page

app.controller("StupidController", function($http){
  var ctrl = this
  $http.get("/departments.json").then(function(response){
    ctrl.departments = response.data
  });

  ctrl.selectDepartment = function(id){    
    $http.get("/departments/"+id+"/users.json").then(function(response){
      ctrl.employees = response.data
    });
  }

  ctrl.selectEmployee = function(id){    
    $http.get("/users/"+id+"/competencies").then(function(response){
      ctrl.competencies = response.data
    });
    $http.get("/users/"+id+"/grants").then(function(response){
      ctrl.competenciesGranted = {}
      for(i=0; i < response.data.length; i++){
        ctrl.competenciesGranted[response.data[i].competency_id] = true
      }
    });
  }

  return
});
