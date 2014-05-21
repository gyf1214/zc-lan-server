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
		pac = packet.parse buffer
		if pac?
			console.log "send to: #{pac.dest_addr}"
			pac.src_addr = data.virtual
			if pac.dest_addr is '255.255.255.255'
				console.log "transfer to broadcast"
				for add, other of sockets
					unless other is sock
						console.log "transfer to: #{other.server_data.address}"
						other.write packet.dump(pac)
			else if sockets[pac.dest_addr]?
				other = sockets[pac.dest_addr]
				console.log "transfer to: #{other.server_data.address}"
				other.write packet.dump(pac)
			else
				console.log 'bad data'
		else
			console.log 'bad data'

	sock.on 'close', ->
		console.log "#{data.address} disconnected"
		delete sockets[data.virtual]

	sock.on 'error', ->

.listen config.port, config.host, ->
	console.log "Listening on #{config.host}:#{config.port}"