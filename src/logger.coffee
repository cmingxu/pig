##
# Logger
##

Config = require '../config'


sharedNullLogger = null
class NullLogger
	constructor: ->
	log: (message)->

NullLogger.instance = -> 
	return sharedNullLogger if sharedNullLogger
	return sharedNullLogger =  new NullLogger()


sharedConsoleLogger = null
class ConsoleLogger
	constructor: ->
	log: (mesage)  ->
		console.log "LOG: => " + mesage
		true
	
ConsoleLogger.instance = -> 
	return sharedConsoleLogger if sharedConsoleLogger 
	return sharedConsoleLogger = new ConsoleLogger()


loggerFactory = ->
	switch Config.loggerType 
		when "nullLogger" 
			return NullLogger.instance()
			break
		when "consoleLogger"
			return ConsoleLogger.instance()
			break
		else
			return NullLogger.instance()
	


logger = loggerFactory()
module.exports = logger
