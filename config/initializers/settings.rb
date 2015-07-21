Settings.set 'donations_info_url', '/karoryfer-lecolds/informacje/darowizny'
Settings.set 'karoryfer.youtube.url', 'http://www.youtube.com/user/KaroryferLecolds'
Settings.set 'karoryfer.facebook.url', 'http://www.facebook.com/karoryfer'
Settings.set 'karoryfer.twitter.url', 'http://www.twitter.com/karoryfer'
Settings.set 'karoryfer.flattr.url', 'http://flattr.com/profile/karoryfer'
Settings.set 'karoryfer.gplus.url', 'https://plus.google.com/101590945458103175168'

Settings.set 'highlighted', [
  { 'title' => 'Sample',
    'reference' => 'karoryfer-samples'},
  {
    'title' => 'O nas',
    'reference' => 'karoryfer-lecolds'}
]
Publisher.instance.name = 'Karoryfer Lecolds'
Publisher.instance.url = 'http://www.karoryfer.com'
Uploader::Release.album_store_dir = File.join( Rails.root, 'public', 'downloads', 'wydawnictwa' )
Uploader::Release.track_store_dir = File.join( Rails.root, 'public', 'downloads', 'tracks' )
Attachment::Uploader.store_dir = File.join( Rails.root, 'public', 'uploads', 'attachments' )
Track::Uploader.store_dir = File.join( Rails.root, 'db', 'tracks' )
Uploader::ArtistImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'artysci' )
Uploader::AlbumImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'wydawnictwa' )
Uploader::EventImage.store_dir = File.join( Rails.root, 'public', 'uploads', 'obrazki', 'wydarzenia' )

