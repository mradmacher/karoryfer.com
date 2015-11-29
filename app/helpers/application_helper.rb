module ApplicationHelper
  def render_text(text)
    text = '' unless text
    raw RDiscount.new(text).to_html
  end

  def render_title(*title)
    title << current_artist.name if current_artist?
    title << 'Karoryfer Lecolds'
    content_for :title do
      title.join(' - ')
    end
  end

  def event_details(event)
    loc = []
    loc << event_date(event)
    loc << event.location unless event.location.blank?
    loc.join(', ')
  end

  def event_date(event)
    return if event.event_date.blank?
    if event.duration > 0
      last_date = event.event_date + event.duration.days
      if last_date.year == event.event_date.year && last_date.month == event.event_date.month
        "#{event.event_date.strftime('%d')}-#{last_date.strftime('%d')}#{event.event_date.strftime('.%m.%Y')}"
      else
        "#{event.event_date.strftime('%d.%m.%Y')}-#{last_date.strftime('%d.%m.%Y')}"
      end
    else
      event.event_date.strftime('%d.%m.%Y')
    end
  end

  def post_date(post)
    post.date.strftime('%d.%m.%Y')
  end

  def post_icon
    image_tag 'tags/note.png',
      alt: t('activerecord.models.post'),
      title: t('activerecord.models.post')
  end

  def event_icon(expired = false)
    image_tag "tags/#{expired ? 'expired_' : ''}event.png",
      alt: t('activerecord.models.event'),
      title: t('activerecord.models.event')
  end

  def video_icon
    image_tag 'tags/video.png',
              alt: t('activerecord.models.video'),
              title: t('activerecord.models.video')
  end

  def link_to_action(title, link, options = {})
    link_to title, link, options.merge(class: 'btn btn-warning btn-xs')
  end

  alias_method :format_text, :render_text

  def main_menu_items
    active = if current_artist?
               current_artist.reference
             elsif controller_name == 'site'
               action_name
             end

    items = []
    items << ['Wydawnictwa', albums_url, active == 'albums']
    Settings.highlighted.each do |hc|
      items << [
        hc['title'],
        artist_url(hc['reference']),
        active == hc['reference']
      ]
    end
    items << ['Szkice', drafts_url, active == 'drafts'] if current_user?
    items
  end
end
