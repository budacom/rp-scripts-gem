require 'spec_helper'

RSpec.describe RpScripts::Session, type: :model do
  subject(:session) { create(:session) }

  it "has a valid factory" do
    expect(build(:session)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:identifier) }
  end

  describe '#reusable?' do
    it 'returns false if reusable_until is nil' do
      session.reusable_until = nil
      expect(session.reusable?).to be false
    end

    it 'returns false if reusable_until is less than current time' do
      session.reusable_until = 1.second.ago
      expect(session.reusable?).to be false
    end

    it 'returns true if reusable_until is greater than current time' do
      session.reusable_until = 1.second.from_now
      expect(session.reusable?).to be true
    end
  end
end
