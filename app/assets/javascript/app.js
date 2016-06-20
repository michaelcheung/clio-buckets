var app = angular.module("clioBucketsApp");
app.controller("StupidController",
  function(
    $http,
    $timeout,
    SimpleTableDelegate,
    TableHeader,
    TableSort,
    ModalManager
  ) {
    var ctrl = this;
    var department = null
    $http.get("/departments.json").then(function(response){
      ctrl.departments = response.data
      ctrl.departmentsArray = []
      response.data.map(function(each) {
        ctrl.departmentsArray.push({name: each.name, value: each.id})
      });
    });

    $http.get("/users/who_am_i.json").then(function(response){
      ctrl.directReports = {}
      for(i=0; i < response.data.direct_reports.length; i++){
        ctrl.directReports[response.data.direct_reports[i].id] = true
      }
      ctrl.userDepartmentId = response.data.department_id
    });

    ctrl.actions = [
      {name: "Competencies", value: "Competencies"},
      {name: "Users", value: "Users"}
    ];
    ctrl.action = null;
    ctrl.selectAction = function(){

      $timeout(function() {
        if(ctrl.action.value == "Users"){
          ctrl.findUsers();
          ctrl.findRoles();
        } else if(ctrl.action.value == "Competencies"){
          ctrl.findCompetencies();
        }
      })
    }

    ctrl.findUsers = function(){
      ctrl.competencies = null;
      $http.get("/departments/"+ctrl.department.value+"/users.json").then(function(response){
        response.data.forEach(function(user) {
          ctrl.users.push({name: user.full_name, value: user.id});
        });
      });
    }
    ctrl.findRoles = function(){
      ctrl.competencies = null;
      $http.get("/departments/"+ctrl.department.value+"/roles.json").then(function(response){
        ctrl.roles = response.data
      });
    }
    ctrl.findCompetencies = function(){
      ctrl.users = null;
      ctrl.userCompetencies = null;
      ctrl.roles = null;
      $http.get(
        "/departments/"+ctrl.department.value+"/competencies.json"
      ).then(function(response){
        ctrl.competencies = response.data
        ctrl.filteredCompetencies = ctrl.competencies
        ctrl.generateCompentencyTable();
      });
    }


//     ctrl.updateUserRoles = function(){
//       var userRoles = ctrl.user.roles.map(function(e){ return e.id });
//       $http.put("/users/"+ctrl.user.id+".json", { roles: userRoles }).then(function(response){
//         ctrl.selectUser();
//       });
//     }


    ctrl.generateCompentencyTable = function() {
      if(ctrl.competencyTableDelegate) {
        ctrl.competencytableGenerated = false;
        ctrl.competencyTableDelegate = null;
      }
      var sort = TableSort.sort;

      var getDataPage = function(data, page, pageSize) {
        var start = (page - 1) * pageSize;
        var end = start + pageSize;
        return data.slice(start, end);
      };

      ctrl.competencyTableDelegate = SimpleTableDelegate({
        headers: [
          TableHeader({name: "Rank", sortField: "rank", sortActive: true}),
          TableHeader({name: "Category", sortField: "Category"}),
          TableHeader({name: "Competency", sortField: "name"}),
          TableHeader({name: ""}),
        ],
        pageSize: 15,
        fetchData: function(arg, updateData) {
          var sortHeader = arg.sortHeader;
          var currentPage = arg.currentPage;
          var pageSize = arg.pageSize;
          var sortedData = sort(ctrl.filteredCompetencies, sortHeader);
          var paginatedData = getDataPage(sortedData, currentPage, pageSize)
          updateData({data: paginatedData, totalItems: sortedData.length});
          ctrl.competencytableGenerated = true;
        }
      });
    }

    ctrl.rankMap = {
      0: "Tech I",
      1: "Tech I+",
      2: "Tech II",
      3: "Tech II+",
      4: "Tech III",
      5: "Tech III+",
      6: "Specialist"
    }

    ctrl.filterCompetencyTable = function(rank) {
      if(rank >= 0) {
        ctrl.filteredCompetencies = ctrl.competencies.filter(function(each) {
          return each.rank == rank;
        });
        ctrl.competencyTableDelegate.reload({currentPage: 1});
      } else {
        ctrl.filteredCompetencies = ctrl.competencies
        ctrl.competencyTableDelegate.reload({currentPage: 1})
      }
    }

    ctrl.filterUserCompetencyTable = function(rank) {
      if(rank >= 0) {
        ctrl.filteredUserCompetencies = ctrl.userCompetencies.filter(function(each) {
          return each.rank == rank;
        });
        ctrl.userCompetencyTableDelegate.reload({currentPage: 1});
      } else {
        ctrl.filteredUserCompetencies = ctrl.userCompetencies;
        ctrl.userCompetencyTableDelegate.reload({currentPage: 1});
      }
    }

    ctrl.generateUserCompentencyTable = function(){
      if(ctrl.userCompetencyTableDelegate) {
        ctrl.userCompetencytableGenerated = false;
        ctrl.userCompetencyTableDelegate = null;
      }
      var sort = TableSort.sort;

      var getDataPage = function(data, page, pageSize) {
        var start = (page - 1) * pageSize;
        var end = start + pageSize;
        return data.slice(start, end);
      };

      ctrl.userCompetencyTableDelegate = SimpleTableDelegate({
        headers: [
          TableHeader({name: "Rank", sortField: "rank", sortActive: true}),
          TableHeader({name: "Competency", sortField: "name"}),
          TableHeader({name: "Category", sortField: "Category"}),
          TableHeader({name: "Granted", sortField: "id", width: "40px"}),
          TableHeader({name: ""})
        ],
        pageSize: 15,
        fetchData: function(arg, updateData) {
          var sortHeader = arg.sortHeader;
          var currentPage = arg.currentPage;
          var pageSize = arg.pageSize;
          var sortedData = sort(ctrl.filteredUserCompetencies, sortHeader);
          var paginatedData = getDataPage(sortedData, currentPage, pageSize)
          updateData({data: paginatedData, totalItems: sortedData.length});
          ctrl.userCompetencytableGenerated = true;
        }
      });
    }

    ctrl.selectUser = function(){
      $timeout(function() {
        $http.get("/users/"+ctrl.user.value+"/competencies").then(function(response){
          ctrl.userCompetencies = response.data
          ctrl.filteredUserCompetencies = ctrl.userCompetencies
          ctrl.generateUserCompentencyTable();
        });
        $http.get("/users/"+ctrl.user.value+"/grants").then(function(response){
          ctrl.competenciesGranted = {}
          for(i=0; i < response.data.length; i++){
            grant = response.data[i]
            ctrl.competenciesGranted[grant.competency_id] = grant
          }
        });
      })
    }

    ctrl.showUserCompentencyTable = function() {
      return ctrl.userCompetencytableGenerated
        && ctrl.user != null
        && ctrl.department != null
        && ctrl.action.name == 'Users'
    }

    ctrl.openGrantModal = function(competency, grant) {
       ModalManager.show({
        path: "/users/"+ctrl.user.value+"/grants/edit_modal",
        context: { competency: competency, grant: grant, canGrant: ctrl.directReports[ctrl.user.value] }
      }).then(function(context) {
        competency = context.competency
        grant = context.grant
        if(grant && grant.id){
          ctrl.updateGrant(grant, true);
        } else {
          ctrl.createGrant(competency, grant);
        }
      });
    }

    ctrl.openCompetencyModal = function(competency) {
      ModalManager.show({
        path: "/departments/"+ctrl.userDepartmentId+"/competencies/"+competency.id+"/edit_modal",
        context: competency
      });
    }

    ctrl.createGrant = function(competency, grant){
      $http.post(
        "/users/"+ctrl.user.value+"/grants",
        {reason: grant.reason, competency_id: competency.id}
      ).then(function(response){
        grant = response.data
        ctrl.competenciesGranted[grant.competency_id] = grant
      });
    }

    ctrl.updateGrant = function(grant, approved){
      $http.put("/grants/"+grant.id+".json", { reason: grant.reason, approved: approved}).then(function(response){
        grant = response.data
        ctrl.competenciesGranted[grant.competency_id] = grant
      });    
    }
    return
});
