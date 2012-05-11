fs = require('fs')
Schema = require('protobuf').Schema
schema = new Schema(fs.readFileSync('./db/protobufSchema.desc'))

FruitFlow   = schema['pig.FruitFlow']
CutFruit    = schema['pig.CutFruit']
ChangeScore = schema['pig.ChangeScore']
GameOver    = schema['pig.GameOver']

schemaList = [FruitFlow, CutFruit, ChangeScore, GameOver]

detectSchema = (actionCode) ->
	schemaList[actionCode]

actionCode = (schema) ->
	schemaList.indexOf schema

module.exports = { FruitFlow, CutFruit, ChangeScore, GameOver, detectSchema, actionCode }
