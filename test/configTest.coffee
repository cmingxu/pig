require './testHelper'

Config = require '../config'

testConfig = (test) ->  
	test.equal(Config.port, 10000)
	test.equal(Config.timeout, 20)
	test.equal(Config.loggerType, "consoleLogger")
	test.done()


module.exports.testConfig = testConfig

