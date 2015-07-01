commander   = require 'commander'
packageJSON = require './package.json'

class Command
  run: =>
    commander
      .version packageJSON.version
      .command 'get',      'retrieve a device using a meshblu.json'
      .command 'keygen',   'generate public/private keypair, update\n' +
               '            meshblu.json with the private key, \n' +
               '            and publish the public key'
      .command 'message',  'send a message with Meshblu'
      .command 'register', 'register a new device with Meshblu'
      .command 'subscribe','subscribe to messages to a Meshblu Device'
      .command 'update',   'update an existing device in Meshblu'
      .command 'online',   'check if Meshblu device is online'
      .command 'server-check', 'check if Meshblu server is available'
      .command 'claim', 'claim Meshblu device in Octoblu'
      .parse process.argv

    unless commander.runningCommand
      commander.outputHelp()
      process.exit 1

(new Command()).run()
