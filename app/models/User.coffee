mongoose = require 'mongoose'

UserSchema = new mongoose.Schema(
  name: { type: String }
  avatar: { type: String }
)

UserSchema.statics =
  all: (cb) -> this.find().exec(cb)

User = mongoose.model 'User', UserSchema
module.exports = User
