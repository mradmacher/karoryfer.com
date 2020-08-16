# frozen_string_literal: true

module Releaser
  class Tags
    attr_accessor :artist,
                  :album,
                  :year,
                  :title,
                  :track,
                  :comment,
                  :contact_url,
                  :organization_name,
                  :organization_url,
                  :license_name,
                  :copyright

    def copyright_description
      "Licensed to the public under #{@license_name} verify at #{@contact_url}"
    end

    def self.build_for(track, publisher:)
      tag = ::Releaser::Tags.new
      tag.artist = if track.artist_name.blank?
                     track.artist.name
                   else
                     track.artist_name
                   end
      tag.album = track.album.title
      tag.year = track.album.year
      tag.title = track.title
      tag.track = track.rank
      tag.comment = track.comment unless track.comment.blank?

      tag.contact_url = publisher.album_url(track.album)
      tag.organization_name = publisher.name
      tag.organization_url = publisher.url
      tag.license_name = track.license.name if track.license
      tag.copyright = "#{track.album.year} #{track.artist.name}"
      tag
    end
  end
end
