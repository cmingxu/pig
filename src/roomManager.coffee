Room = require './room'

class RoomManager
	instance = null

	@instance: ->
		if instance?
			instance 
		else
			instance = new RoomManager

	constructor: ->
		@rooms = []	

	size: ()->
		@rooms.length

	add: (room) -> 
		@rooms.push room

	rooms: ->
		@rooms

	pick: ->
		if @rooms.length is 0
			room = new Room
			@add room
			room
		else
			result = []
			result.push room for room in @rooms when room.state() == 'available'
			if result.length isnt 0
				result[0]
			else
				@rooms[0]

module.exports = RoomManager
