require './testHelper'

Config = require '../config'

testConfig = (test) ->  
	test.equal(Config.port, 8888)
	test.equal(Config.timeout, 20)
	test.equal(Config.loggerType, "consoleLogger")
	test.done()


module.exports.testConfig = testConfig

