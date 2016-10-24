var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var mongoose = require('mongoose');
var database = require('./config/database');

var app = express();

// view engine setup. we will make this a
// single page application, thus no view engine needed
// only a single page 'index.html' needed.
//app.set('views', path.join(__dirname, 'views'));
//app.set('view engine', 'ejs');
//app.get('*', function(req, res){
//    res.sendfile('./public/index.html');
//} );
mongoose.connect(database.remoteUrl);
var Todo = mongoose.model('Todo', {
    text: String
});

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(methodOverride());

//routes
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
