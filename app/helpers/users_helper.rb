module UsersHelper
  def followers(user)
    follower_list = user.followers
                        .map { |follower| link_to follower.username, user_path(follower) }
                        .join(", ")
    "Followers (#{user.follower_count}): #{follower_list}".html_safe
  end

  def followees(user)
    followee_list = user.followees
                        .map { |followee| link_to followee.username, user_path(followee) }
                        .join(", ")
    "Following (#{user.followee_count}): #{followee_list}".html_safe
  end

  def follow_link(user)
    if policy(user).follow?
      link_to "follow #{@user.username}", user_follows_path(@user),
                                          remote: true, method: :post
    end
  end
end
