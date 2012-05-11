net          = require 'net'
logger       = require './logger'
Config       = require '../config'
DataReceiver = require('./dataReceiver').DataReceiver
Schema       = require "./schema"
Ninja        = require './ninja'
RoomManager  = require './roomManager'

class Pig
  run: ->
    server = net.createServer (stream) =>
      # dataReceiver = new DataReceiver()

    server.on 'connection', (socket) =>
      logger.log 'new client connect'
      @onConnectionHandler(socket)
    # bind & listen
    server.listen Config.port, Config.host

    logger.log "server running on port #{Config.port} and pid #{process.pid}"

  onConnectionHandler: (con) ->
    ninja = new Ninja(con)
    room  = RoomManager.instance().pick()
    room.accept ninja

module.exports = Pig
