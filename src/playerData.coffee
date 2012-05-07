redisStorage = require("./storage")

class PlayerData
	
	@UNBUILD_TYPE = -1
	@NOBUILD_TYPE = 0
	@HOUSE_TYPE   = 1
	@FARM_TYPE    = 2

	constructor: (id)->
		this.rs = new redisStorage()
		this.id = id
		this.mapKey = "user_#{id}_map"

	disposal: ->
		this.rs.disposal()

	getLocationKey: (x, y) ->
		"#{x}.#{y}"

	@compareLocation: (location, x, y, distance) ->
		[locationX,locationY] = location.split(".")
		result = false
		if	Math.abs(locationX - x) <= distance || Math.abs(locationY - y) <= distance
			result = true
		return result

	build: (x, y, type) ->
		key = this.getLocationKey x, y
		value = type
		this.rs.hset this.mapKey, key, value, (err, status) ->

	remove: (x, y) ->
		key = this.getLocationKey x, y
		this.rs.hdel this.mapKey, key, (err, status) ->

	getTotalMap: (callback) ->
		test = this.rs.hgetall this.mapKey, (err, dict) ->
			callback(err, dict)

	retrieveItems: (x, y, distance, callback) ->
		key = this.getLocationKey x,y
		if distance == 0
			this.rs.hget this.mapKey, key, (err, item) ->
				callback(err, [[key], [item]])
		else if distance > 0
			this.rs.hkeys this.mapKey, (err, keys) =>
				keys = (location for location in keys when PlayerData.compareLocation(location, x, y, distance))
				this.rs.hmget this.mapKey, keys..., (err, values) ->
					throw err if err
					callback(err, [keys,values])

	flush: ->
		this.rs.del this.mapKey, (err, status) ->

module.exports = PlayerData