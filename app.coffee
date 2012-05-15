fs = require 'fs'
Pig = require "./src/pig"

pigServer = new Pig()
pigServer.run()


# write pid to temp/pig.pid when app start
pidStream = fs.createWriteStream("./tmp/pig.pid");
pidStream.once 'open', (fd) -> 
  pidStream.write process.pid
	


# unlink pid when server down
process.on 'exit', ->
	fs.unlink "./tmp/pig.pid"


# dump usful status info here, with SIGUSR1 
process.on 'SIGUSR1', ->
	message = [
		"concurrent connection now: " + pigServer.cm.size() ,
		"memusage: rss = " + process.memoryUsage().rss + ", heapTotal=" +  process.memoryUsage().heapTotal 
	]
	fs.writeFile("./tmp/status", message.join("\n"))

module.exports = pigServer
