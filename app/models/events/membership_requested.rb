class Events::MembershipRequested < Event
  after_create :notify_users!

  def self.publish!(membership)
    create!(:kind => "membership_requested", :eventable => membership)
  end

  def membership_request
    eventable
  end

  private

    def notify_users!
      membership_request.group_admins.each do |admin|
        notify!(admin)
      end
    end
end