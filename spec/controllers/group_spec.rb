require 'rails_helper'

RSpec.describe GroupsController, type: :controller do

  context 'ログインしている場合' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    before do
      sign_in user
    end

    describe "group#indexのテスト" do

      it "groups#indexが正常に作動しているか" do
        get :index
        expect(response).to be_success
      end

      it "indexへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :index
        expect(response).to have_http_status "200"
      end
    end

    describe "groups#showのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#showが正常に作動しているか" do
        get :show, params: {id: group.id}
        expect(response).to be_success
      end

      it "groups#showへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :show, params: {id: group.id}
        expect(response).to have_http_status "200"
      end
    end

    describe "groups#newのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#newが正常に作動しているか" do
        get :new
        expect(response).to be_success
      end

      it "groups#newへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :new
        expect(response).to have_http_status "200"
      end
    end

    describe "groups#createのテスト" do

      it "正常にグループを作成できるか" do
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
        post :create, params: {
          group: {
            name: nil,
            introduction: Faker::Lorem.characters(number: 20),
            admin_user_id: user.id
          }
        }
        expect(response).to render_template :new
      end
    end

    describe "groups#editのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#editが正常に作動しているか" do
        get :edit, params: {id: group.id}
        expect(response).to be_success
      end

      it "groups#editへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :edit, params: {id: group.id}
        expect(response).to have_http_status "200"
      end

      it "グループ作成者以外が編集ページに遷移できず、グループ詳細ページに遷移しているか" do
        sign_in another_user
        get :edit, params: {id: group.id}
        expect(response).to redirect_to group_path(group)
      end
    end

    describe "groups#updateのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "正常にupdateできるか" do
        group_params = {name: "編集テスト"}
        patch :update, params: {id: group.id, group: group_params}
        expect(group.reload.name).to eq "編集テスト"
      end

      it "正常にupdate後、編集したgroupの詳細ページに遷移するか" do
        group_params = {name: "編集テスト"}
        patch :update, params: {id: group.id, group: group_params}
        expect(response).to redirect_to group_path(group)
      end

      it "不正な値でグループが更新できないか" do
        group_params = {name: nil}
        patch :update, params: {id: group.id, group: group_params}
        expect(group.reload.name).to_not eq nil
      end

      it "不正な値でグループが更新しようとすると、再度編集ページに遷移するか" do
        group_params = {name: nil}
        patch :update, params: {id: group.id, group: group_params}
        expect(response).to render_template :edit
      end
    end
  end

  context "ログインしていない場合" do
    let(:user) { create(:user) }

    describe "groups#showのテスト" do
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

      it "groups#newが正常に作動していないか" do
        get :new
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "groups#createのテスト" do

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

    describe "groups#editのテスト" do
      let(:group) { create(:group, admin_user_id: user.id) }

      it "groups#editが正常に作動していないか" do
        get :edit, params: {id: group.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :edit, params: {id: group.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end