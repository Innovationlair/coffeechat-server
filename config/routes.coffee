module.exports = (app) ->
  # User routes
  users = require '../app/controllers/user'
  networks = require '../app/controllers/network'

# Users

  app.get '/users', users.index
  app.post '/users', users.create
  app.get '/users/:id', users.show
  app.post '/users/:id/update', users.update
  app.post '/users/:id/destroy', users.destroy

# Networks

  app.get '/networks/:id', networks.show
  app.post '/networks/?', networks.create
