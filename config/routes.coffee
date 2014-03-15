authentication = require('../app/middlewares/authentication')()

module.exports = (app) ->
  # User routes
  users = require '../app/controllers/user'
  networks = require '../app/controllers/network'

# Users
  app.post '/users/?', users.create
  app.put '/users/edit', authentication, users.update

# Networks

  app.get '/networks/:id', authentication, networks.show
  app.get '/networks/?', authentication, networks.index
  app.post '/networks/?', authentication, networks.create
