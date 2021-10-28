require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'ユーザー登録のテスト' do

    it 'name、email、passwordとpassword_confirmationが正常であれば登録できること' do
      user = build(:user)
      expect(user).to be_valid  # user.valid? が true になればパスする
    end
  end

  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '1文字以上であること' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '20文字以下であること: 20文字は〇' do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it 'ユニークであること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end
  end
end

