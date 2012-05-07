fs = require('fs')
Schema = require('protobuf_for_node').Schema
schema = new Schema(fs.readFileSync('./protobufSchema.desc'))

ActionConstructWorld = schema['pig.ActionConstructWorld']
aActionConstructWorldPackage = {x: 10, y: 100, type: "Box"}
serialized = ActionConstructWorld.serialize(aActionConstructWorldPackage)

module.exports.ActionConstructWorld = ActionConstructWorld
