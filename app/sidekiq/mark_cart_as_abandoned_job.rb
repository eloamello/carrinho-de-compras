require 'sidekiq-scheduler'

class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    Cart.where(last_interaction_at: ...3.hours.ago).find_each do |cart|
      cart.mark_as_abandoned
    end

    Cart.where(abandoned: true, last_interaction_at: ...7.days.ago).find_each do |cart|
      cart.remove_if_abandoned
    end
  end
end
