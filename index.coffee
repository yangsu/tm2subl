#!/usr/bin/env coffee
_ = require 'lodash'
glob = require 'glob'
async = require 'async'
program = require 'commander'

snippet = require './src/snippet'
util = require './src/util'
{PARALLEL_LIMIT, TM_SNIPPET_EXT} = require './src/constants'

program.version('0.0.1')

program
  .command('snippet <path>')
  .description('convert textmate snippets to sublime snippets')
  .action (path, options) ->
    async.waterfall [

      async.apply(glob, "#{path}/*.#{TM_SNIPPET_EXT}")

      (snippets, callback) ->
        ops = {}

        _.each snippets, (path) ->
          ops[path] = (cb) -> snippet(path, cb)

        async.parallelLimit(ops, PARALLEL_LIMIT, callback)

    ], (e, d) ->
      console.log JSON.stringify(d, null, 4)

program.parse(process.argv)