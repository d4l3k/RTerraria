module FlatgrassGenerator
	def FlatgrassGenerator::generate_chunk(chunk, seed, x)
		(0..15).each do |x|
			(0..63).each do |y|
					chunk.blocks[x][y].type = 1
			end
		end
	end
end
