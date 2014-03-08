mongoose = require 'mongoose'

NetworkSchema = new mongoose.Schema(
  name: { type: String, required: true }
  members: [type: mongoose.Schema.Types.ObjectId, ref: 'User']
  location: { type: [Number], index: '2dsphere', required: true }
)

NetworkSchema.statics.findOrCreate = (params, callback) ->
  query = Network.findOne(name: params.name).select 'location name members -_id'
  query = query.where('location').near
    center:
      "type": "Point"
      "coordinates": params.location
    maxDistance: 500
  query.exec (error, network) ->
    if not network
      Network.create params, (error, network) ->
        created = true
        callback(error, network, created)
    else
      created = false
      callback(error, network, created)

Network = mongoose.model "Network", NetworkSchema

module.exports = Network
