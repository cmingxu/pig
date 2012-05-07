// Generated by CoffeeScript 1.3.1
(function() {
  var Config, MockRequest, net;

  net = require('net');

  Config = require('../config');

  MockRequest = (function() {

    MockRequest.name = 'MockRequest';

    function MockRequest() {}

    MockRequest.requestAndSendData = function(data) {
      var stream;
      stream = new net.Stream();
      stream.connect(Config.port, Config.host);
      return stream.write(data);
    };

    MockRequest.multipleConnections = function(num) {
      var _i, _results;
      return (function() {
        _results = [];
        for (var _i = 0; 0 <= num ? _i < num : _i > num; 0 <= num ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this).map(function() {
        var stream;
        stream = new net.Stream();
        stream.on("connect", function() {
          return console.log('connected');
        });
        stream.on("data", function(data) {
          return console.log(data.toString());
        });
        stream.connect(Config.port, Config.host);
        return stream;
      });
    };

    return MockRequest;

  })();

  module.exports.MockRequest = MockRequest;

}).call(this);