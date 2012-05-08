net = require 'net'
Config = require '../config'
logger = require './logger' 
ConnectionManager = require './connectionManager'

PostOffice  = require('./postOffice').PostOffice

class Pig
	constructor: ->
		@cm = new ConnectionManager()

	run: ->
		self = this
		server = net.createServer (stream)-> 
			postOffice = new PostOffice()
			stream.setEncoding "utf8"

			# stream on connected, happend after sever connected
			stream.on 'connect', (socketFd) ->
				logger.log 'connect'
				stream.write "accepted\r\n"

			stream.on 'data', (data) -> 
				self.onDataHandler(data, postOffice)
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
	
	# temptive handler
	onDataHandler: (data, postOffice) ->
		data = new Buffer(data)
		postOffice.enqueueData data



	
		

module.exports = Pig

