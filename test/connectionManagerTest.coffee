require './testHelper'
ConnectionManager = require '../src/connectionManager'

cm  = new ConnectionManager()

testCm = (test) ->
  test.equal(cm.size(), 0)
  cm.add(123)
  test.equal(cm.size(), 1)
  test.done()


module.exports.testCm = testCm

