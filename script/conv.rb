# encoding: utf-8
album_id = 0
a = ARGV.select { |e| e =~ /--album_id=/ }
unless a.empty? then
	m = a.first.match( /--album_id=(\d+)/ )
	unless m.nil?
		album_id = m[1].to_i
	else
		puts 'Album identifier must be a number'
		exit 2
	end
else
	puts 'Specify required parameter --album_id='
	exit 1
end

begin
	album = Album.find( album_id )
rescue ActiveRecord::RecordNotFound
	puts 'Album not found'
	exit 3
end

source_path = File.join( ENV['PWD'], 'db', 'assets', 'albums', sprintf( '%03d', album_id ) )
release_path = File.join( source_path, 'release' )
album.make_release( source_path, release_path )

