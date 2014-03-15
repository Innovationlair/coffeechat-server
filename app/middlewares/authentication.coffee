User = require('../models/User')

module.exports = ->
  return (req, res, next) ->
    token = req.headers.authorization
    if token
      User.findByToken token, (error, user) ->
        if not error
          if user
            req.user = user
            next()
          else
            res.send(400, "Invalid authentication token: #{token}")
        else
          next(error)
    else
      # Maybe raise Unauthorized???
      res.send(401, "Unauthorized request!")
