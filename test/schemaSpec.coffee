schema = require '../src/schema'
require 'should'

describe 'schema', ->
	it 'should load all schema successful', ->
		FruitFlow          = schema.FruitFlow
		CuttedFruit        = schema.CuttedFruit
		ChangeScore        = schema.ChangeScore
		GameOver           = schema.GameOver
