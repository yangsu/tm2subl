_ = require 'lodash'
async = require 'async'
util = require '../util'
{SUBL_SNIPPET_EXT} = require '../constants'

xml2js = require('xml2js')
parser = new xml2js.Parser()
builder = new xml2js.Builder(rootName: 'snippet', headless: true)

module.exports = (snippetPath, callback) ->
  async.waterfall [
    async.apply(util.read, snippetPath)

    (content, cb) -> parser.parseString(content, cb)

    (xmlJson, cb) ->
      dict = xmlJson.plist.dict[0]
      try
        dict = _.chain(dict.key)
          .zip(dict.string)
          .object()
          .value()
        snippet = _.pick(dict, 'tabTrigger', 'scope', 'content')
        snippet.description = dict.name
        cb(null, snippet)
      catch e
        cb(e)

    (parsed, cb) ->
      sublimeSnippetPath = util.withExtension(snippetPath, SUBL_SNIPPET_EXT)
      transformed = builder.buildObject(parsed)
      util.write(sublimeSnippetPath, transformed, (e) -> if e? then cb(e) else cb(null, parsed))

  ], callback
