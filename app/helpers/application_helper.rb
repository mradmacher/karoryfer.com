# frozen_string_literal: true

module ApplicationHelper
  def render_text(text)
    text ||= ''
    raw RDiscount.new(text).to_html
  end

  def render_title(*title)
    title << current_artist.name if current_artist?
    title << 'Karoryfer Lecolds'
    content_for :title do
      title.join(' - ')
    end
  end

  def link_to_action(title, link, options = {})
    link_to title, link, options.merge(class: 'small button')
  end

  alias format_text render_text

  def main_menu_items
    active = if current_artist?
               current_artist.reference
             elsif controller_name == 'site'
               action_name
             end

    [].tap do |items|
        items << [t('title.artists'), artists_url, active == 'artists']
        items << [t('title.albums'), albums_url, active == 'albums']
        items << [t('title.samples'), artist_url('karoryfer-samples'), active == 'karoryfer-samples']
        items << [t('title.about'), artist_url('karoryfer-lecolds'), active == 'karoryfer-lecolds']
        items << [t('title.shop'), 'http://sklep.karoryfer.com', false]
    end
  end

  def youtube_url
    'http://www.youtube.com/user/KaroryferLecolds'
  end

  def facebook_url
    'http://www.facebook.com/karoryfer'
  end

  def twitter_url
    'http://www.twitter.com/karoryfer'
  end
end
