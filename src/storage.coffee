# redis access logic here

redis = require 'redis'
logger = require './logger'
Config = require '../config'

class Storage
	constructor: ->
	


class RedisStorge extends Storage
	constructor: ->
		@client = redis.createClient(Config.redisPort,Config.redisHost)
		@client.select(Config.redisDB) 

	disposal: ->
		@client.quit()

	set: (k, v, callback) -> 
		@client.set(k, v, callback)
	
	get: (k, callback) -> 
		@client.get(k, callback)

	hset: (hk, k, v, callback) ->
		@client.hset(hk, k, v, callback)

	hget: (hk, k, callback) ->
		@client.hget(hk, k, callback)

	hgetall: (hk, callback) ->
		@client.hgetall(hk, callback)

	hmget: (hk, key..., callback) ->
		@client.hmget(hk, key..., callback)

	del: (k, callback) ->
		@client.del(k, callback)

	hdel: (hk, k, callback) ->
		@client.hdel(hk, k, callback)

	hkeys: (hk, callback) ->
		@client.hkeys(hk, callback)


# TODO
#createStorage (storage) ->
	
module.exports = RedisStorge
