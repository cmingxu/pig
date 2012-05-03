##
# Logger
##

config = require '../config'

class Logger
	constructor: ->

	log: (mesage)->

class NullLogger extends Logger

class ConsoleLogger extends Logger
	constructor: ->
		super

	log: (mesage)  ->
		console.log mesage + "\n"
	

Logger.loggerFactory = (logger) -> 
	switch logger
		when /nullLogger/i then new NullLogger 
		when /consoleLogger/i then new ConsoleLogger
		else 
			new NullLogger 


logger = Logger.loggerFactory(config.loggerType)


module.exports = logger
