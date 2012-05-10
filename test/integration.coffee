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
Schema = require('protobuf').Schema
schema = new Schema(fs.readFileSync('../protobufSchema.desc'))
console.log schema
ActionConstructWorld = schema['pig.ActionConstructWorld']
aActionConstructWorldPackage = {x: 10, y: 100, type: "Box"}
serialized = ActionConstructWorld.serialize(aActionConstructWorldPackage)


IntegrationTest.transferPackage= (dataPackage)->
	stream = net.connect Config.port, ->
		stream.write(dataPackage)
		stream.end()


# send a protobuf package

sendTwoPackage = ->
  packageLenth = serialized.length + 4 + 4
  buffer = new Buffer(packageLenth * 2)
  buffer.writeUInt32BE(packageLenth, 0)
  buffer.writeUInt32BE(1, 4)
  serialized.copy(buffer, 8, 0, serialized.length)
  buffer.copy(buffer, 17, 0, buffer.length)
  console.log buffer.length
  IntegrationTest.transferPackage(buffer)

sendTwoPackage()


sendPackagesWithDataSeprated = ->
	packageLenth = serialized.length + 4 + 4
	buffer = new Buffer(packageLenth * 2000)
	i = 0 
	offset = 0
	for i in [0..2000 - 1]
		buffer.writeUInt32BE(packageLenth, offset)
		buffer.writeUInt32BE(1, offset + 4)
		serialized.copy(buffer, offset + 8, 0, serialized.length )
		buffer.copy(buffer, offset + 17, 0, buffer.length )
		console.log buffer.length
		i = i + 1

	IntegrationTest.transferPackage(buffer)


sendPackagesWithDataSeprated()

onethounds= ->
	for i in [1..100]
		sendPackagesWithDataSeprated()

setInterval(onethounds, 1000 )


