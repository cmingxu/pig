require 'should'

CircleBuffer = require("../src/dataReceiver").CircleBuffer
DataReceiver = require("../src/dataReceiver").DataReceiver
fs = require 'fs'

Schema = require('protobuf').Schema
schema = new Schema(fs.readFileSync('protobufSchema.desc'))

describe "DataReceiver", ->
  beforeEach ->
    @dataReceiver = new DataReceiver
    AddActor = schema['bootcamp.AddActor']
    addActor = { msgId: 2, info: { guid: "guid", resName: 'house', pos: { x: 1.1, y: 1.2 } } }
    @serialized = AddActor.serialize(addActor)

    packageLenth = @serialized.length + 4 + 4
    @sourceBuffer = new Buffer packageLenth * 1
    @sourceBuffer.writeUInt32BE(packageLenth, 0)
    @sourceBuffer.writeUInt32BE(1, 4)
    @serialized.copy @sourceBuffer, 8

  it 'should insert data successful', ->
    @dataReceiver.pushData @sourceBuffer
    data = @dataReceiver.readData()
    data.slice(8).should.eql @serialized

describe "CircleBuffer", ->
  beforeEach ->
    @circleBuffer = new CircleBuffer(1000)

  it 'should have fixed length', ->
    @circleBuffer.length().should.eql 1000

  describe 'push', ->
    beforeEach ->
      @targtBuffer = new Buffer "thisisjasper", 'utf8'
    afterEach ->
      @circleBuffer.startPos = 0
      @circleBuffer.endPos = 0

    it 'should be correctly', ->
      @circleBuffer.push @targtBuffer
      @circleBuffer.startPos.should.eql 0
      @circleBuffer.endPos.should.eql 12

    it 'should append more than 2 times correctly', ->
      @circleBuffer.push @targtBuffer
      @circleBuffer.startPos.should.eql 0
      @circleBuffer.endPos.should.eql 12

      @circleBuffer.push @targtBuffer
      @circleBuffer.startPos.should.eql 0
      @circleBuffer.endPos.should.eql 24

    it 'should push correctly when endPos is smaller than startPos', ->
      @circleBuffer.startPos = 990
      @circleBuffer.endPos = 998

      @circleBuffer.push @targtBuffer
      @circleBuffer.startPos.should.eql 990
      @circleBuffer.endPos.should.eql 10

    describe "corner case", ->
      it 'should throw buffer flow exception', ->
        @circleBuffer.startPos = 0
        @circleBuffer.endPos = 987
        ( ->
          @circleBuffer.push(@targtBuffer)
        ).should.throw()

      it 'should throw buffer flow exception', ->
        @circleBuffer.startPos = 12
        @circleBuffer.endPos = 0
        ( ->
          @circleBuffer.push(@targtBuffer)
        ).should.throw()

      it 'should push data successful', ->
        @circleBuffer.startPos = 0
        @circleBuffer.endPos = 987
        @circleBuffer.push @targtBuffer
        @circleBuffer.endPos.should.eql 999

        @circleBuffer.startPos = 12
        @circleBuffer.endPos = 1000
        @circleBuffer.push @targtBuffer
        @circleBuffer.endPos.should.eql 12

  describe 'read data', ->
    beforeEach ->
      @sampleString = "thisisjasper"
      @targtBuffer = new Buffer @sampleString, 'utf8'

      @circleBuffer = new CircleBuffer(12)
      @circleBuffer.push @targtBuffer

      @circleBuffer_2 = new CircleBuffer(100)
      @circleBuffer_2.startPos = 99
      @circleBuffer_2.endPos = 99
      @circleBuffer_2.push @targtBuffer

      @circleBuffer_3 = new CircleBuffer(100)
      @circleBuffer_3.startPos = 88
      @circleBuffer_3.endPos = 88
      @circleBuffer_3.push @targtBuffer
      @circleBuffer_3.push @targtBuffer

    it 'should read correctly', ->
      @circleBuffer.read(@sampleString.length, true).toString('utf8').should.eql @sampleString
      @circleBuffer_2.read(@sampleString.length, true).toString('utf8').should.eql @sampleString
      @circleBuffer_3.read(@sampleString.length, true).toString('utf8').should.eql @sampleString

    it 'should update the startPos when read data successful', ->
      @circleBuffer.read(@sampleString.length, true)
      @circleBuffer.startPos.should.eql 12
      @circleBuffer_2.read(@sampleString.length, true).toString('utf8').should.eql @sampleString
      @circleBuffer_2.startPos.should.eql 11
      @circleBuffer_3.read(@sampleString.length, true).toString('utf8').should.eql @sampleString
      @circleBuffer_3.startPos.should.eql 0



