RedisStorage = require '../src/storage'

client = new RedisStorage()

client.set "hello", "world", (err, status) ->
  throw err if err
  console.log(status)

client.get "hello", (err, res) ->
  throw err if err
  console.log(res)


