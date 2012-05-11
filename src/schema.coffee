fs = require('fs')
Schema = require('protobuf').Schema
schemas = new Schema(fs.readFileSync("./protobufSchema.desc"))

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

module.exports =  { Position, ActorInfo, Login, AddActor, DelActor, detectSchema }
