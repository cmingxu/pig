net = require 'net'
Config = require '../config'
logger = require './logger' 
ConnectionManager = require './connectionManager'

class Pig
	constructor: ->
		@cm = new ConnectionManager()

	run: ->
		self = this
		server = net.createServer (stream)-> 
			stream.setEncoding "utf8"

			# stream on connected, happend after sever connected
			stream.on 'connect', (socketFd) ->
				logger.log 'connect'
				stream.write "accepted\r\n"

			stream.on 'data', (data) -> 
				self.onDataHandler(data)
				#self.cm.broadCast(data);
				#self.cm.withoutSelf().forEach (sc)->
				#	sc.write(data)

			stream.on 'end',  -> 
				logger.log 'end'
				stream.end

		# accept
		server.on 'connection', (socket) ->
			logger.log "connection"
			self.cm.add socket
			logger.log self.cm.size()

		# bind & listen
		server.listen Config.port, Config.host
		
		logger.log "server running on port #{Config.port} and pid #{process.pid}"
	
	onDataHandler: (data) ->
    logger.log "ondata"
    logger.log data

	
		

module.exports = Pig

