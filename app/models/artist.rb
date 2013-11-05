class Artist < ActiveRecord::Base
	has_attached_file :image, 
		:path => ':rails_root/public/system/:class/:attachment/:id_partition/:style.:extension',
		:url => '/system/:class/:attachment/:id_partition/:style.:extension',
		:styles => { :normal => ["300x400>", :png], :thumb => ["110x110", :png] },
		:default_url => 'missing.png'

	has_many :posts
	has_many :events
	has_many :albums
  has_many :videos

	NAME_MAX_LENGTH = 32
	REFERENCE_MAX_LENGTH = 24
	validates :name, :presence => true
	validates :name, :length => { :maximum => NAME_MAX_LENGTH }

	validates :reference, :presence => true
	validates :reference, :length => { :maximum => REFERENCE_MAX_LENGTH }
	validates :reference, :format => { :with => /\A[a-z0-9]+([-_]?[a-z0-9]+)*\z/ }
	validates :reference, :uniqueness => { :case_sensitive => false }
	validates :reference, :exclusion => { :in => %w( aktualnosci wydarzenia wiadomosci filmy wydawnictwa informacje artysci ) }

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
