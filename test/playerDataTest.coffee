PlayerData = require("../src/playerData")

testBuild = (test) -> 
	player = new PlayerData("test1")
	player.flush()
	player.build(0,0,PlayerData.HOUSE_TYPE)
	player.build(1,1,PlayerData.HOUSE_TYPE)
	player.getTotalMap (err, dict) ->
		originDict = {}
		originDict["0.0"] = PlayerData.HOUSE_TYPE
		originDict["1.1"] = PlayerData.HOUSE_TYPE
		test.deepEqual(dict, originDict)
		player.disposal()
		test.done()

testRemove = (test) ->
	player = new PlayerData("test1")
	player.flush()
	player.build(0,0,PlayerData.HOUSE_TYPE)
	player.remove(0,0)
	player.disposal()
	test.done()

testCompareLocation = (test) ->
	test.equal(PlayerData.compareLocation("0.0",0,0,1),true)
	test.equal(PlayerData.compareLocation("2,2",0,0,1),false)
	test.done()

testRetrieveOne = (test) ->
	player = new PlayerData("test1")
	player.flush()
	player.build(0,0,PlayerData.HOUSE_TYPE)
	player.retrieveItems 0, 0, 0, (err,item) ->
		test.deepEqual([["0.0"], [PlayerData.HOUSE_TYPE]], item)
		player.disposal()
		test.done()
	
testRetrieveMany = (test) ->
	player = new PlayerData("test1")
	player.flush()
	player.build(0,0,PlayerData.HOUSE_TYPE)
	player.build(1,1,PlayerData.HOUSE_TYPE)
	player.build(0,1,PlayerData.HOUSE_TYPE)
	player.build(2,2,PlayerData.FARM_TYPE)
	player.retrieveItems 2, 2, 1, (err,items) ->
		[locations,types] = items
		test.deepEqual(locations,["1.1","0.1","2.2"])
		test.deepEqual(types,[PlayerData.HOUSE_TYPE, PlayerData.HOUSE_TYPE, PlayerData.FARM_TYPE])
		player.disposal()
		test.done()

exports.testBuild = testBuild
exports.testRemove = testRemove
exports.testCompareLocation = testCompareLocation
exports.testRetrieveOne = testRetrieveOne
exports.testRetrieveMany = testRetrieveMany