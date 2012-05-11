redisStorage = require("./storage")

class PlayerData
	
	constructor: ->
		this.rs = new redisStorage()
		this.mapKey = "map"

	disposal: ->
		this.rs.disposal()

	set: (uid, serilized) ->
		this.rs.hset this.mapKey, uid, serilized, (err, status) ->

	remove: (uid, [callback]) ->
		this.rs.hdel this.mapKey, uid, (err, status) ->
      callback(status) if callback

	getTotalMap: (callback) ->
		test = this.rs.hgetall this.mapKey, (err, dict) ->
			callback(err, dict)

	flush: ->
		this.rs.del this.mapKey, (err, status) ->

module.exports = PlayerData
