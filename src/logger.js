// Generated by CoffeeScript 1.3.1
(function() {
  var Config, ConsoleLogger, NullLogger, logger, loggerFactory, sharedConsoleLogger, sharedNullLogger;

  Config = require('../config');

  sharedNullLogger = null;

  NullLogger = (function() {

    NullLogger.name = 'NullLogger';

    function NullLogger() {}

    NullLogger.prototype.log = function(message) {};

    return NullLogger;

  })();

  NullLogger.instance = function() {
    if (sharedNullLogger) {
      return sharedNullLogger;
    }
    return sharedNullLogger = new NullLogger();
  };

  sharedConsoleLogger = null;

  ConsoleLogger = (function() {

    ConsoleLogger.name = 'ConsoleLogger';

    function ConsoleLogger() {}

    ConsoleLogger.prototype.log = function(mesage) {
      console.log("LOG: => " + mesage);
      return true;
    };

    return ConsoleLogger;

  })();

  ConsoleLogger.instance = function() {
    if (sharedConsoleLogger) {
      return sharedConsoleLogger;
    }
    return sharedConsoleLogger = new ConsoleLogger();
  };

  loggerFactory = function() {
    switch (Config.loggerType) {
      case "nullLogger":
        return NullLogger.instance();
        break;
      case "consoleLogger":
        return ConsoleLogger.instance();
        break;
      default:
        return NullLogger.instance();
    }
  };

  logger = loggerFactory();

  module.exports = logger;

}).call(this);
