mongoose = require 'mongoose'
util = require('util')
Network = mongoose.model 'Network'

exports.index = (req, res) ->
  req.checkQuery('lat', 'Latitude must be provided').notEmpty()
  req.checkQuery('lon', 'Longitude must be provided').notEmpty()
      # Network.all (err, networks) ->
      #     res.send err if err
      #     res.json users

exports.create = (req, res) ->
  req.checkBody('lat', 'Invalid latitude param').isFloat()
  req.checkBody('lon', 'Invalid latitude param').isFloat()

  errors = req.validationErrors()
  if errors
    res.send(400, errors: errors)
    return

  params =
    name: req.body.name
    location: [req.body.lon, req.body.lat]

  Network.findOrCreate params, (error, network, created) ->
    if error
      res.json 400, error
    else if created
      network.members.push(req.user)
      network.save (err) ->
        res.json err if err
        Network.findById(network._id)
          .select 'location name members -_id'
          .populate(path: 'members', select: 'name avatar -_id')
          .exec (err, network) ->
            res.json err if err
            res.json 201, network if not err
    else
      res.json 200, network

exports.show = (req, res) ->
  User.findById(req.params.id).exec (err, user) ->
    res.send err if err
    return next new Error 'No user found' unless user
    res.json user
  return

exports.update = (req, res) ->
  User.findByIdAndUpdate req.params.id, req.query, (err, user) ->
    res.send err if err
    return next new Error 'No user found' unless user
    return res.json status: 'ok'
  return

exports.destroy = (req, res) ->
  User.findOneAndRemove req.params.id, (err, user) ->
    res.send err if err
    return next new Error 'No user found' unless user
    res.json status: 'ok'
  return
