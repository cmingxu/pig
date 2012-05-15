require 'should'
require 'net'
Room  = require '../src/room'
Ninja = require '../src/ninja'

describe 'room', ->
  beforeEach ->
    @room = new Room()
    @socket =
      on: ->
        "on"
      write: ->
        "write"
    @ninja1 = new Ninja @socket
    @ninja2 = new Ninja @socket
    @fruitFlow =
      actionCode: 0
      fruitFlow: [
        {
          position: 0.3
          speedX: 0.3
          speedY: 0.5
          type: 2
          delay: 1.3
          fruitId: 0
        }
        {
          position: 0.3
          speedX: 0.3
          speedY: 0.5
          type: 3
          delay: 1.3
          fruitId: 10
        }
        {
          position: 0.3
          speedX: 0.3
          speedY: 0.5
          type: 4
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
    @room.fruitFlow.actionCode.should.eql 0
    @room.fruitFlow.fruitFlow.should.an.instanceof Array

  describe 'after game started', ->

    beforeEach ->
      @room.accept @ninja1
      @room.accept @ninja2
      @room.clear()

      @room.fruitFlow = @fruitFlow
      @room.recordFlow()

    it 'should get user and opponent correctly', ->
      @room.getUserById(@ninja1.id).should.eql @ninja1
      @room.getOpponentById(@ninja1.id).should.eql @ninja2

    it 'should record flow correctly', ->
      @room.fruitAcquire.should.be.empty
      @room.fruits[0].should.eql [0]
      @room.fruits[1].should.eql [10]
      @room.fruits[2].should.eql [100]

    it 'should judge fruit cut corrently', ->
      @room.cutFruit 0, 0
      @room.fruitAcquire[0].should.eql 0

    it 'should calcScore correctly', ->
      @room.calcScore(@ninja1, 0).should.eql 1
      @room.calcScore(@ninja1, 10).should.eql -2
      @room.calcScore(@ninja1, 100).should.eql 3

      @room.calcScore(@ninja1, 1).should.eql 0
