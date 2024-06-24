require 'spec_helper'

RSpec.describe RpScripts::Session, type: :model do
  subject(:session) { create(:session) }

  it "has a valid factory" do
    expect(build(:session)).to be_valid
  end

  # describe "validations" do
  #   it { is_expected.to validate_presence_of(:operation_uuid) }
  #   it { is_expected.to validate_presence_of(:target_class) }
  # end
end
