require 'rails_helper'

RSpec.describe 'Group_newモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group_new.valid? }

    let(:group) { create(:group) }
    let!(:group_new) { build(:group_new, group_id: group.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        group_new.title = ''
        is_expected.to eq false
      end
      it '30文字以下であること: 30文字は〇' do
        group_new.title = Faker::Lorem.characters(number: 30)
        is_expected.to eq true
      end
      it '30文字以下であること: 31文字は×' do
        group_new.title = Faker::Lorem.characters(number: 31)
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        group_new.body = ''
        is_expected.to eq false
      end
    end
  end
end
