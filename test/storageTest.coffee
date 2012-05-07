RedisStorage = require '../src/storage'


testStorage = (test) ->
  client = new RedisStorage()

  client.set "hello", "world", (err, status) ->
    throw err if err
    test.ok status

  client.get "hello", (err, res) ->
    throw err if err
    test.equal res, "world"
    client.disposal()
    test.done()


module.exports.testStorage = testStorage
