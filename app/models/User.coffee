mongoose = require 'mongoose'

UserSchema = new mongoose.Schema(
  name: { type: String }
  avatar: { type: String }
  token: { type: String, unique: true, required: true }
)

UserSchema.statics =
  all: (cb) -> this.find().exec(cb)

UserSchema.statics.findByToken = (token, cbk) ->
  this.findOne token: token, cbk

User = mongoose.model 'User', UserSchema
module.exports = User
