module ReleaseHelper
  def assert_tags( release, track, track_path )
    case release.format
      when Release::OGG
        assert_ogg_tags release, track, track_path
      when Release::MP3
        assert_mp3_tags release, track, track_path
      when Release::FLAC
        assert_flac_tags release, track, track_path
      else
        fail
    end
  end

  def assert_flac_tags( release, track, track_path )
    TagLib::FLAC::File.open( track_path ) do |file|
      tag = file.xiph_comment
      assert_equal track.artist.name, tag.artist
      assert_equal track.album.title, tag.album
      assert_equal track.album.year, tag.year
      assert_equal track.title, tag.title
      assert_equal track.rank, tag.track
      assert_equal track.comment, tag.comment
      assert_equal [release.release_url], tag.field_list_map['CONTACT']
      assert_equal [track.album.license.name], tag.field_list_map['LICENSE']
      assert_equal [release.publisher_name], tag.field_list_map['ORGANIZATION']
      assert_equal ["#{track.album.year} #{track.artist.name}"], tag.field_list_map['COPYRIGHT']
    end
  end

  def assert_ogg_tags( release, track, track_path )
    TagLib::Ogg::Vorbis::File.open( track_path ) do |file|
      tag = file.tag
      assert_equal track.artist.name, tag.artist
      assert_equal track.album.title, tag.album
      assert_equal track.album.year, tag.year
      assert_equal track.title, tag.title
      assert_equal track.rank, tag.track
      assert_equal track.comment, tag.comment
      assert_equal [release.release_url], tag.field_list_map['CONTACT']
      assert_equal [track.license.name], tag.field_list_map['LICENSE']
      assert_equal [release.publisher_name], tag.field_list_map['ORGANIZATION']
      assert_equal ["#{track.album.year} #{track.artist.name}"], tag.field_list_map['COPYRIGHT']
    end
  end

  def assert_mp3_tags( release, track, track_path )
    TagLib::MPEG::File.open( track_path ) do |file|
      #assert_nil file.id3v1_tag
      tag = file.id3v2_tag
      assert_equal track.artist.name, tag.artist
      assert_equal track.album.title, tag.album
      assert_equal track.album.year, tag.year
      assert_equal track.title, tag.title
      assert_equal track.rank, tag.track
      assert_equal 'Other', tag.genre
      assert_equal track.comment, tag.comment
      assert_nil tag.frame_list('WOAR').first

      found = tag.frame_list('WPUB').first
      assert found.kind_of? TagLib::ID3v2::UrlLinkFrame
      assert_equal release.publisher_url, found.to_s
      found = tag.frame_list('TPUB').first
      assert found.kind_of? TagLib::ID3v2::TextIdentificationFrame
      assert_equal release.publisher_name, found.to_s

      if track.license
        found = tag.frame_list('WCOP').first
        assert found.kind_of? TagLib::ID3v2::UrlLinkFrame
        assert_equal track.license.name, found.to_s
        found = tag.frame_list('WOAF').first
        assert found.kind_of? TagLib::ID3v2::UrlLinkFrame
        assert_equal release.release_url, found.to_s
        found = tag.frame_list('TCOP').first
        assert found.kind_of? TagLib::ID3v2::TextIdentificationFrame
        assert_equal "#{track.album.year} #{track.artist.name}. Licensed to the public under " +
          "#{track.license.name} verify at #{release.release_url}", found.to_s
      else
        assert tag.frame_list('WCOP').empty?
        assert tag.frame_list('WOAF').empty?
        assert tag.frame_list('TCOP').empty?
      end
    end
  end

  def check_track_release( release )
    track = release.track

    assert Dir.exists? Release::Uploader.track_store_dir
    partition = (track.id / 1000).to_s

    track_path = File.join( Release::Uploader.track_store_dir, partition, "#{track.id}.#{release.format}" )
    assert File.exists? track_path
    type = case release.format
      when Release::OGG then 'Ogg'
      when Release::MP3 then 'MPEG'
      when Release::FLAC then 'FLAC'
    end
    assert `file #{track_path}` =~ /#{type}/

    assert_tags release, track, track_path

    (Release::FORMATS - [release.format]).each do |format|
      assert Dir.glob( File.join( Release::Uploader.track_store_dir, partition, "*.#{format}" ) ).empty?
    end
  end

  def check_album_release( release )
    artist_reference = release.album.artist.reference
    album_reference = release.album.reference
    archive_file_path = File.join( Release::Uploader.album_store_dir, artist_reference,
      "#{artist_reference}-#{album_reference}-#{release.format}.zip" )

    puts archive_file_path
    assert File.exists? archive_file_path

    Dir.mktmpdir do |tmp_dir|
      system "unzip #{archive_file_path} -d #{tmp_dir}"

      album_path = File.join( tmp_dir, artist_reference, album_reference )
      assert File.exists? album_path

      assert File.exists? File.join( album_path, 'okladka.jpg' )
      assert File.exists? File.join( album_path, 'att1.jpg' )
      assert File.exists? File.join( album_path, 'att2.pdf' )
      assert File.exists? File.join( album_path, 'att3.txt' )
      release.album.tracks.each do |track|
        track_reference = track.title.parameterize( '_' )

       track_path = File.join( album_path, "#{sprintf( '%02d', track.rank )}-#{track_reference}.#{release.format}" )
        assert File.exists? track_path
        type = case release.format
          when Release::OGG then 'Ogg'
          when Release::MP3 then 'MPEG'
          when Release::FLAC then 'FLAC'
        end
        assert `file #{track_path}` =~ /#{type}/

        assert_tags release, track, track_path
      end

      (Release::FORMATS - [release.format]).each do |format|
        refute File.exists? File.join( album_path, "*.#{format}" )
      end
    end
  end
end

