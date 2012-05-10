redis  = require 'redis'
logger = require './logger'
Config = require '../config'
RoomManager = require './roomManager'
DataReceiver = require('./dataReceiver').DataReceiver

class Ninja
  constructor: (@socket) ->
    @dataReceiver = new DataReceiver()
    @initRedis()
    @registerListener()

  initRedis: ->
    @client = redis.createClient(Config.redisPort,Config.redisHost)
    @client.select(Config.redisDB)

  joinRoom: ->
    @room = RoomManager.instance().pick()
    @room.accept this

  registerListener: ->
    @socket.on 'data', (data) =>
      data = new Buffer(data)
      @dataReceiver.pushData data
      @dataReceiver.readBatchSync().forEach (aPackage) ->
        console.log aPackage

module.exports = Ninja
