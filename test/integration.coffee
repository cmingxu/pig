net = require 'net'
Config = require '../config'



class IntegrationTest



########## Connection Test ########
CONNECTION_SIZE = 200
start = 0

IntegrationTest.makeConnection = ->
	stream = new net.Stream()
	stream.connect(Config.port, Config.host)
	IntegrationTest.makeConnection() and start++ until start > CONNECTION_SIZE 

######## Data Test #########

fs = require('fs')
Schema = require('protobuf_for_node').Schema
schema = new Schema(fs.readFileSync('../protobufSchema.desc'))
console.log schema
ActionConstructWorld = schema['pig.ActionConstructWorld']
aActionConstructWorldPackage = {x: 10, y: 100, type: "Box"}
serialized = ActionConstructWorld.serialize(aActionConstructWorldPackage)


IntegrationTest.transferPackage= (dataPackage)->
	stream = net.createConnection Config.port
	stream.on "connect", -> 
		stream.write(dataPackage)

	stream.destroy

# send a protobuf package
packageLenth = serialized.length + 4 + 4
buffer = new Buffer(packageLenth)
buffer.writeUInt32LE(packageLenth, 0)
buffer.writeUInt32LE(1, 4)
serialized.copy(buffer, 8, 0, serialized.length)
console.log buffer.length
IntegrationTest.transferPackage(buffer)









