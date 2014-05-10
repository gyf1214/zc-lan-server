require './config'

global.packet = 
	parse: (buffer) ->
		unless buffer.toString('utf8', 0, config.magic.length) is config.magic
			return null
		else
			src = []
			dest = []
			src[i] = buffer.readUInt8 i + 2 for i in [0..3]
			dest[i] = buffer.readUInt8 i + 6 for i in [0..3]
			src_ret = src.join '.'
			dest_ret = dest.join '.'
			ret = 
				src_addr	: src_ret
				dest_addr	: dest_ret
				data		: buffer.slice 10
			return ret
