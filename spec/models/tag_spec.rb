require 'rails_helper'

RSpec.describe Tag, type: :model do
  include_context "db_cleanup_each"

  context "valid tag" do
    let(:tag) { FactoryGirl.create(:tag) }

    it "creates new instance" do
      db_tag= Tag.find(tag.id)
      expect(db_tag.name).to eq(tag.name)
    end
  end

  context "invalid tag" do
    let(:tag) { FactoryGirl.create(:tag) }

    it "provides error messages" do
      new_tag = FactoryGirl.build(:tag, name: tag.name)
      expect(new_tag.validate).to be false
      expect(new_tag.errors.messages).to include(:name=>["has already been taken"])
    end
  end
end
