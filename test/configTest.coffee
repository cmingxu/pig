require 'testHelper'

Config = require '../config'

testPort: (test) ->  
	test.equals(this.foo, 'bar')
	test.done()

module.exports = { testPort }

