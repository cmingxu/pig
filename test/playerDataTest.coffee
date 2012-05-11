PlayerData = require("../src/playerData")
schemas    = require("../src/schema")

actorInfo = (guid) ->
  { guid: guid, resName: "house", pos: { x: 1.1, y: 2.2 } }

testSet = (test) -> 
  player = new PlayerData()
  player.flush()
  player.set("key","value")
  player.getTotalMap (err, dict) ->
    originDict = {}
    originDict["key"] = "value"
    test.deepEqual(dict, originDict)
    player.disposal()
    test.done()

testRemove = (test) ->
  player = new PlayerData()
  player.flush()
  player.set("key", "value")
  player.remove "key", (res) ->
    test.equal(res, "value")
  player.disposal()
  test.done()

testCurrentMapPackage = (test) ->
  player = new PlayerData()
  player.flush()
  player.set("key", JSON.stringify(actorInfo("key")))
  player.set("key1", JSON.stringify(actorInfo("key1")))
  json =
    msgId: 1
    infoList: 
      [ actorInfo("key"), actorInfo("key1") ]
  Login = schemas.Login
  length = Login.serialize(json).length
  length = 8 + length
  buffer = new Buffer(length)
  buffer.writeUInt32BE(length, 0)
  buffer.writeUInt32BE(1, 4)
  Login.serialize(json).copy(buffer, 8)
  player.currentMapPackage (callback)->
    test.equal(buffer.length, arguments[0].length)
    test.deepEqual(buffer, arguments[0])
    player.disposal()
    test.done()


exports.testSet    = testSet
exports.testRemove = testRemove
exports.testCurrentMapPackage = testCurrentMapPackage
