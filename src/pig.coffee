net = require 'net'
Config = require '../config'
logger = require './logger' 
ConnectionManager = require './connectionManager'
DataReceiver = require('./dataReceiver').DataReceiver
Schema = require("./schema")

class Pig
	constructor: ->
		@cm = new ConnectionManager()

	run: ->
		self = this
		server = net.createServer (stream)-> 
			dataReceiver = new DataReceiver()

			stream.on 'data', (data) -> 
				logger.log 'server receive data'
				self.onDataHandler(data, dataReceiver)

			stream.on 'end',  -> 
				self.cm.remove stream
				logger.log self.cm.size()

		# accept
		server.on 'connection', (socket) ->
			self.cm.add socket
			logger.log self.cm.size()

		# bind & listen
		server.listen Config.port, Config.host
		
		logger.log "server running on port #{Config.port} and pid #{process.pid}"
	
	# temptive handler
	onDataHandler: (data, dataReceiver) ->
		data = new Buffer(data)
		dataReceiver.pushData data
		dataReceiver.readBatchSync().forEach (aPackage) ->
			console.log aPackage




	
		

module.exports = Pig


