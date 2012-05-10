require 'should'
Room  = require '../src/room'
Ninja = require '../src/ninja'

describe 'Ninja', ->
	beforeEach ->
		@ninja = new Ninja
	
	it 'should create a redis connection', ->
		@ninja.client.should.be.ok	
	
	it 'should enable to join room', ->
		@ninja.joinRoom()
		@ninja.room.should.be.ok
		@ninja.room.state().should.eql 'available'
		
	
