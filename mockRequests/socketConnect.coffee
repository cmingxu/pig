net = require 'net'
Config = require '../config'

class MockRequest
  @requestAndSendData: (data) ->
    stream = new net.Stream()
    stream.connect Config.port, Config.host
    stream.write data

  @multipleConnections: (num) ->
    [0...num].map ->
      stream = new net.Stream()
      stream.on "connect", -> console.log 'connected'
      stream.on "data", (data)-> console.log data.toString()
      stream.connect Config.port, Config.host
      stream

module.exports.MockRequest = MockRequest


