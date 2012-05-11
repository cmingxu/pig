redisStorage = require("./storage")
schemas      = require("./schema")
Login        = schemas.Login

class PlayerData
  constructor: ->
    this.rs = new redisStorage()
    this.mapKey = "map"

  disposal: ->
    this.rs.disposal()

  set: (uid, serilized) ->
    this.rs.hset this.mapKey, uid, serilized, (err, status) ->

  remove: (uid) ->
    console.log uid
    this.rs.hdel this.mapKey, uid, (err, status) ->
      

  getTotalMap: (callback) ->
    this.rs.hgetall this.mapKey, (err, dict) ->
      callback(err, dict)

  currentMapPackage: (callback) ->
    Login = schemas.Login
    login = new Login()
    @getTotalMap (err, dict) =>
      login.enqueueActor JSON.parse(dict[actor]) for actor of dict
      callback(login.toProtobuf())



  flush: ->
    this.rs.del this.mapKey, (err, status) ->

module.exports = PlayerData
