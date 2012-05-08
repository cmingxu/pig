# PostOffice 
# Stream parse into package and deliver
# Every client connection/socket should have one PostOffice to handle
# data unpack, turn stream into discrete package

ActionConstructWorld  = require('./schema').ActionConstructWorld
logger = require './logger' 

# default frame size, maximum to be MTU of TCP
DEFAULT_FRAME_SIZE = 1024

# buffer pool size, should turn this into dynamic 
BUFFER_POOL_SIZE   = 10

class Envelop
	constructor: (buffer_size)->
		@data_buffer = new Buffer(buffer_size)
		@data_length = 0
		@read_offset = 0

	fillData: (data) -> 
		data.copy @data_buffer, 0, 0, data.length
		@data_length = data.length

	empty: ->
		@data_length = 0
		@read_offset = 0

	destroy: ->
		@data_buffer = null

	unpackPackage: ->
		while true
			# read 32 bit length
			len = @data_buffer.readUInt32BE(@read_offset)
			@read_offset += len
			# read 32 bit protobuf schema
			protobufSchemaId = @data_buffer.readUInt32BE(@read_offset + 4)
			# protobuf data
			break if @read_offset >= @data_length 

	netData: ->
		@data_buffer[@read_offset..@data_length]


class PostOffice
	constructor:  ->
		@envelop_pool = []
		@envelop_pool.push(new Envelop(DEFAULT_FRAME_SIZE)) for i in [1..BUFFER_POOL_SIZE]
		@empty_pool  = @envelop_pool
		@occupied_pool = []

	# stream data event emitted, put data into PostOffice
	enqueueData: (data) ->
		envelop = @empty_pool.pop() 
		if !envelop
			@empty_pool.push new Envelop DEFAULT_FRAME_SIZE
			envelop = @empty_pool.pop() 
		envelop.fillData data
		@occupied_pool.push(envelop)
		@unpackPackage()

	# unpack incoming package
	unpackPackage: ->

	packPackage: ->

	# GC buffers
	destroy: ->
		@envelop_pool.forEach (envelop) ->
			envelop.destroy()




module.exports.PostOffice = PostOffice
module.exports.Envelop = Envelop
