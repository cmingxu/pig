##
# Logger
##

fs = require 'fs'
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
	log: (message)  ->
		console.log "LOG: => " + message
		true
	
ConsoleLogger.instance = -> 
	return sharedConsoleLogger if sharedConsoleLogger 
	return sharedConsoleLogger = new ConsoleLogger()


sharedFileLogger = null
class FileLogger
	constructor: ->
	log: (message)  ->
		console.log message
		fs.writeFile process.env.PWD + "/tmp/logger.log", message + "\n"
		true
	
FileLogger.instance = -> 
	return sharedFileLogger if sharedFileLogger 
	return sharedFileLogger = new FileLogger()


loggerFactory = ->
	switch Config.loggerType 
		when "nullLogger" 
			return NullLogger.instance()
			break
		when "consoleLogger"
			return ConsoleLogger.instance()
			break

		when "fileLogger"
			return FileLogger.instance()
			break
		else
			return NullLogger.instance()
	


logger = loggerFactory()
module.exports = logger
