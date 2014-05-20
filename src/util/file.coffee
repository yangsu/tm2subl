fs = require 'fs'
path = require 'path'

exports.read = (p, cb) -> fs.readFile(p, 'utf8', cb)
exports.write = (p, content, cb) -> fs.writeFile(p, content, cb)

exports.withExtension = (p, newExt) ->
  ext = path.extname(p)
  dirname = path.dirname(p)
  basename = path.basename(p, ext)
  path.join(dirname, "#{basename}.#{newExt}")