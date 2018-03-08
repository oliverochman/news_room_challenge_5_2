require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect(FactoryBot.create(:article)).to be_valid
    end
  end

  describe 'DB Table' do
    it {is_expected.to have_db_column(:title).of_type(:string)}
  end
end
