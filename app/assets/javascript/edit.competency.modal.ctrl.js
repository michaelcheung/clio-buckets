var app = angular.module("clioBucketsApp");
app.controller("editCompetencyModalController", function($http, $timeout) {
  var ctrl = this;
  ctrl.options = [
     {name: "Tech I", value: "0"},
     {name: "Tech I+", value: "1"},
     {name: "Tech II", value: "2"},
     {name: "Tech II+", value: "3"},
     {name: "Tech III", value: "4"},
     {name: "Tech III+", value: "5"},
     {name: "Specialist", value: "6"}
  ]
  $timeout(function() {
    ctrl.competency.rank = ctrl.options.find(function(option){
      return option.value == ctrl.competency.rank
    });
  })

  return;
});
