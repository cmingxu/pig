require 'should'
RoomManager = require '../src/roomManager'
Room = require '../src/room'

describe 'RoomManager', ->
	beforeEach ->
		@manager = RoomManager.instance()
		@room    = new Room

	it 'should be able to pick a room', ->
		@manager.size().should.eql 0
		@manager.pick()
		@manager.size().should.eql 1
		@manager.pick()
		@manager.size().should.eql 1

		
		
	
