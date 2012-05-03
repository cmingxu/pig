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

	
	purgeIdeal: ->


ConnectionManager.sharedInstance = ->
	sharedInstance || new ConnectionManager



	


exports = module.exports = ConnectionManager.sharedInstance
