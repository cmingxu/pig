net = require 'net'
Config = require '../config'
logger = require './logger' 
DataReceiver = require('./dataReceiver').DataReceiver
Schema = require("./schema")
Ninja  = require('./ninja')

class Pig

  run: ->
    server = net.createServer (stream) =>
      # dataReceiver = new DataReceiver()

      server.on 'connection', (socket) =>
        @onConnectionHandler(socket)
        logger.log 'new client connect'

    # bind & listen
    server.listen Config.port, Config.host

    logger.log "server running on port #{Config.port} and pid #{process.pid}"

  onConnectionHandler: (con) ->
    ninja = new Ninja(con)
    ninja.joinRoom


module.exports = Pig


