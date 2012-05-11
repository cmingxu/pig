require 'should'
require 'net'
net   = require 'net'
Room  = require '../src/room'
Ninja = require '../src/ninja'

describe 'room', ->
  beforeEach ->
    @room = new Room()
    @socket = new net.Socket()
    @ninja1 = new Ninja @socket
    @ninja2 = new Ninja @socket
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
        {
          position: 0.3
          speedX: 0.3
          speedY: 0.5
          type: 1
          delay: 1.3
          fruitId: 10
        }
        {
          position: 0.3
          speedX: 0.3
          speedY: 0.5
          type: 2
          delay: 1.3
          fruitId: 100
        }
      ]

  it 'should have correct id', ->
    @room.roomId.should.eql 0
    @room2 = new Room
    @room2.roomId.should.eql 1

  it 'should able to accept ninja', ->
    @room.state().should.eql 'empty'
    @room.accept @ninja1
    @room.state().should.eql 'available'
    @room.accept @ninja2
    @room.state().should.eql 'full'

  it 'should generate a fruit flow and send to two players when they are ready', ->
    @room.generateFruitFlow()
    @room.fruitFlow.actionCode.should.eql 1
    @room.fruitFlow.fruitFlow.should.an.instanceof Array

  describe 'after game started', ->

    beforeEach ->
      @room.fruitFlow = @fruitFlow
      @room.recordFlow()

      @room.clear()

    it 'should record flow correctly', ->
      @room.fruitAcquire.should.be.empty
      @room.fruits[0].should.eql [0]
      @room.fruits[1].should.eql [10]
      @room.fruits[2].should.eql [100]

    it 'should judge fruit cut corrently', ->
      @room.fruitFlow = @fruitFlow
      @room.recordFlow()

  


