Setting.set 'donations_info_url', '/karoryfer-lecolds/darowizny'
Setting.set 'karoryfer.youtube.url', 'http://www.youtube.com/user/KaroryferLecolds'
Setting.set 'karoryfer.facebook.url', 'http://www.facebook.com/karoryfer'
Setting.set 'karoryfer.twitter.url', 'http://www.twitter.com/karoryfer'
Setting.set 'karoryfer.flattr.url', 'http://flattr.com/profile/karoryfer'

Publisher.instance.name = 'Karoryfer Lecolds'
Publisher.instance.url = 'http://www.karoryfer.com'
Artist.admin_reference = 'karoryfer-lecolds'
Uploader::Release.album_store_dir = File.join( Rails.root, 'public', 'downloads', 'wydawnictwa' )
Uploader::Release.track_store_dir = File.join( Rails.root, 'public', 'downloads', 'tracks' )
Uploader::CustomRelease.store_dir = File.join( Rails.root, 'public', 'downloads', 'wydawnictwa' )
Attachment::Uploader.store_dir = File.join( Rails.root, 'public', 'uploads', 'attachments' )
Track::Uploader.store_dir = File.join( Rails.root, 'db', 'tracks' )
Uploader::ArtistImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'artysci' )
Uploader::AlbumImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'wydawnictwa' )
Uploader::EventImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'wydarzenia' )

