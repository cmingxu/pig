redis  = require 'redis'
logger = require './logger'

FruitFlow = require('./Schema').FruitFlow
CutFruit = require('./Schema').CutFruit
ChangeScore = require('./Schema').ChangeScore
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
    console.log "=============== rec message ==============="
    console.log message
    console.log "=============== done rec message ==============="
    switch message.actionCode
      when 1 then @room.cutFruit(message.fruitId, @id)
      when 3 then @room.gameOver

  changeScore: (score, who)->
    @dataSender.sendData @dataSender.serialize(ChangeScore, {actionCode: 2, score: score, who: who})

  sendFruitFlow: (flow) ->
    @dataSender.sendData @dataSender.serialize(FruitFlow, flow)

  notifyCutFruit: (fruitId) ->
    @dataSender.sendData @dataSender.serialize(CutFruit, {actionCode: 1, fruitId: fruitId})

  gameOver: ->
    console.log "gameOver"
    # @home.clear()

module.exports = Ninja
