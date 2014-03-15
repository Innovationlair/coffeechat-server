path = require('path')

t = {}

t.ROOT = path.dirname(__dirname)
t.MODELS_PATH = path.resolve(__dirname, '../app/models')
t.FULL_UPLOADS_PATH = path.resolve(__dirname, '../public/uploads')
t.UPLOADS_PATH = path.relative(t.ROOT, t.FULL_UPLOADS_PATH)

module.exports = t
