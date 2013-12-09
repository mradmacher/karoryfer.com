FIXTURES_DIR = File.expand_path('../fixtures', __FILE__)

def fake_string( klass, method, min, max )
  name = nil
  loop do
    name = Faker::Lorem.characters( Random.new.rand( min..max ) )
    break unless klass.where( method => name ).exists?
  end
  name
end

def next_integer
  unless @counter
    @counter = Fiber.new do
      i = 1
      loop do
        Fiber.yield i
        i += 1
      end
    end
  end
  @counter.resume
end

Sham.config( Artist ) do |c|
  c.attributes do
    name = Faker::Name.name
    { :name => name, :reference => name.parameterize }
  end
end

Sham.config( License ) do |c|
  c.attributes do {
    :symbol => ['by', 'by-sa', 'by-nc-sa'].sample,
    :version => '3.0',
    :name => Faker::Lorem.word
  } end
end

Sham.config( Album ) do |c|
  c.attributes do
    title = Faker::Name.name
    {
      :artist => Sham::Nested.new( Artist ),
      :year => (2000..2020).to_a.sample,
      :reference => title.parameterize,
      :title => title,
      :license => Sham::Nested.new( License )
    }
  end
end

Sham.config( Album, :published ) do |c|
  c.attributes do
    title = Faker::Name.name
    {
      :published => true,
      :artist => Sham::Nested.new( Artist ),
      :year => (2000..2020).to_a.sample,
      :reference => title.parameterize,
      :title => title,
      :license => Sham::Nested.new( License )
    }
    end
end

Sham.config( Album, :unpublished ) do |c|
  c.attributes do
    title = Faker::Name.name
    {
      :published => false,
      :artist => Sham::Nested.new( Artist ),
      :year => (2000..2020).to_a.sample,
      :reference => title.parameterize,
      :title => title,
      :license => Sham::Nested.new( License )
    }
    end
end

Sham.config( Attachment ) do |c|
  c.attributes do {
    album: Sham::Nested.new( Album ),
    file: File.open( "#{FIXTURES_DIR}/attachments/att1.jpg" )
  } end
end

Sham.config( Release, :album ) do |c|
  c.attributes do {
    album: Sham::Nested.new( Album ),
    format: Release::FORMATS.sample,
  } end
end
Sham.config( Release, :track ) do |c|
  c.attributes do {
    track: Sham::Nested.new( Track ),
    format: Release::FORMATS.sample,
  } end
end
Sham.config( Release ) do |c|
  c.attributes do {
    album: Sham::Nested.new( Album ),
    format: Release::FORMATS.sample,
  } end
end

Sham.config( Track ) do |c|
  c.attributes do {
    album: Sham::Nested.new( Album ),
    title: Faker::Lorem.words.join( ' ' ),
    rank: (Track.maximum(:rank) || 0) + 1
  } end
end
Sham.config( Track, :with_file ) do |c|
  c.attributes do {
    album: Sham::Nested.new( Album ),
    title: Faker::Lorem.words.join( ' ' ),
    rank: (Track.maximum(:rank) || 0) + 1,
    file: File.open( "#{FIXTURES_DIR}/tracks/1.wav" )
  } end
end

Sham.config( Page ) do |c|
  c.attributes do {
    :title => Faker::Name.name,
    :reference => Faker::Name.name.parameterize,
    :content => Faker::Lorem.paragraph
  } end

end

Sham.config( Post ) do |c|
  c.attributes do {
    artist: Sham::Nested.new( Artist ),
    title: Faker::Name.name,
    published: true,
    body: Faker::Lorem.paragraph
  } end
end

Sham.config( Event ) do |c|
  c.attributes do {
    artist: Sham::Nested.new( Artist ),
    title: Faker::Name.name,
    published: true,
    event_date: Time.now.to_date,
    location: Faker::Address.city,
    body: Faker::Lorem.paragraph
  } end
end

Sham.config( Video ) do |c|
  c.attributes do {
    artist: Sham::Nested.new( Artist ),
    title: Faker::Name.name,
    url: Faker::Internet.url,
    body: Faker::Lorem.paragraph
  } end
end

Sham.config( User ) do |c|
  c.assign do {
    admin: false,
    login: Faker::Lorem.characters( Random.new.rand( 6..32 ) ),
    email: Faker::Internet.email,
    password: passwd = Faker::Lorem.words.join,
    password_confirmation: passwd,
    password_salt: salt = Authlogic::Random.hex_token,
    crypted_password: Authlogic::CryptoProviders::Sha512.encrypt( 'pass' + salt ),
    persistence_token: Authlogic::Random.hex_token
  } end
end

Sham.config( User, :admin ) do |c|
  c.assign do {
    admin: true,
    login: Faker::Lorem.words.join,
    email: Faker::Internet.email,
    password: passwd = Faker::Lorem.words.join,
    password_confirmation: passwd,
    password_salt: salt = Authlogic::Random.hex_token,
    crypted_password: Authlogic::CryptoProviders::Sha512.encrypt( 'pass' + salt ),
    persistence_token: Authlogic::Random.hex_token
  } end
end

Sham.config( Membership ) do |c|
  c.assign do {
    artist: Sham::Nested.new( Artist ),
    user: Sham::Nested.new( User )
  } end
end

