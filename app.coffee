
###
Module dependencies.
###
express = require("express")
http = require("http")
mongoose = require("mongoose")
app = express()
validator = require('express-validator')
authentication = require('./app/middlewares/authentication')

consts = require './config/consts'
env = app.get("env")
config = require('./config/environment')[env]

# Connect to mongodb
mongoose.connect config.db, (err) ->
    if err then console.log err else console.log 'connected to db'

# all environments
app.use express.logger("dev")
app.use express.methodOverride()
app.use express.bodyParser()
app.use authentication()
app.use validator()
app.use app.router

require './config/init'
require('./config/routes')(app)


# development only
if "development" is app.get("env")
    app.use express.errorHandler()

    app.listen(config.server.port);
    console.log('Listening on port ' + config.server.port);
