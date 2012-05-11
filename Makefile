SRC_FILES = app.coffee config.coffee test/*.coffee src/*.coffee mockRequests/*.coffee
SRC_JS_FILES = app.js config.js test/*.js src/*.js mockRequests/*.js
TEST_FILES = test/*Test.js

all: run

run: compile compile_protobuf
	node app.js 

test: compile
	nodeunit $(TEST_FILES)
	mocha  test/dataReceiverSpec.js

compile:
	coffee -c $(SRC_FILES)

clean:
	rm $(SRC_JS_FILES)   &> /dev/null
	
compile_protobuf: 
	protoc ./db/protobufSchema.proto -o ./db/protobufSchema.desc


status: 
	kill -USR1 `cat ./tmp/pig.pid` 
	cat ./tmp/status

stop:
	kill -9 `cat ./tmp/pig.pid`
