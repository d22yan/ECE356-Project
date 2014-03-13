'use strict';

angular.module('app.controllers', [])
    .controller('DevelopersController', function($scope) {
        $scope.developers = [
            {"name": "Qi Liu",       "id": "q35liu"},
            {"name": "Danny Yang",   "id": "?"},
            {"name": "Tony Fu",      "id": "?"},
            {"name": "SangHoon Lee", "id": "?"},
        ];
    });