require 'rails_helper'

RSpec.describe 'User', type: :system do
  context '未サインアップの場合' do
    it 'ユーザーが増えること' do
      visit root_path
      expect{
        click_link 'Sign in with GoogleOauth2'
        sleep 1
      }.to change(User, :count).by(1)
    end
  end

  context 'サインアップ済みの場合' do
    before do
      User.create!(
      email: 'test@example.com',
      password: 'test12'
      )
    end

    it 'ユーザーは増えないこと' do
      visit root_path
      expect{
        click_link 'Sign in with GoogleOauth2'
        sleep 1
      }.to_not change(User, :count)
    end
  end
end
