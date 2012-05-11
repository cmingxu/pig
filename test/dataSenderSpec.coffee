require 'should'

fs	   = require('fs')
net		 = require 'net'
Schema = require('protobuf').Schema
schema = new Schema(fs.readFileSync('./db/protobufSchema.desc'))
DataSender = require('../src/dataSender')

describe 'DataSender', ->
	beforeEach ->
		@socket = new net.Socket
		@dataSender = new DataSender @socket
		@CutFruit = schema['pig.CutFruit']
		@message = { actionCode: 1, fruitId: 1 }
		@serialized = @CutFruit.serialize(@message)

		packageLenth = @serialized.length + 4 + 4
		@sourceBuffer = new Buffer packageLenth
		@sourceBuffer.writeUInt32BE(packageLenth, 0)
		@sourceBuffer.writeUInt32BE(1, 4)
		@serialized.copy @sourceBuffer, 8

	it 'should serialize data successful', ->
		serializedData = @dataSender.serialize @CutFruit, @message
		serializedData.should.eql @sourceBuffer
