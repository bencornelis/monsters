require Rails.root + "db/generator_methods.rb"

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
