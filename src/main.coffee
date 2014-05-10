net = require 'net'
require './config'
require './packet'
global.sockets = {}

net.createServer (sock) ->
	console.log "Connected with #{sock.remoteAddress}"

	data = sock.server_data = {}
	data.address = sock.remoteAddress
	data.virtual = config.ip + "#{Math.floor(Math.random() * 255)}.#{Math.floor(Math.random() * 255)}"
	console.log "Virtual IP: #{data.virtual}"
	sockets[data.virtual] = sock

	sock.on 'data', (buffer) ->
		console.log "recieved from: #{data.address}"
		pack = packet.parse buffer
		if pack? and data.address is pack.src_addr
			console.log "send to: #{pack.dest_addr}"
			if sockets[pack.dest_addr]?
				other = sockets[pack.dest_addr]
				console.log "transfer to: #{other.server_data.address}"
				other.write pack.data
			else
				console.log 'bad data'
		else
			console.log 'bad data'

	sock.on 'close', ->
		console.log "#{data.address} disconnected"
		delete sockets[data.virtual]
		console.log sockets

	sock.on 'error', ->

.listen config.port, config.host, ->
	console.log "Listening on #{config.host}:#{config.port}"