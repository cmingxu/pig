net = require 'net'
Config = require '../config'
logger = require './logger' 
ConnectionManager = require './connectionManager'
DataReceiver = require('./dataReceiver').DataReceiver
Schema = require("./schema")
AddActor = Schema.AddActor
DelActor = Schema.DelActor
PlayerData = require("./playerData")
map = new PlayerData()

class Pig
  constructor: ->
    @cm = new ConnectionManager()

  run: ->
    pig_self = this
    server = net.createServer (stream)-> 
      dataReceiver = new DataReceiver()
      dataReceiver.socket_connection = stream 
      connection_self = this
      stream.on 'data', (data) -> 
        try
          pig_self.onDataHandler data, dataReceiver
        catch err
          logger.log 'data format error'
          # clear data cache if error raised
          connection_self = new DataReceiver()

      stream.on 'end',  -> 
        pig_self.onEndHandler stream

    # accept
    server.on 'connection', (socket) ->
      pig_self.onConectionHandler socket

    # bind & listen
    server.listen Config.port, Config.host
    logger.log "server running on port #{Config.port} and pid #{process.pid}"

  # temptive handler
  onDataHandler: (data, dataReceiver) ->
    logger.log 'server receive data'
    dataReceiver.pushData data
    dataReceiver.readBatch (aPackage) =>
      packageSwitcher(aPackage, @cm.withoutSelf(dataReceiver.socket_connection))

  # when new client connected
  onConectionHandler: (socket) ->
    @cm.add socket
    # send map data here
    map.currentMapPackage (data) -> 
      socket.write data
    logger.log @cm.size()

  # when client disconnected
  onEndHandler: (socket) ->
    @cm.remove socket
    logger.log @cm.size()

  packageSwitcher = (aPackage, other_connections) ->
    if aPackage instanceof AddActor
      map.set aPackage.info.guid, JSON.stringify(aPackage.info)

      dataPacakage = AddActor.addActorWith(aPackage)
      other_connections.forEach (stream) -> 
        stream.write(dataPacakage)

    if aPackage instanceof DelActor
      map.remove aPackage.guid

      dataPacakage = DelActor.delActorWith(aPackage)
      other_connections.forEach (stream) -> 
        stream.write(dataPacakage)








module.exports = Pig


