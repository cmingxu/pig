fs = require('fs')
Schema = require('protobuf').Schema
buffer = fs.readFileSync(process.env.PWD + "/protobufSchema.desc")
schemas = new Schema(buffer)

Position  = schemas['bootcamp.Position']
ActorInfo = schemas['bootcamp.ActorInfo']
Login     = schemas['bootcamp.Login']
AddActor  = schemas['bootcamp.AddActor']
DelActor  = schemas['bootcamp.DelActor']

detectSchema = (actionCode) ->
  switch actionCode
    when 0x00000001 then Login
    when 0x00000002 then AddActor
    when 0x00000003 then DelActor
    else throw new Error("Can't parse the dataSchema")

Login.prototype.enqueueActor = (actor) ->
  @actors = [] unless @actors
  @actors.push actor

Login.prototype.toProtobuf = ->
  buffer = Login.serialize(@toJson())
  b = new Buffer(8 + buffer.length)
  b.writeUInt32BE(b.length, 0)
  b.writeUInt32BE(1, 4)
  buffer.copy(b, 8)
  b
  
Login.prototype.toJson = ->
  json =
    msgId: 1
    infoList:
      @actors

  json


module.exports =  { Position, ActorInfo, Login, AddActor, DelActor, detectSchema }
