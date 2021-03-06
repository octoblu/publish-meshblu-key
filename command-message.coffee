_           = require 'lodash'
fs          = require 'fs'
path        = require 'path'
colors      = require 'colors'
commander   = require 'commander'
BaseCommand = require './base-command'

class MessageCommand extends BaseCommand
  parseMessage: (filename) =>
    try
      JSON.parse fs.readFileSync path.resolve(filename)
    catch error
      console.error colors.yellow error.message
      console.error colors.red '\n  Unable to open a valid message.json file'
      commander.outputHelp()
      process.exit 1

  parseOptions: =>
    commander
      .option '-d, --data <\'{"topic":"do-something"}\'>', 'Message Data [JSON]'
      .option '-a, --as <uuid>', 'the uuid to send the message as (defaults to meshblu.json)'
      .option '-f, --file <path/to/message.json>', 'Message Data [JSON FILE]'
      .usage '[options] <path/to/meshblu.json>'
      .parse process.argv

    @filename = _.first commander.args
    @data = commander.data
    @updateFileName = commander.file
    @as = commander.as

    @data = @parseMessage(@updateFileName) if @updateFileName?

    return if _.isPlainObject @data
    try
      @data = JSON.parse @data
    catch e
      commander.outputHelp()
      @die 'Invalid message json'

  run: =>
    @parseOptions()
    options = {}
    options.as = @as if @as?
    meshbluHttp = @getMeshbluHttp()
    meshbluHttp.message @data, options, (error) =>
      return @die error if error?

      process.exit 0

(new MessageCommand()).run()
