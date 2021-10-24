require 'rails_helper'

RSpec.describe 'Eventモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { event.valid? }

    let(:user) { create(:user) }
    let!(:event) { build(:event, admin_user_id: user.id, is_valid: true ) }

    context 'nameカラム' do
      it '空欄でないこと' do
        event.name = ''
        is_expected.to eq false
      end
      it '50文字以下であること: 51文字は×' do
        event.name = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '空欄でないこと' do
        event.introduction = ''
        is_expected.to eq false
      end
    end

    context 'genre_idカラム' do
      it '空欄でないこと' do
        event.genre_id = ''
        is_expected.to eq false
      end
    end

    context 'capacityカラム' do
      it '空欄でないこと' do
        event.capacity = ''
        is_expected.to eq false
      end
      it '2以上であること: 1は×' do
        event.capacity = 1
        is_expected.to eq false
      end
      it '2以上であること: 2は〇' do
        event.capacity = 2
        is_expected.to eq true
      end
    end

    context 'toolカラム' do
      it '空欄でないこと' do
        event.tool = ''
        is_expected.to eq false
      end
    end

    #start_at,finish_at,deadlineは独自バリデーションのため手動でテスト

  end

  # describe 'アソシエーションのテスト' do
  #   context 'Userモデルとの関係' do
  #     it 'N:1となっている' do
  #       expect(Book.reflect_on_association(:user).macro).to eq :belongs_to
  #     end
  #   end
  # end
end
