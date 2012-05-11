class Room
  initId = 0

  @genRoomId: ->
    initId++

  constructor: ->
    @roomId = Room.genRoomId()
    @ninjas = []
    @fruitAcquire = []
    @fruits = [[], [], []]

  clear: ->
    @fruitAcquire = []
    @fruits = [[], [], []]

  accept: (ninja) ->
    @ninjas.push ninja
    ninja.join this
    if @state is 'full'
      @generateFruitFlow()
      @recordFlow()
      @ninjas.forEach (ninja) ->
        ninja.sendFruitFlow @fruitFlow

  state: ->
    switch @ninjas.length
      when 0 then 'empty'
      when 1 then 'available'
      when 2 then 'full'
      else 'full'

  generateFruitFlow: ->
    @fruitFlow =
      actionCode: 1
      fruitFlow: [
        {
          position: 0.3
          speedX: 0.3
          speedY: 0.5
          type: 0
          delay: 1.3
          fruitId: 0
        }
      ]

  recordFlow: ->
    for fruit in @fruitFlow.fruitFlow
      @fruits[fruit.type].push fruit.fruitId

  cutFruit: (fruitId, userId) ->
    unless @fruitAcquire[fruitId]?
      @fruitAcquire[fruitId] = userId
      changeScore getUserById, fruitId, 1
      changeScore getOpponentById, fruitId, -1

  changeScore: (ninja, fruitId, who) ->
    @ninja.changeScore calcScore(ninja, fruitId), who

  getUserById: (userId) ->
    @ninjas[userId]

  getOpponentById: (userId) ->
    @ninjas[1-id]

  calcScore: (ninja, fruitId) ->
    if @fruits[ninja.id].indexOf(fruitId) is -1
      if @fruits[1 - ninja.id].indexOf(fruitId) is -1
        3
      else
        -2
    else
      1

module.exports = Room
