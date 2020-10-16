# frozen_string_literal: true

require 'test_helper'

class CustomReleaseTest < ActiveSupport::TestCase
  describe 'Custom Release' do
    before do
      @artist = Artist.sham!(
        name: 'Jęczące Brzękodźwięki',
        reference: 'jeczace-brzekodzwieki'
      )
      @album = Album.sham!(
        title: 'Największe przeboje',
        artist: @artist,
        reference: 'najwieksze-przeboje'
      )
      @file_path = File.join(FIXTURES_DIR, 'release.zip')
    end

    it 'stores album release without suffix if same as extensioin' do
      release = Release.new(format: Release::ZIP, album: @album)
      release.file = File.open(@file_path)
      release.save!

      release_file_path = File.join(
        Rails.root,
        'downloads',
        'releases',
        'jeczace-brzekodzwieki',
        'jeczace-brzekodzwieki-najwieksze-przeboje.zip'
      )
      assert_equal release_file_path, release.file.path
      assert File.exist?(release_file_path)
    end

    it 'removes release on delete' do
      release = Release.create(
        format: Release::ZIP,
        album: @album,
        file: File.open(@file_path)
      )
      release_file_path = release.file.path
      assert File.exist?(release_file_path)
      release.destroy
      refute File.exist?(release_file_path)
    end
  end
end
