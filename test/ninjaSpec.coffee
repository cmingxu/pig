require 'should'
net		= require 'net'
Room  = require '../src/room'
Ninja = require '../src/ninja'

describe 'Ninja', ->
	beforeEach ->
		@socket = new net.Socket()
		@ninja = new Ninja @socket
		@ninja_2 = new Ninja @socket
		@room  = new Room
	
	it 'should create a redis connection', ->
		@ninja.client.should.be.ok	
	
	it 'should enable to join room', ->
		@ninja.joinRoom()
		@ninja.room.should.be.ok
		@ninja.room.state().should.eql 'available'

	it 'should get id correctly', ->
		@ninja.joinRoom(@room)
		@ninja.id.should.eql 0
		@ninja_2.joinRoom(@room)
		@ninja_2.id.should.eql 1
		
	
		
	
