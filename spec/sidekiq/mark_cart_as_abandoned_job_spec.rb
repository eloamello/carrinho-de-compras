require 'rails_helper'
RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    it 'marks carts as abandoned' do
      cart = create(:cart, last_interaction_at: 4.hours.ago)
      expect { MarkCartAsAbandonedJob.new.perform }.to change { cart.reload.abandoned }.from(false).to(true)
    end

    it 'removes abandoned carts' do
      cart = create(:cart, abandoned: true, last_interaction_at: 8.days.ago)
      expect { MarkCartAsAbandonedJob.new.perform }.to change { Cart.count }.by(-1)
    end
  end
end
