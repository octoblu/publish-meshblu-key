_       = require 'lodash'
meshblu = require 'meshblu'
url     = require 'url'

class Meshblu
  constructor: (config, callback=->) ->
    @config = config
    @connection = meshblu.createConnection @config
    @connection.on 'ready', callback
    @connection.on 'notReady', console.log

  close: =>
    @connection.close()

  generateKeyPair: =>
    @connection.generateKeyPair()

  on: =>
    @connection.on.apply @connection, arguments

  onMessage: (callback=->) =>
    @connection.on 'message', callback

  subscribe: (uuid, callback=->) =>
    @connection.subscribe uuid: uuid, callback

  unsubscribe: (uuid, callback=->) =>
    @connection.unsubscribe uuid: uuid, callback

  whoami: (callback=->) =>
    @connection.devices {uuid: @config.uuid}, (data) =>
      callback data.error, _.first data.devices

  update: (data, callback) =>
    query = _.defaults {uuid: @config.uuid}, data
    @connection.update query, callback

  message: (data, callback=->) =>
    @connection.message data, (data) =>
      callback()

module.exports = Meshblu
