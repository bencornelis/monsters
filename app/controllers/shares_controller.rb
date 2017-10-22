class SharesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @shareable = find_shareable
    @shareable.shares.create(user_id: current_user.id,
                             share_receiver_id: @shareable.user_id)
    check_if_badge_should_be_awarded(@shareable.user)

    respond_to do |format|
      format.js { render "create_#{@shareable.class.to_s.downcase}_share" }
    end
  end

  private

  def find_shareable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  def check_if_badge_should_be_awarded(user)
    CheckForBadge.new(user).call
  end
end
