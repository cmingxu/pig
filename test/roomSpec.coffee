require 'should'
Room  = require '../src/room'
Ninja = require '../src/ninja'

describe 'room', ->
  beforeEach ->
    @room = new Room
    @ninja1 = new Ninja
    @ninja2 = new Ninja

  it 'should have correct id', ->
    @room.roomId.should.eql 0
    @room2 = new Room
    @room2.roomId.should.eql 1

  it 'should able to accept ninja', ->
    @room.state().should.eql 'empty'
    @room.accept @ninja1
    @room.state().should.eql 'available'
    @room.accept @ninja1
    @room.state().should.eql 'full'


