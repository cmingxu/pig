#default length circle buffer
BUFFER_SIZE = 2048

class DataReceiver
  constructor: ->
    @size = BUFFER_SIZE
  pushData: (data)->
    @endPoint += data.length

class CircleBuffer
  constructor: (size=BUFFER_SIZE) ->
    @buffer   = new Buffer(size)
    @startPos = 0
    @endPos   = 0

  push: (sourceBuffer) ->
    if @endPos >= @startPos
      # detect buffer flow error
      throw new Error("circle buffer flow error!") if sourceBuffer.length + @endPos - @startPos > @length()
      # copy data
      if sourceBuffer.length + @endPos > @length()
        if @endPos is @length()
          sourceBuffer.copy @buffer
          @endPos = sourceBuffer.length
        else
          sourceBuffer.copy @buffer, @endPos, 0, @length() - @endPos
          sourceBuffer.copy @buffer, 0, @length() - @endPos
          @endPos = sourceBuffer.length - @length() + @endPos
      else
        sourceBuffer.copy @buffer, @endPos
        @endPos += sourceBuffer.length
    else
      # detect buffer flow error
      throw new Error("circle buffer flow error!") if sourceBuffer.length >= (@startPos - @endPos)
      # copy data
      sourceBuffer.copy @buffer, @endPos
      @endPos += sourceBuffer.length

  read: (length) ->
    resultBuffer = new Buffer(length)
    if @endPos >= @startPos
      throw new Error("no enough data to read") if length > @endPos - @startPos + 1
      @buffer.copy resultBuffer, 0, @startPos
      @startPos += length
    else
      throw new Error("no enough data to read") if length > @length() + @endPos - @startPos
      if @length() - @startPos < length
        @buffer.copy resultBuffer, 0, @startPos, @length()
        @buffer.copy resultBuffer, @length() - @startPos, 0, @endPos
        @startPos = length - @length() + @startPos
      else
        @buffer.copy resultBuffer, 0, @startPos
        @startPos += length
        @startPos = 0 if @startPos is @length()


    resultBuffer

  length: ->
    @buffer.length

module.exports = { DataReceiver, CircleBuffer }
