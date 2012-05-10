fs = require 'fs'
Pig = require "./src/pig"

pigServer = new Pig()
pigServer.run()


# write pid to temp/pig.pid when app start
fs.open "./tmp/pig.pid", "w", (err, fd) ->
	throw err if err
	fs.write fd, process.pid

	


# unlink pid when server down
process.on 'exit', ->
	fs.unlink "./tmp/pig.pid"


# dump usful status info here, with SIGUSR1 
process.on 'SIGUSR1', ->
	message = [
		"concurrent connection now: " + pigServer.cm.size() ,
		"memusage: rss = " + process.memoryUsage().rss + ", heapTotal=" +  process.memoryUsage().heapTotal 
	]

	fs.open "./tmp/status", "w", (err, fd) ->
		throw err if err
		fs.write fd, message.join("\n")
	

module.exports = pigServer

