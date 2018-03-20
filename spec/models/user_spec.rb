require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect(create(:user)).to be_valid
    end
  end

  describe 'db table' do
    it {is_expected.to have_db_column :email}
    it {is_expected.to have_db_column :role}
  end
end
