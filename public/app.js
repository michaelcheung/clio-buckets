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

  $http.get("/users/who_am_i.json").then(function(response){    
    ctrl.directReports = {}
    for(i=0; i < response.data.direct_reports.length; i++){
      ctrl.directReports[response.data.direct_reports[i].id] = true
    }
    ctrl.userDepartmentId = response.data.department_id
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
      ctrl.selectUser()
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

  ctrl.selectUser = function(){    
    $http.get("/users/"+ctrl.user.id+"/competencies").then(function(response){
      ctrl.userCompetencies = response.data
    });
    $http.get("/users/"+ctrl.user.id+"/grants").then(function(response){
      ctrl.competenciesGranted = {}
      ctrl.recommendedGrants = []
      for(i=0; i < response.data.length; i++){
        grant = response.data[i]
        if(grant.approved) {
          ctrl.competenciesGranted[grant.competency_id] = "Yes"
        } else if(grant.approved === null) {
          ctrl.competenciesGranted[grant.competency_id] = "Recommended"
          ctrl.recommendedGrants.push(grant)
        } else {
          ctrl.competenciesGranted[grant.competency_id] = "No"
        }
      }
    });
  }

  ctrl.createGrant = function(competencyId){
    $http.post("/users/"+ctrl.user.id+"/grants", { reason: "", competency_id: competencyId }).then(function(response){
      grant = response.data
      if(grant.approved) {
        ctrl.competenciesGranted[grant.competency_id] = "Yes"
      } else if(grant.approved === null) {
        ctrl.competenciesGranted[grant.competency_id] = "Recommended"
      } else {
        ctrl.competenciesGranted[grant.competency_id] = "No"
      }
    });    
  }

  ctrl.updateGrant = function(grantId, approved){
    $http.put("/grants/"+grantId+".json", { approved: approved}).then(function(response){
      grant = response.data
      for(var i=0; i < ctrl.recommendedGrants.length; i++){
        if(ctrl.recommendedGrants[i].id == grant.id){
          ctrl.recommendedGrants.splice(i, 1)
          break
        }
      }
      if(grant.approved) {
        ctrl.competenciesGranted[grant.competency_id] = "Yes"
      } else {
        ctrl.competenciesGranted[grant.competency_id] = "No"
      }
    });    
  }

  return
});
