PlayerData = require("../src/playerData")

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



exports.testSet = testSet
exports.testRemove = testRemove
