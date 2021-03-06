# frozen_string_literal: true

fixtures_dir = File.expand_path('fixtures', __dir__)

def fake_string(klass, method, min, max)
  name = nil
  loop do
    name = Faker::Lorem.characters(Random.new.rand(min..max))
    break unless klass.where(method => name).exists?
  end
  name
end

def next_integer
  @counter ||= Fiber.new do
    i = 1
    loop do
      Fiber.yield i
      i += 1
    end
  end
  @counter.resume
end

Sham.config(Artist) do |c|
  c.attributes do
    name = Faker::Name.name
    { name: name, reference: name.parameterize }
  end
end

Sham.config(Album) do |c|
  c.attributes do
    title = Faker::Name.name
    {
      published: true,
      artist: Sham::Nested.new(Artist),
      year: (2000..2020).to_a.sample,
      reference: title.parameterize,
      title: title,
      license_symbol: License.all.sample.symbol
    }
  end
end

Sham.config(Album, :published) do |c|
  c.attributes do
    title = Faker::Name.name
    {
      published: true,
      artist: Sham::Nested.new(Artist),
      year: (2000..2020).to_a.sample,
      reference: title.parameterize,
      title: title,
      license_symbol: License.all.sample.symbol
    }
  end
end

Sham.config(Album, :unpublished) do |c|
  c.attributes do
    title = Faker::Name.name
    {
      published: false,
      artist: Sham::Nested.new(Artist),
      year: (2000..2020).to_a.sample,
      reference: title.parameterize,
      title: title,
      license_symbol: License.all.sample.symbol
    }
  end
end

Sham.config(Attachment) do |c|
  c.attributes do
    {
      album: Sham::Nested.new(Album),
      file: File.open("#{fixtures_dir}/attachments/att1.jpg")
    }
  end
end

Sham.config(Release) do |c|
  c.attributes do
    {
      album: Sham::Nested.new(Album),
      format: Release::FORMATS.sample,
      file: File.open("#{fixtures_dir}/release.zip"),
      external_url: 'https://test.bandcamp.com/album/test'
    }
  end
end

Sham.config(Purchase) do |c|
  c.attributes do
    {
      release: Sham::Nested.new(Release)
    }
  end
end

Sham.config(Track) do |c|
  c.attributes do
    {
      album: Sham::Nested.new(Album),
      title: Faker::Lorem.words.join(' '),
      rank: (Track.maximum(:rank) || 0) + 1
    }
  end
end
Sham.config(Track, :with_file) do |c|
  c.attributes do
    {
      album: Sham::Nested.new(Album),
      title: Faker::Lorem.words.join(' '),
      rank: (Track.maximum(:rank) || 0) + 1,
      file: File.open("#{fixtures_dir}/tracks/1.wav")
    }
  end
end

Sham.config(Page) do |c|
  c.attributes do
    {
      artist: Sham::Nested.new(Artist),
      title: Faker::Name.name,
      reference: Faker::Name.name.parameterize,
      content: Faker::Lorem.paragraph
    }
  end
end

Sham.config(User) do |c|
  c.assign do
    {
      admin: false,
      login: Faker::Lorem.characters(Random.new.rand(6..32)),
      email: Faker::Internet.email,
      password: passwd = Faker::Lorem.characters(Random.new.rand(8..32)),
      password_confirmation: passwd,
      password_salt: salt = Authlogic::Random.hex_token,
      crypted_password: Authlogic::CryptoProviders::Sha512.encrypt('pass' + salt),
      persistence_token: Authlogic::Random.hex_token
    }
  end
end

Sham.config(User, :admin) do |c|
  c.assign do
    {
      admin: true,
      login: Faker::Lorem.words.join,
      email: Faker::Internet.email,
      password: passwd = Faker::Lorem.words.join,
      password_confirmation: passwd,
      password_salt: salt = Authlogic::Random.hex_token,
      crypted_password: Authlogic::CryptoProviders::Sha512.encrypt('pass' + salt),
      persistence_token: Authlogic::Random.hex_token
    }
  end
end
