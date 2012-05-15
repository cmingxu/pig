class Room
  initId = 0

  @genRoomId: ->
    initId++

  constructor: ->
    @roomId = Room.genRoomId()
    @ninjas = []
    @fruitAcquire = []
    @fruits = [[], [], []]
    @iStart = 2
    @bufferTime = 20

  clear: ->
    @fruitAcquire = []
    @fruits = [[], [], []]

  accept: (ninja) ->
    @ninjas.push ninja
    ninja.join this
    if @state() is 'full'
      @generateFruitFlow()
      @recordFlow()
      @ninjas.forEach (ninja) =>
        ninja.sendFruitFlow @fruitFlow

  state: ->
    switch @ninjas.length
      when 0 then 'empty'
      when 1 then 'available'
      when 2 then 'full'
      else 'full'

  gameOver: ->
    @clear()

  generateFruitFlow: ->
    now = new Date()
    startTime = now.setSeconds(now.getSeconds() + @bufferTime)
    @fruitFlow = { actionCode: 0, startTimestamp: startTime, fruitFlow: [{fruitId:1,position:0,speedX:2.2,speedY:10.8,type:3,delay:0.9},{fruitId:2,position:0.8,speedX:2.9,speedY:13.4,type:3,delay:1.3},{fruitId:3,position:0.7,speedX:1.5,speedY:13.8,type:3,delay:2},{fruitId:4,position:0.1,speedX:3,speedY:10.8,type:4,delay:3},{fruitId:5,position:0.9,speedX:1.8,speedY:12,type:3,delay:4.4},{fruitId:6,position:0.5,speedX:2.7,speedY:11.9,type:2,delay:5.4},{fruitId:7,position:0.1,speedX:1.8,speedY:11.6,type:4,delay:6.5},{fruitId:8,position:0.2,speedX:2.2,speedY:14.8,type:3,delay:7.4},{fruitId:9,position:0.8,speedX:2.3,speedY:10.6,type:4,delay:9},{fruitId:10,position:0.1,speedX:1.7,speedY:10.7,type:4,delay:9.9},{fruitId:11,position:1,speedX:2.3,speedY:10,type:3,delay:10.7},{fruitId:12,position:0.1,speedX:2.9,speedY:14.5,type:2,delay:11},{fruitId:13,position:0.5,speedX:1.9,speedY:13.7,type:3,delay:11.4},{fruitId:14,position:0.7,speedX:2.1,speedY:14.7,type:2,delay:12},{fruitId:15,position:0.6,speedX:1.1,speedY:11.6,type:2,delay:12},{fruitId:16,position:0,speedX:1.3,speedY:10,type:4,delay:12.9},{fruitId:17,position:0.1,speedX:1,speedY:12.9,type:2,delay:14},{fruitId:18,position:0.3,speedX:2.2,speedY:14.4,type:3,delay:14.5},{fruitId:19,position:0,speedX:2.9,speedY:12.7,type:3,delay:15},{fruitId:20,position:0,speedX:2.4,speedY:12.4,type:2,delay:15},{fruitId:21,position:0,speedX:2.1,speedY:13.1,type:3,delay:15},{fruitId:22,position:0.3,speedX:1.4,speedY:12.4,type:2,delay:15},{fruitId:23,position:0,speedX:2.6,speedY:11,type:2,delay:15.5},{fruitId:24,position:0.5,speedX:1.6,speedY:14.3,type:2,delay:16},{fruitId:25,position:0.7,speedX:1.4,speedY:13.2,type:4,delay:17},{fruitId:26,position:0.1,speedX:1.3,speedY:10.3,type:2,delay:18},{fruitId:27,position:1,speedX:1,speedY:12.3,type:2,delay:19},{fruitId:28,position:0.1,speedX:2.7,speedY:14.4,type:2,delay:19},{fruitId:29,position:0.1,speedX:2.8,speedY:13.7,type:3,delay:19},{fruitId:30,position:0.6,speedX:1.6,speedY:13.7,type:3,delay:20}]}
    # @fruitFlow = { actionCode: 0, startTimestamp: startTime, fruitFlow: [{fruitId:1,position:0,speedX:2.2,speedY:10.8,type:3,delay:0.9}] }

  recordFlow: ->
    for fruit in @fruitFlow.fruitFlow
      @fruits[fruit.type - @iStart].push fruit.fruitId

  cutFruit: (fruitId, userId) ->
    unless @fruitAcquire[fruitId]?
      @fruitAcquire[fruitId] = userId
      @getOpponentById(userId).notifyCutFruit fruitId
      score = @calcScore @getUserById(userId), fruitId
      @changeScore @getUserById(userId), score, 1
      @changeScore @getOpponentById(userId), score, -1

  changeScore: (ninja, score, who) ->
    ninja.changeScore score, who

  getUserById: (userId) ->
    @ninjas[userId]

  getOpponentById: (userId) ->
    @ninjas[1-userId]

  calcScore: (ninja, fruitId) ->
    score = 0
    score = 1  unless @fruits[ninja.id].indexOf(fruitId) is -1
    score = -2 unless @fruits[1 - ninja.id].indexOf(fruitId) is -1
    score = 3  unless @fruits[2].indexOf(fruitId) is -1
    score

module.exports = Room
