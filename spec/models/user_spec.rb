require 'spec_helper'

describe User do
  subject { create(:user) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:posts).dependent(:destroy) }
end