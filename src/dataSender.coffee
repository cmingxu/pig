class DataSender

	constructor: (@socket) ->
		console.log ""

	sendData: (data) ->
		@socket.write data

	serialize: (schema, data) ->
		serializedData = schema.serialize data
		packageLenth = serializedData.length + 4 + 4
		buffer = new Buffer packageLenth
		buffer.writeUInt32BE packageLenth, 0
		buffer.writeUInt32BE data.actionCode, 4
		serializedData.copy buffer, 8
		buffer

module.exports = DataSender
