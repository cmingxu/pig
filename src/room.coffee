class Room
  initId = 0

  @genRoomId: ->
    initId++

  constructor: ->
    @roomId = Room.genRoomId()
    @ninjas = []

  accept: (ninja) ->
    @ninjas.push ninja

  state: ->
    switch @ninjas.length
      when 0 then 'empty'
      when 1 then 'available'
      when 2 then 'full'
      else 'full'

module.exports = Room
