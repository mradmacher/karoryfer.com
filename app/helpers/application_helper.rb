module ApplicationHelper
	def render_text( text )
		text = '' unless text
    raw RDiscount.new( text ).to_html
	end

	def render_title( *title )
		if current_artist? then
			title << current_artist.name
		end
		title << 'Karoryfer Lecolds'
		content_for :title do
			title.join( ' - ' )
		end
	end

  def event_details( event )
    loc = []
    loc << event_date( event )
    loc << event.location unless event.location.blank?
    loc.join( ', ' )
  end

  def event_date( event )
    unless event.event_date.blank?
      if event.duration > 0
        last_date = event.event_date + event.duration.days
        if last_date.year == event.event_date.year && last_date.month == event.event_date.month
          "#{event.event_date.strftime( '%d' )}-#{last_date.strftime( '%d' )}#{event.event_date.strftime( '.%m.%Y' )}"
        else
          "#{event.event_date.strftime( '%d.%m.%Y' )}-#{last_date.strftime( '%d.%m.%Y' )}"
        end
      else
        event.event_date.strftime( '%d.%m.%Y' )
      end
    end
  end

  def post_icon
    image_tag 'tags/note.png', alt: t( 'activerecord.models.post' ), title: t( 'activerecord.models.post' )
  end

  def event_icon( expired = false )
    image_tag "tags/#{expired ? 'expired_' : ''}event.png", alt: t( 'activerecord.models.event' ), title: t( 'activerecord.models.event' )
  end

  def video_icon
    image_tag 'tags/video.png', alt: t( 'activerecord.models.video' ), title: t( 'activerecord.models.video' )
  end

  def link_to_action( title, link, options = {} )
    link_to title, link, options.merge( :class => 'btn btn-warning btn-xs' )
  end

	alias format_text render_text
end
