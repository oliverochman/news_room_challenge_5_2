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

  describe 'Validations' do
    it {is_expected.to validate_inclusion_of(:role).in_array(User.role.keys)}
  end

  describe 'Roles' do
    let(:author) {create(:user, role: 'author')}
    let(:random_visitor) {create(:user, role: 'visitor')}

    describe '#author' do
      it 'returns true on author' do
        expect(author.author?).to eq true
      end

      it 'returns false on visitor' do
        expect(random_visitor.author?).to eq false
      end
    end

    describe '#visitor' do
      it 'returns true on visitor' do
        expect(random_visitor.visitor?).to eq true
      end

      it 'returns false on author' do
        expect(author.visitor?).to eq false
      end
    end
  end
end
