require "spec_helper"

describe Comment do
  it { should belong_to(:post) }
  it { should validate_presence_of(:nickname) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:post_id) }
end