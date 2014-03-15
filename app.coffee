
###
Module dependencies.
###
express = require("express")
path = require("path")
http = require("http")
mongoose = require("mongoose")
app = express()
server = require('http').createServer(app)
validator = require('express-validator')
io = require('socket.io').listen(server)

consts = require './config/consts'
env = app.get("env")
config = require('./config/environment')[env]
# Connect to mongodb
mongoose.connect config.db, (err) ->
    if err then console.log err else console.log 'connected to db'

# all environments
app.use express.logger("dev")
app.use express.methodOverride()
app.use express.bodyParser
  uploadDir: consts.FULL_UPLOADS_PATH
  keepExtensions: true
app.use validator()
app.use "/#{consts.UPLOADS_PATH}", express.static(consts.FULL_UPLOADS_PATH)
app.use app.router

require './config/init'
require('./config/routes')(app)

clients = {}

io.sockets.on 'connection', (socket) ->
  socket.on 'register', (token) ->
    senderId = token # TODO: Check if the user exists
    clients[senderId] = socket
    socket.set 'senderId', senderId

    socket.on "message", (msg) ->
      socket.get 'senderId', (_, senderId) ->
        recipientSocket = clients[msg.recipientId]
        recipientSocket.emit('message', message: msg.body, senderId: senderId)

    socket.on "disconnect", (socket) ->
      socket.get 'senderId', (_, senderId) ->
        delete clients[senderId]

# development only
if "development" is app.get("env")
    app.use express.errorHandler()
    server.listen(config.server.port)
    console.log('Listening on port ' + config.server.port);
