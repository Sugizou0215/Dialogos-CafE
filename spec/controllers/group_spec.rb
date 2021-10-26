require 'rails_helper'

RSpec.describe GroupsController, type: :controller do

  context 'ログインしている場合' do
    let(:user) { create(:user) }

    describe "group#indexのテスト" do

      it "groups#indexが正常に作動しているか" do
        sign_in user
        get :index
        expect(response).to be_success
      end

      it "indexへのアクセスに対して正常なレスポンスが返ってきているか" do
        sign_in user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    describe "groups#showのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#showが正常に作動しているか" do
        sign_in user
        get :show, params: {id: group.id}
        expect(response).to be_success
      end

      it "groups#showへのアクセスに対して正常なレスポンスが返ってきているか" do
        sign_in user
        get :show, params: {id: group.id}
        expect(response).to have_http_status "200"
      end
    end

    describe "groups#newのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#newが正常に作動しているか" do
        sign_in user
        get :new
        expect(response).to be_success
      end

      it "groups#newへのアクセスに対して正常なレスポンスが返ってきているか" do
        sign_in user
        get :new
        expect(response).to have_http_status "200"
      end
    end

    describe "groups#createのテスト" do

      it "正常にグループを作成できるか" do
        sign_in user
        expect {
          post :create, params: {
            group: {
              name: "テストグループ",
              introduction: Faker::Lorem.characters(number: 20),
              admin_user_id: user.id
            }
          }
        }.to change(Group, :count).by(1)
      end

      it "グループ作成後の作成したグループの詳細ページに遷移しているか" do
        sign_in user
        post :create, params: {
          group: {
              name: "テストグループ",
              introduction: Faker::Lorem.characters(number: 20),
              admin_user_id: user.id
            }
        }
        expect(response).to redirect_to "/groups/1"
      end

      it "不正な値でグループが作成できないか" do
        sign_in user
        expect {
          post :create, params: {
            group: {
              name: nil,
              introduction: Faker::Lorem.characters(number: 20),
              admin_user_id: user.id
            }
          }
        }.to_not change(Group, :count)
      end

      it "不正な値でグループが作成しようとすると、作成ページに遷移するか" do
        sign_in user
        post :create, params: {
          group: {
            name: nil,
            introduction: Faker::Lorem.characters(number: 20),
            admin_user_id: user.id
          }
        }
        expect(response).to redirect_to new_group_path
      end
    end
  end

  context "ログインしていない場合" do
    describe "groups#showのテスト" do

      let(:user) { create(:user) }
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#showが正常に作動していないか" do
        get :show, params: {id: group.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :show, params: {id: group.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "groups#newのテスト" do

      it "groups#showが正常に作動していないか" do
        get :new
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
    
    describe "groups#createのテスト" do
      
      let(:user) { create(:user) }

      it "groups#createが正常に作動していないか" do
        expect {
          post :create, params: {
            group: {
              name: "テストグループ",
              introduction: Faker::Lorem.characters(number: 20),
              admin_user_id: user.id
            }
          }
        }.to_not change(Group, :count)
      end

      it "ログイン画面にリダイレクトされているか" do
        post :create, params: {
          group: {
            name: "テストグループ",
            introduction: Faker::Lorem.characters(number: 20),
            admin_user_id: user.id
          }
        }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end