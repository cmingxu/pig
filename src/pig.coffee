net = require 'net'
Config = require '../config'
logger = require './logger' 
ConnectionManager = require './connectionManager'
DataReceiver = require('./dataReceiver').DataReceiver
Schema = require("./schema")

class Pig
  constructor: ->
    @cm = new ConnectionManager()

  run: ->
    pig_self = this
    server = net.createServer (stream)-> 
      dataReceiver = new DataReceiver()
      connection_self = this
      stream.on 'data', (data) -> 
        try
          pig_self.onDataHandler data, dataReceiver
        catch err
          logger.log 'data format error'
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
    dataReceiver.readBatchSync().forEach (aPackage) ->

  # when new client connected
  onConectionHandler: (socket) ->
    @cm.add socket
    logger.log @cm.size()


  # when client disconnected
  onEndHandler: (socket) ->
    @cm.remove socket
    logger.log @cm.size()







module.exports = Pig


