# frozen_string_literal: true

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  FIXTURES_DIR = File.expand_path('../fixtures/tracks', __dir__)

  describe Track do
    it 'validates title presence' do
      track = Track.sham! :build
      [nil, '', ' ', '   '].each do |title|
        track.title = title
        refute track.valid?
        assert track.errors[:title].include? I18n.t(
          'activerecord.errors.models.track.attributes.title.blank'
        )
      end
    end

    it 'validates title length' do
      track = Track.sham! :build
      track.title = 'a' * (Track::TITLE_MAX_LENGTH + 1)
      refute track.valid?
      assert track.errors[:title].include? I18n.t(
        'activerecord.errors.models.track.attributes.title.too_long'
      )

      track.title = 'a' * Track::TITLE_MAX_LENGTH
      assert track.valid?
    end

    it 'validates album presence' do
      track = Track.sham! :build
      track.album_id = nil
      refute track.valid?
      assert track.errors[:album_id].include? I18n.t(
        'activerecord.errors.models.track.attributes.album_id.blank'
      )
    end

    it 'validates rank presence' do
      track = Track.sham! :build
      track.rank = nil
      refute track.valid?
      assert track.errors[:rank].include? I18n.t(
        'activerecord.errors.models.track.attributes.rank.blank'
      )
    end

    it 'validates rank uniqueness for album' do
      existing_track = Track.sham!
      track = Track.sham! :build, album: existing_track.album
      track.rank = existing_track.rank
      refute track.valid?
      assert track.errors[:rank].include? I18n.t(
        'activerecord.errors.models.track.attributes.rank.taken'
      )
    end

    it 'allows repeating ranks in different albums' do
      existing_track = Track.sham!
      track = Track.sham! :build, album: Album.sham!
      track.rank = existing_track.rank
      assert track.valid?
    end

    it 'allows blank comments' do
      track = Track.sham! :build
      track.comment = nil
      assert track.valid?

      track.comment = ''
      assert track.valid?
    end

    it 'defaults order by rank' do
      album = Album.sham!
      5.times { Track.sham! album: album }
      album_tracks = album.tracks
      i = 0
      album_tracks.each do |track|
        assert i < track.rank
        i = track.rank
      end
    end

    it 'allows nil file' do
      track = Track.sham! :build, file: nil
      assert track.valid?
    end

    it 'accepts only wav files' do
      ['att1.jpg', 'att2.pdf', 'att3.txt'].each do |filename|
        file_path = File.join(FIXTURES_DIR, '..', 'attachments', filename)
        track = Track.sham! :build, file: File.open(file_path)
        refute track.valid?
        refute track.errors[:file].empty?
      end
      file_path = File.join(FIXTURES_DIR, '1.wav')
      track = Track.sham! :build, file: File.open(file_path)
      assert track.valid?
    end

    it 'accepts existing file path' do
      Settings.filer_root = '/tmp/filer'
      FileUtils.mkdir_p(Settings.filer_root)
      FileUtils.cp(File.join(FIXTURES_DIR, '1.wav'), Settings.filer_root)
      track = Track.sham!(file: '1.wav')
      assert track.valid?
      assert track.file?
    end

    it 'rejects not existing file path' do
      Settings.filer_root = '/tmp/filer'
      FileUtils.mkdir_p(Settings.filer_root)
      FileUtils.cp(File.join(FIXTURES_DIR, '1.wav'), Settings.filer_root)
      track = Track.sham!(file: '2.wav')
      assert track.valid?
      refute track.file?
    end

    describe 'on save' do
      it 'places file in proper dir' do
        track = Track.sham! file: File.open(File.join(FIXTURES_DIR, '1.wav'))
        filename = track.file.identifier
        track = Track.find track.id
        file_path = File.join(Rails.root, 'db', 'tracks', (track.id / 1000).to_s, "#{File.basename(filename, '.wav')}.wav")
        assert_equal file_path, track.file.current_path
        assert File.exist? file_path
      end

      it 'replaces old file with new' do
        track = Track.sham! file: File.open(File.join(FIXTURES_DIR, '1.wav'))
        old_file_path = track.file.current_path
        assert File.exist? old_file_path

        track.file = File.open(File.join(FIXTURES_DIR, '2.wav'))
        track.save
        assert_equal old_file_path, track.file.current_path
        assert File.exist? old_file_path
      end
    end

    describe 'on destroy' do
      it 'removes file from storage' do
        track = Track.sham! file: File.open(File.join(FIXTURES_DIR, '1.wav'))
        file_path = track.file.current_path
        assert File.exist? file_path

        track.destroy
        refute File.exist? file_path
      end
    end
  end
end
