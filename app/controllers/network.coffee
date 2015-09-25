mongoose = require 'mongoose'
util = require('util')
helpers = require('../helpers')
Network = mongoose.model 'Network'

exports.index = (req, res, next) ->
  req.checkQuery('lat', 'Latitude must be provided').notEmpty()
  req.checkQuery('lon', 'Longitude must be provided').notEmpty()
  Network.findByLocation req.query.lon, req.query.lat, (err, networks) ->
    if err
      next(err)
    else
      res.json networks

exports.create = (req, res, next) ->
  console.log req.body
  req.checkBody('lat', 'Invalid latitude param').isFloat()
  req.checkBody('lon', 'Invalid latitude param').isFloat()

  errors = req.validationErrors()
  if errors
    res.send(400, errors: errors)
    return

  params =
    name: req.body.name
    location: [req.body.lon, req.body.lat]

  fetch_network = (id, callback) ->
    Network.findById(id)
      .select 'location name members'
      .populate(path: 'members', select: 'name avatar')
      .exec (err, network) ->
        next(err) if err
        callback(network) if callback

  Network.findOrCreate params, (error, network, created) ->
    if error
      next 400, error
    else
      network.members.addToSet(req.user)
      network.save (err) ->
        next(err) if err
        fetch_network network._id, (network) ->
          if created
            res.json 201, network
          else
            res.json 200, network

exports.show = (req, res, next) ->
  Network.findById(req.params.id)
    .select 'location name members'
    .populate(path: 'members', select: 'name avatar')
    .exec (err, network) ->
      if err
        res.send(err)
        next new Error 'No network found' unless network
      else
        helpers.prepend_baseurl(req, 'avatar', network.members)
        res.json network
