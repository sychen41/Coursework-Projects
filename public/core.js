/*
angular.module('demoApp', [])
    .controller('simpleController', function($scope) {
        $scope.cus = {
            name: "Joe"
        };
    });
    */
var scotchTodo = angular.module('scotchTodo', []);
//scotchTodo.controller('mainController', function($scope, $http) {
//    $scope.name = 'haha';
//});

function mainController($scope, $http) {
    $scope.formData = {};
    // when landing on the page, get all todos and show them
    $http.get('/api/todos')
        .success(function(data) {
            $scope.todos = data;
            console.log(data);
        })
        .error(function(data) {
            console.log('Error: ' + data);
        });
    //when submitting the add form, send the text to the node API
    $scope.createTodo = function() {
        $http.post('/api/todos', $scope.formData)
            .success(function(data) {
                $scope.formData = {}; // clear the form so user is ready to create new todo
                $scope.todos = data;
                console.log(data);
            })
            .error(function(data) {
                console.log('Error: ' + data);
            });
    };
    $scope.deleteTodo = function(id) {
        $http.delete('/api/todos/'+id)
            .success(function(data) {
                $scope.todos = data;
                console.log(data);
            })
            .error(function(data){
                console.log('Error: ' + data);
            });
    };
}

