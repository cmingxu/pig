require './testHelper'
Logger = require '../src/logger'

testLogger = (test) -> 
	test.ok(true)
	test.done()

module.exports.testLogger = testLogger
