MockRequest = require('./socketConnect').MockRequest

streams = MockRequest.multipleConnections 3, (data) -> 
  console.log data



