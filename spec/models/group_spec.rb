require 'rails_helper'

RSpec.describe 'Groupモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group.valid? }

    let(:user) { create(:user) }
    let!(:group) { build(:group, admin_user_id: user.id) }
    let!(:other_group) { create(:group) }

    context 'nameカラム' do
      it '空欄でないこと' do
        group.name = ''
        is_expected.to eq false
      end
      it '50文字以下であること: 50文字は〇' do
        group.name = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×' do
        group.name = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
      it 'ユニークであること' do
        group.name = other_group.name
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '空欄でないこと' do
        group.introduction = ''
        is_expected.to eq false
      end
    end
  end

  # describe 'アソシエーションのテスト' do
  #   context 'Userモデルとの関係' do
  #     it 'N:1となっている' do
  #       expect(Book.reflect_on_association(:user).macro).to eq :belongs_to
  #     end
  #   end
  # end
end
