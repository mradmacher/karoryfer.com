# Provides access to event resource.
class EventCruder < Cruder
  def resource_class
    Event
  end

  def permitted_params
    strong_parameters.require(:event).permit(
      :title,
      :location,
      :address,
      :event_date,
      :event_time,
      :duration,
      :free_entrance,
      :price,
      :poster,
      :remove_poster,
      :body,
      :external_urls
    )
  end

  protected

  def resource_scope
    owner.events
  end
end
