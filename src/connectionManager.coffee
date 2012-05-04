#
# ConnectionManager include logics handle multiple client connections
#

sharedInstance = null
class ConnectionManager
	constructor: (@option) ->
		return sharedInstance if sharedInstance
		@connection_pool = []	
		@option ||= {}
		@option.size ||= 100
	
	size: ()->
		@connection_pool.length
	
	add: (socket_connection) -> 
		@connection_pool << socket_connection
		console.log @connection_pool.length
	
	remove: (socket_connection) ->

	cp: ->
		@connection_pool

	
	purgeIdeal: ->


ConnectionManager.sharedInstance = ->
	sharedInstance || new ConnectionManager()



	


exports = module.exports = ConnectionManager
