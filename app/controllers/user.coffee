mongoose = require 'mongoose'
User = mongoose.model 'User'
uuid = require('node-uuid')
path = require('path')
fs = require('fs')
consts = require('../../config/consts')
helpers = require('../helpers')

clean_avatar = (avatar, token) ->
  if avatar
    tempPath = avatar.path
    ext = path.extname(avatar.name)
    filename = "avatar_#{token}#{ext}"
    relative_path = path.join(consts.UPLOADS_PATH, "#{filename}")
    targetPath = path.resolve(relative_path)

    fs.rename tempPath, targetPath, (err) ->
      next(err) if err

    avatar = relative_path
  else
    avatar = null

  return avatar

exports.create = (req, res, next) ->
  name = req.body.name
  token = uuid.v4()

  params =
    name: name
    token: token
    avatar: clean_avatar(req.files.avatar, token)

  User.create params, (err, user) ->
    res.send err if err
    helpers.prepend_baseurl(req, 'avatar', user)
    res.json user

exports.update = (req, res, next) ->
  params = {}
  token = req.headers.authorization
  params.name = req.body.name if req.body.name
  params.avatar = clean_avatar(req.files.avatar, token) if req.files.avatar
  req.user.update params, (err, user) ->
    next(err) if err
    res.send 200
