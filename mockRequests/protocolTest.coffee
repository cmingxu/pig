net = require 'net'
Config = require '../config'
schemas = require '../src/schema'


actorInfo = (guid) ->
  { guid: guid, resName: "house", pos: { x: 1.1, y: 2.2 } }


aAddActor = (guid)->
  json =
    msgId: 2
    info: 
      actorInfo guid
  AddActor = schemas.AddActor
  length = AddActor.serialize(json).length
  length = 8 + length
  buffer = new Buffer(length)
  buffer.writeUInt32BE(length, 0)
  buffer.writeUInt32BE(2, 4)
  AddActor.serialize(json).copy(buffer, 8)
  buffer

aDelActor = (guid)->
  json =
    msgId: 3
    guid: guid

  DelActor = schemas.DelActor
  length = DelActor.serialize(json).length
  length = 8 + length
  buffer = new Buffer(length)
  buffer.writeUInt32BE(length, 0)
  buffer.writeUInt32BE(3, 4)
  DelActor.serialize(json).copy(buffer, 8)
  console.log buffer
  buffer

class MockRequest
  @connect: ->
    stream = new net.Stream()
    stream.on "data", (data)-> 
      console.log (a = Login.parse(data.slice(8)))
      stream.end()
      
    stream.on "connect", -> console.log 'connected'
    Login = schemas.Login

    stream.connect Config.port, Config.host

  @addActor: (guid)->
    stream = new net.Stream()
    stream.on "connect", -> console.log 'connected'
    stream.connect Config.port, Config.host
    stream.write aAddActor(guid)
    stream.end()

  @removeActor: (guid) ->
    stream = new net.Stream()
    stream.on "connect", -> console.log 'connected'
    stream.connect Config.port, Config.host
    stream.write aDelActor(guid)
    stream.end()

#MockRequest.addActor("uid")

#Login = schemas.Login
#PlayerData = require("../src/playerData")
#(new PlayerData()).currentMapPackage (data) ->
#  console.log data
#  console.log( Login.parse( data.slice(8) ))
#setTimeout(MockRequest.connect, 1000)
setTimeout(MockRequest.removeActor("uid"), 5000)
setTimeout(MockRequest.connect, 10000)


