net = require 'net'
Config = require '../config'
logger = require './logger' 
ConnectionManager = require './connectionManager'

class Pig
	constructor: ->
		@cm = new ConnectionManager()

	run: ->
		server = net.createServer (stream)-> 
			stream.setEncoding "utf8"

			stream.on 'connect', (socketFd) ->
				logger.log 'connect'
				stream.write "hello\r\n"

			stream.on 'data', (data) -> 
				logger.log 'data'
				stream.write data


			stream.on 'end',  -> 
				logger.log 'end'
				stream.end

		self = this
		server.on 'connection', (socket) ->
			self.cm.add socket
			console.log self.cm.cp()
			logger.log self.cm.size()
			logger.log "connection"
			console.log(socket)

		server.listen Config.port, Config.host
		
		logger.log "server running on port #{Config.port}"
		

module.exports = Pig

