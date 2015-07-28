def random(number)
  rand(number) + 1
end

def random_user(user_count)
  User.find(random(user_count))
end

def generate_users(user_count)
  users = []
  user_count.times do
    users << {
      username: Faker::Internet.user_name,
      password: Faker::Internet.password(8),
      email:    Faker::Internet.email
    }
  end
  User.create(users)
end

def generate_user_activity(options)
  user_count, post_count, comment_count = options[:user_count], 0, 0

  user_count.times do |count|
    user_id = count + 1

    # generate posts
    rand(options[:max_posts_per_user]).times do |i|
      if i % 2 == 0
        Post.create(
          title:        Faker::Company.catch_phrase,
          url:          Faker::Internet.url,
          text:         Faker::Hacker.say_something_smart,
          tag1_name:    Faker::Hacker.adjective,
          tag2_name:    Faker::Hacker.abbreviation,
          user_id:      user_id
        )
      else
        Post.create(
          title:        Faker::Hacker.ingverb,
          url:          "",
          text:         Faker::Hacker.say_something_smart,
          tag1_name:    Faker::Hacker.adjective,
          tag2_name:    Faker::Hacker.abbreviation,
          user_id:      user_id
        )
      end

      post_count += 1
    end

    # generate comments
    rand(options[:max_comments_per_user]).times do |i|
      i % 2 == 0 ? text = Faker::Lorem.sentence : Faker::Hacker.say_something_smart

      if i % 3 == 0
        Comment.create(
          user_id:          user_id,
          text:             text,
          commentable_id:   random(post_count),
          commentable_type: "Post"
        )
      else
        Comment.create(
          user_id:          user_id,
          text:             text,
          commentable_id:   random(comment_count),
          commentable_type: "Comment"
        )
      end

      comment_count += 1
    end

    # generate follows
    rand(options[:max_follows_per_user]).times do
      Follow.create(follower_id: user_id,
                    followee_id: random(user_count))
    end

    #generate shares
    rand(options[:max_shares_per_user]).times do
      Share.create(user_id: user_id,
                   post_id: random(post_count))
    end
  end
end

user_count = 100
generate_users(user_count)
User.create(username: "watiki",
            password: "asdf",
            email:    "ben@gmail.com")

generate_user_activity(
  user_count:            user_count,
  max_posts_per_user:    10,
  max_comments_per_user: 30,
  max_follows_per_user:  10,
  max_shares_per_user:   15
)
