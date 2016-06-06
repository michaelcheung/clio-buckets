var app = angular.module("clioBucketsApp", []);

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


app.controller("StupidController", function($http){  
  var ctrl = this
  $http.get("/departments.json").then(function(response){    
    ctrl.departments = response.data
  });

  ctrl.rankMap = {
    0: "Tech I",
    1: "Tech I+",
    2: "Tech II",
    3: "Tech II+",
    4: "Tech III",
    5: "Tech III+",
    6: "Specialist",
  }

  ctrl.selectDepartment = function(id){    
    ctrl.departmentId = id
  }

  ctrl.selectAction = function(action){
    if(action == "Users"){
      ctrl.findUsers();
      ctrl.findRoles();
    } else if(action == "Competencies"){
      ctrl.findCompetencies();
    }  
  }

  ctrl.findUsers = function(){
    ctrl.competencies = null;
    $http.get("/departments/"+ctrl.departmentId+"/users.json").then(function(response){
      ctrl.users = response.data
    });
  }

  ctrl.updateUserRoles = function(){
    var userRoles = ctrl.user.roles.map(function(e){ return e.id });
    $http.put("/users/"+ctrl.user.id+".json", { roles: userRoles }).then(function(response){

    });    
  }

  ctrl.findRoles = function(){
    ctrl.competencies = null;
    $http.get("/departments/"+ctrl.departmentId+"/roles.json").then(function(response){
      ctrl.roles = response.data
    });
  }

  ctrl.findCompetencies = function(){
    ctrl.users = null;
    ctrl.userCompetencies = null;
    ctrl.roles = null
    $http.get("/departments/"+ctrl.departmentId+"/competencies.json").then(function(response){
      ctrl.competencies = response.data
    });
  }

  ctrl.selectUser = function(id){    
    $http.get("/users/"+id+"/competencies").then(function(response){
      ctrl.userCompetencies = response.data
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
