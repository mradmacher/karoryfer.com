Setting.set 'donations_info_url', '/karoryfer-lecolds/darowizny'
Setting.set 'karoryfer.youtube.url', 'http://www.youtube.com/user/KaroryferLecolds'
Setting.set 'karoryfer.facebook.url', 'http://www.facebook.com/karoryfer'
Setting.set 'karoryfer.twitter.url', 'http://www.twitter.com/karoryfer'
Setting.set 'karoryfer.flattr.url', 'http://flattr.com/profile/karoryfer'

Artist.admin_reference = 'karoryfer-lecolds'
Release::Uploader.album_store_dir = File.join( Rails.root, 'public', 'downloads', 'wydawnictwa' )
Release::Uploader.track_store_dir = File.join( Rails.root, 'public', 'downloads', 'tracks' )
Attachment::Uploader.store_dir = File.join( Rails.root, 'public', 'uploads', 'attachments' )
Track::Uploader.store_dir = File.join( Rails.root, 'db', 'tracks' )
Releaser::Base.publisher_name = 'Karoryfer Lecolds'
Releaser::Base.publisher_host = 'www.karoryfer.com'
Uploader::ArtistImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'artysci' )
Uploader::AlbumImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'wydawnictwa' )
Uploader::EventImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'wydarzenia' )

