require 'test_helper'

describe PurchaseMailer do
  include ActionMailer::TestHelper

  before do
    @artist = Artist.sham!(name: 'The Artist', reference: 'the-artist', contact_email: 'contact@the-artist.com')
    @album = Album.sham!(artist: @artist, title: 'The Album', reference: 'the-album')
  end

  describe 'digital release' do
    before do
      @release = Release.sham!(album: @album, format: 'flac')
      @purchase = Purchase.sham!(release: @release, reference_id: 'xyz')
    end

    it 'sends confirmation email' do
      email = PurchaseMailer.with(email: 'test@example.com', name: 'Michał').confirmation(@release, 'xyz')
      assert_emails 1 do
        email.deliver_now
      end
      assert_equal ['lecolds@karoryfer.com'], email.from
      assert_equal ['test@example.com'], email.to
      assert_equal 'The Artist - The Album', email.subject

      text_body = email.text_part.body.to_s
      html_body = email.html_part.body.to_s

      expected = 'https://www.example.com/the-artist/wydawnictwa/the-album/flac?pid=xyz'
      assert_match expected, text_body
      assert_match expected, html_body

      assert_match 'Michał', text_body
      assert_match 'Michał', html_body

      expected = 'contact@the-artist.com'
      assert_match expected, text_body
      assert_match expected, html_body
    end

    it 'displays email in greeting when name not present' do
      email = PurchaseMailer.with(email: 'test@example.com').confirmation(@release, 'xyz')
      assert_emails 1 do
        email.deliver_now
      end
      text_body = email.text_part.body.to_s
      html_body = email.html_part.body.to_s

      expected = 'test@example.com'
      assert_match expected, text_body
      assert_match expected, html_body
    end
  end

  describe 'phisical release' do
    before do
      @release = Release.sham!(album: @album, format: 'cd')
      @purchase = Purchase.sham!(release: @release, reference_id: 'xyz')
    end

    it 'sends confirmation email' do
      email = PurchaseMailer.with(email: 'test@example.com', name: 'Michał').confirmation(@release, 'xyz')
      assert_emails 1 do
        email.deliver_now
      end
      assert_equal ['lecolds@karoryfer.com'], email.from
      assert_equal ['test@example.com'], email.to
      assert_equal 'The Artist - The Album', email.subject

      text_body = email.text_part.body.to_s
      html_body = email.html_part.body.to_s

      assert_match 'Michał', text_body
      assert_match 'Michał', html_body

      expected = 'contact@the-artist.com'
      assert_match expected, text_body
      assert_match expected, html_body
    end
  end
end
