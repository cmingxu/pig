fs = require('fs')
Schema = require('protobuf').Schema
schema = new Schema(fs.readFileSync('./protobufSchema.desc'))

ActionConstructWorld = schema['pig.ActionConstructWorld']
aActionConstructWorldPackage = {x: 10, y: 100, type: "Box"}
serialized = ActionConstructWorld.serialize(aActionConstructWorldPackage)

detectSchema = (actionCode) ->
	switch actionCode
		when 0x00000001 then ActionConstructWorld
		# else throw new Error("Can't parse the dataSchema")
		else ActionConstructWorld

module.exports = { ActionConstructWorld, detectSchema }
