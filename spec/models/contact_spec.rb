require 'rails_helper'

RSpec.describe 'Contactモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { contact.valid? }

    let!(:contact) { build(:contact) }

    context 'nameカラム' do
      it '空欄でないこと' do
        contact.name = ''
        is_expected.to eq false
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        contact.name = ''
        is_expected.to eq false
      end
    end

    context 'titleカラム' do
      it '空欄でないこと' do
        contact.title = ''
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        contact.body = ''
        is_expected.to eq false
      end
    end
  end
end
