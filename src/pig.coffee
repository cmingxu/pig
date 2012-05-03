net = require 'net'
config = require '../config'
logger = require './logger' 

class Pig
	constructor: ->

	run: ->
		logger.log "server running on port #{config.port}"
		

module.exports = Pig

