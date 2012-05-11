fs = require('fs')
Schema = require('protobuf').Schema
buffer = fs.readFileSync(process.env.PWD + "/protobufSchema.desc")
schemas = new Schema(buffer)

Position  = schemas['bootcamp.Position']
ActorInfo = schemas['bootcamp.ActorInfo']
Login     = schemas['bootcamp.Login']
AddActor  = schemas['bootcamp.AddActor']
DelActor  = schemas['bootcamp.DelActor']

# BaseSchema
# common features for schema
class BaseSchema

BaseSchema.prototype.toProtobuf = ->
  buffer = Login.serialize(@toJson())
  b = new Buffer(8 + buffer.length)
  b.writeUInt32BE(b.length, 0)
  b.writeUInt32BE(1, 4)
  buffer.copy(b, 8)
  b
  
BaseSchema.prototype.toJson = ->
  throw new Error("should implemented in child class")

# extend from BaseSchema
Login    extends BaseSchema
AddActor extends BaseSchema
DelActor extends BaseSchema

# login specfic function
Login.prototype.toJson = ->
  json =
    msgId: 1
    infoList:
      @actors
  json

Login.prototype.enqueueActor = (actor) ->
  @actors = [] unless @actors
  @actors.push actor

# addActor specfic function

AddActor.prototype.toJson = ->
  json = 
    msgId: 2
    info:
      @actor

AddActor.prototype.actor = (actor) ->
  @actor = actor

AddActor.addActorWith = (actorPackage) ->
  addActor = new AddActor()
  addActor.actor = actorPackage.info
  addActor.toProtobuf()

# DelActor specfic function

DelActor.prototype.toJson = ->
  json =
    msgId: 3
    guid: @guid

DelActor.prototype.guid = (guid) ->
  @guid = guid

DelActor.delActorWith = (guid) ->
  delActor = new DelActor()
  delActor.guid = guid
  delActor.toProtobuf()


detectSchema = (actionCode) ->
  switch actionCode
    when 0x00000001 then Login
    when 0x00000002 then AddActor
    when 0x00000003 then DelActor
    else throw new Error("Can't parse the dataSchema")

module.exports =  { Position, ActorInfo, Login, AddActor, DelActor, detectSchema }
