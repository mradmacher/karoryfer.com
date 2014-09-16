Setting.set 'donations_info_url', '/karoryfer-lecolds/informacje/darowizny'
Setting.set 'karoryfer.youtube.url', 'http://www.youtube.com/user/KaroryferLecolds'
Setting.set 'karoryfer.facebook.url', 'http://www.facebook.com/karoryfer'
Setting.set 'karoryfer.twitter.url', 'http://www.twitter.com/karoryfer'
Setting.set 'karoryfer.flattr.url', 'http://flattr.com/profile/karoryfer'
Setting.set 'karoryfer.gplus.url', 'https://plus.google.com/101590945458103175168'

Setting.set 'highlighted', [
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

