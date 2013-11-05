class Page < ActiveRecord::Base
	TITLE_MAX_LENGTH = 40

	validates_presence_of :reference
	validates_format_of :reference, :with => /\A[a-z0-9]+(-[a-z0-9]+)*\z/ 
	validates_uniqueness_of :reference, :case_sensitive => false
  validates_presence_of :title
  validates_length_of :title, :maximum => TITLE_MAX_LENGTH

	def self.get ref
		Page.find_or_initialize_by_reference( ref )
	end

	def to_param
		reference
	end

	def self.find( *args )
		if args.first.is_a? String
			find_by_reference( args.delete_at( 0 ).downcase, args )
		else
			super( *args )
		end 
	end
end
