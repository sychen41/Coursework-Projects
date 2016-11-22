var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var database = require('./config/database');

var app = express();

// view engine setup. Doesn't matter, since we
// are not using this view engine. Any visit to
// home page will directly call app.get('/api/todos',......)
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// we can NOT use this, maybe because of res.sendfile method
// wondering if we can use res.send method, maybe can't either
//app.get('*', function(req, res){
//    res.sendfile('./public/index.html');
//} );

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(methodOverride());

//routes with mongodb
/*
var mongoose = require('mongoose');
mongoose.connect(database.remoteUrl);
var Todo = mongoose.model('Todo', {
text: String
});
app.get('/api/todos', function(req, res) {
    Todo.find(function(err, todos) {
        if (err)
            res.send(err);
        res.json(todos);
    });
});
app.post('/api/todos', function(req, res) {
    Todo.create({
        text: req.body.text,
        done: false
    },function(err, todo) {
        if (err)
            res.send(err);
        Todo.find(function(err, todos){
            if(err)
                res.send(err);
            res.json(todos);
        });
    });
});
app.delete('/api/todos/:todo_id', function(req, res) {
    Todo.remove({
        _id: req.params.todo_id
    }, function(err, todo){
        if(err)
            res.send(err);
        Todo.find(function(err,todos){
            if(err)
                res.send(err);
            res.json(todos);
        });
    });
});
*/
var connectionProvider = require('./mysqlServer/connectionProvider');
app.get('/api/todos', function(req, res) {
    var connection = connectionProvider.connectionProdiver.startConnection();
    if (connection) {
        connection.query("select * from todo", function(err, todos){
            if (err)
                res.send(err);
            res.json(todos);
        });
    }
    connection.end(function(err) {
        if (!err)
            console.log("connection closed after get all todos");
        else
            console.log("connection close error: " + err);
    });
});
app.post('/api/todos', function(req, res) {
    var connection = connectionProvider.connectionProdiver.startConnection();
    if (connection) {
        connection.query("insert into todo set?", req.body, function (err) {
            if (err)
                res.send(err);
        });
        // refresh the todos after insert
        connection.query("select * from todo", function(err, todos){
            if (err)
                res.send(err);
            res.json(todos);
        });
    }
    connection.end(function(err) {
        if (!err)
            console.log("connection closed after insert a todo");
        else
            console.log("connection close error: " + err);
    });
});
app.delete('/api/todos/:todo_id', function(req, res) {
    var connection = connectionProvider.connectionProdiver.startConnection();
    if (connection) {
        connection.query("delete from todo where id=?", req.params.todo_id, function(err) {
            if (err)
                res.send(err);
        });
        // refresh the todos after delete
        connection.query("select * from todo", function(err, todos){
            if (err)
                res.send(err);
            res.json(todos);
        });

    }
    connection.end(function(err) {
        if (!err)
            console.log("connection closed after delete a todo");
        else
            console.log("connection close error: " + err);
    });
});
// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;
