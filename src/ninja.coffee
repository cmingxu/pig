redis  = require 'redis'
logger = require './logger'

FruitFlow = require('./Schema').FruitFlow
Config = require '../config'
RoomManager = require './roomManager'
DataReceiver = require('./dataReceiver').DataReceiver
DataSender = require('./dataSender')

class Ninja
  constructor: (@socket) ->
    @dataSender = new DataSender @socket
    @dataReceiver = new DataReceiver()
    @initRedis()
    @registerListener()

  initRedis: ->
    @client = redis.createClient(Config.redisPort,Config.redisHost)
    @client.select(Config.redisDB)

  join: (@room)->
    @id = @room.ninjas.indexOf this

  registerListener: ->
    @socket.on 'data', (data) =>
      data = new Buffer(data)
      @dataReceiver.pushData data
      @dataReceiver.readBatchSync().forEach (message) =>
        @handleMessage message

  handleMessage: (message) ->
    console.log message
    # switch message.actionCode
      # when 1 then @room.cutFruit(message.fruit_id, @id)
    @room.generateFruitFlow()
    @sendFruitFlow @room.fruitFlow

  sendFruitFlow: (flow) ->
    @dataSender.sendData @dataSender.serialize(FruitFlow, flow)

  gameOver: (flow) ->
    @home.clear()

module.exports = Ninja
