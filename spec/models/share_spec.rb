require 'rails_helper'

RSpec.describe Share, type: :model do
  it { should belong_to :user }
  it { should belong_to :shareable }
  it { should belong_to :share_receiver }
  it { should validate_uniqueness_of(:user_id)
                .scoped_to([:shareable_id, :shareable_type]) }
end
