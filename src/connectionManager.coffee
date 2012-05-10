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
		@connection_pool.push socket_connection
	
	remove: (socket_connection) ->
		pos = @connection_pool.indexOf(socket_connection)
		@connection_pool.splice(pos, 1) if pos != -1
		@connection_pool

	cp: ->
		@connection_pool
	
	withoutSelf: (socket_connection) ->
		@connection_pool.filter (sc) ->
			sc != socket_connection

	broadCast: (message) ->
		@connection_pool.forEach (sc) ->
			sc.write(message + "\r\n")
	



ConnectionManager.sharedInstance = ->
	sharedInstance || new ConnectionManager()


exports = module.exports = ConnectionManager
