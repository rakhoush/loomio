describe NotificationItems::CommentLiked do
  let(:notification) { stub(:notification) }
  let(:item) { NotificationItems::CommentLiked.new(notification) }

  it "#actor returns the user who liked the comment" do
    liker = stub(:user)
    notification.stub_chain(:eventable, :user).and_return(liker)
    item.actor.should == notification.eventable.user
  end

  it "#action_text returns a string" do
    item.action_text.should == I18n.t('notifications.comment_liked')
  end

  it "#title returns the discussion title" do
    notification.stub_chain(:eventable, :discussion_title).and_return("hello")
    item.title.should == notification.eventable.discussion_title
  end

  it "#group_full_name returns the discussion's group name including a parent if there is one" do
    notification.stub_chain(:eventable, :group_full_name).and_return("goob")
    item.group_full_name.should == notification.eventable.group_full_name
  end

  it "#link returns a path to the comment" do
    item.stub_chain(:url_helpers, :discussion_path).and_return("/discussions/1/")
    notification.stub_chain(:eventable, :comment_id).and_return("123")
    item.link.should == "/discussions/1/#comment-123"
  end
end
