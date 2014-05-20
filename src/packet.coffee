require './config'

global.packet = 
	parse: (buffer) ->
		unless buffer.toString('utf8', 0, config.magic.length) is config.magic
			return null
		else
			src = []
			dest = []
			src[i] = buffer.readUInt8(i + config.magic.length) for i in [0..3]
			dest[i] = buffer.readUInt8(i + config.magic.length + 4) for i in [0..3]
			src_ret = src.join '.'
			dest_ret = dest.join '.'
			ret = 
				src_addr	: src_ret
				dest_addr	: dest_ret
				data		: buffer.slice(config.magic.length + 8)
			return ret

	dump: (pac) ->
		length = pac.data.length + config.magic.length + 8
		ret = new Buffer(length)
		src = pac.src_addr.split '.'
		dest = pac.dest_addr.split '.'
		ret.write 'zc'
		ret.writeUInt8(src[i], i + config.magic.length) for i in [0..3]
		ret.writeUInt8(dest[i], i + config.magic.length + 4) for i in [0..3]
		pac.data.copy(ret, config.magic.length + 8)
		ret
