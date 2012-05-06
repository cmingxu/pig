require './testHelper'
Envelop = require('../src/postOffice').Envelop
PostOffice = require('../src/postOffice').PostOffice

testEnvelop = (test) ->
  @envelop = new Envelop(1024)
  test.equal(@envelop.read_offset, 0)
  test.equal(@envelop.data_length, 0)
  test.equal(@envelop.data_buffer.length, 1024)

  @envelop.read_offset = 100
  test.equal(@envelop.read_offset, 100)

  @envelop.read_offset = 0
  @envelop.fillData(new Buffer(1000))
  test.equal(@envelop.data_length, 1000)
  test.done()


testPostOffice = (test) ->
  setUp: ->
    @postOffice = new PostOffice()
  tearDown: ->
  test.ok(true)
  test.done()


module.exports.testEnvelop = testEnvelop
module.exports.testPostOffice = testPostOffice
