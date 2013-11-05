class Setting
	@@values = {}

	def self.set( key, value )
		@@values[key] = value
	end

	def self.get( key )
		@@values[key]
	end
end
