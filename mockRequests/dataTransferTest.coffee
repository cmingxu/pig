MockRequest = require('./socketConnect').MockRequest

streams = MockRequest.multipleConnections(1)


str = "abc"
str = str.concat("c") for i in [0..10000]
console.log str
streams[0].write(str)

