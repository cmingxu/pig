# redis access logic here

redis = require 'redis-node'
logger = require './logger'
Config = require '../config'

class Storage
	constructor: ->
	


class RedisStorge extends Storage
	constructor: ->
		@client = redis.createClient() 

	desposal: ->
		@client.close()

	set: (k, v, callback) -> 
		@client.set(k, v, callback)
	
	get: (k, callback) -> 
		@client.get(k, callback)

# TODO
#createStorage (storage) ->
	
module.exports = RedisStorge
