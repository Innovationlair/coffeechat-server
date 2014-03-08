User = require('../models/User')

module.exports = ->
  return (req, res, next) ->
    userId = req.headers.authorization
    if userId
      User.findById userId, (error, user) ->
        if not error
          req.user = user
          next()
        else
          next(new Error('Invalid authentication token'))
    else
      # Maybe raise Unauthorized???
      next()
