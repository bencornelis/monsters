class Post < ActiveRecord::Base
  class Feed
    def initialize(params = {})
      @sort = params[:sort]
      @user = params[:user]
      @filter_options = params.slice(:tag, :page, :per_page)
    end

    def posts
      sort == "time" ? by_time : by_score
    end

    private

    attr_reader :sort, :user, :filter_options

    def by_score
      score_scope.filter(filter_options)
    end

    def by_time
      base_scope.by_time.filter(filter_options)
    end

    def score_scope
      base_scope.group("posts.id").order("#{score_sql} desc")
    end

    def score_sql
      "(COUNT(shares.id) - 1)/POWER(EXTRACT(EPOCH FROM (NOW() - posts.created_at)) + 2, 1.8)"
    end

    def base_scope
      Post
        .joins(:shares)
        .where("shares.user_id IN (:followee_ids)",
               followee_ids: user_followee_ids)
    end

    def user_followee_ids
      user.followees.pluck(:id)
    end
  end
end
