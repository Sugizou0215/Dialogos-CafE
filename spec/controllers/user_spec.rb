require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  context 'ログインしている場合' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    before do
      sign_in user
    end

    describe "users#showのテスト" do

      it "users#showが正常に作動しているか" do
        get :show, params: {id: user.id}
        expect(response).to be_success
      end

      it "users#showへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :show, params: {id: user.id}
        expect(response).to have_http_status "200"
      end
    end

    describe "users#editのテスト" do

      it "users#editが正常に作動しているか" do
        get :edit, params: {id: user.id}
        expect(response).to be_success
      end

      it "groups#editへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :edit, params: {id: user.id}
        expect(response).to have_http_status "200"
      end

      it "ユーザー本人以外が編集ページに遷移できず、グループ詳細ページに遷移しているか" do
        sign_in another_user
        get :edit, params: {id: user.id}
        expect(response).to redirect_to user_path(another_user)
      end
    end

    describe "users#updateのテスト" do

      it "正常にupdateできるか" do
        user_params = {name: "編集テスト"}
        patch :update, params: {id: user.id, user: user_params}
        expect(user.reload.name).to eq "編集テスト"
      end

      it "正常にupdate後、編集したgroupの詳細ページに遷移するか" do
        user_params = {name: "編集テスト"}
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to redirect_to user_path(user)
      end

      it "不正な値でユーザーが更新できないか" do
        user_params = {name: nil}
        patch :update, params: {id: user.id, user: user_params}
        expect(user.reload.name).to_not eq nil
      end

      it "不正な値でユーザーを更新しようとすると、再度編集ページに遷移するか" do
        user_params = {name: nil}
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to render_template :edit
      end
    end

    describe "users#confirmのテスト" do

      it "users#confirmが正常に作動しているか" do
        get :confirm, params: {id: user.id}
        expect(response).to be_success
      end

      it "users#confirmへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :confirm, params: {id: user.id}
        expect(response).to have_http_status "200"
      end

      it "ユーザー本人以外が確認ページに遷移できず、グループ詳細ページに遷移しているか" do
        sign_in another_user
        get :confirm, params: {id: user.id}
        expect(response).to redirect_to user_path(another_user)
      end
    end

    describe "users#leaveのテスト" do

      it "正常に退会できるか" do
        put :leave, params: {id: user.id}
        expect(user.reload.is_valid).to eq false
      end

      it "正常に退会後、トップページに遷移するか" do
        put :leave, params: {id: user.id}
        expect(response).to redirect_to root_path
      end
    end
  end

  context "ログインしていない場合" do
    let(:user) { create(:user) }

    describe "users#showのテスト" do

      it "users#showが正常に作動していないか" do
        get :show, params: {id: user.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :show, params: {id: user.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "users#editのテスト" do

      it "users#editが正常に作動していないか" do
        get :edit, params: {id: user.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :edit, params: {id: user.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "users#confirmのテスト" do

      it "users#confirmが正常に作動していないか" do
        get :confirm, params: {id: user.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :confirm, params: {id: user.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "users#leaveのテスト" do

      it "users#leaveが正常に作動していないか" do
        put :leave, params: {id: user.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        put :leave, params: {id: user.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end