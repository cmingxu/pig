RedisStorage = require '../src/storage'

getRandomNumber = () ->
	''+Math.floor( (Math.random() * 100000) );

testStorageSetGet = (test) -> 
	client = new RedisStorage()
	
	key = "SetGet"
	value = getRandomNumber()

	client.set key, value, (err, status) ->
		test.equal(status, 'OK')

	client.get key, (err, res) ->
		throw err if err
		test.equal(res, value)
		test.done()
		client.disposal()

testStorageHsetHget = (test) ->
	client = new RedisStorage()
	hashKey = "HsetHgetHashKey"
	key = "HsetHgetkey"
	value = getRandomNumber()
	client.hset hashKey, key, value, (err, status) ->

	client.hget hashKey, key, (err, res) ->
		throw err if err
		test.equal(res, value)
		test.done()
		client.disposal()

testStorageHmsetHmget = (test) ->
	client = new RedisStorage()
	hashKey = "HmsetHmgetHashKey"
	key1 = "HmsetHmgetKey1"
	key2 = "HmsetHmgetKey2"
	value1 = getRandomNumber();
	value2 = getRandomNumber();
	client.hset hashKey, key1, value1, (err, list) ->
	client.hset hashKey, key2, value2, (err, list) ->
	client.hmget hashKey, key1, key2, (err, list) ->
		throw err if err
		test.deepEqual(list, [value1, value2])
		test.done()
		client.disposal()

testStorageHgetall = (test) ->
	client = new RedisStorage()
	hashKey = "HgetallHashKey"
	key1 = "HgetallKey1"
	key2 = "HgetallKey2"
	value1 = getRandomNumber();
	value2 = getRandomNumber();
	client.hset hashKey, key1, value1, (err, list) ->
	client.hset hashKey, key2, value2, (err, list) ->
	client.hgetall hashKey, (err, dict) ->
		throw err if err
		originDict = {}
		originDict[key1] = value1
		originDict[key2] = value2
		test.deepEqual(dict, originDict)
		test.done()
		client.disposal()

module.exports.testStorageSetGet = testStorageSetGet
module.exports.testStorageHsetHget = testStorageHsetHget
module.exports.testStorageHmsetHmget = testStorageHmsetHmget
module.exports.testStorageHgetall = testStorageHgetall