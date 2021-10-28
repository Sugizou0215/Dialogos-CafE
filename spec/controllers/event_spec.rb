require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  context 'ログインしている場合' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:genre) { create(:genre) }

    before do
      sign_in user
    end

    describe "group#indexのテスト" do

      it "events#indexが正常に作動しているか" do
        get :index
        expect(response).to be_success
      end

      it "indexへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :index
        expect(response).to have_http_status "200"
      end
    end

    describe "events#showのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "events#showが正常に作動しているか" do
        get :show, params: {id: event.id}
        expect(response).to be_success
      end

      it "events#showへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :show, params: {id: event.id}
        expect(response).to have_http_status "200"
      end
    end

    describe "events#newのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "events#newが正常に作動しているか" do
        get :new
        expect(response).to be_success
      end

      it "events#newへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :new
        expect(response).to have_http_status "200"
      end
    end

    describe "events#createのテスト" do

      it "正常にイベントを作成できるか" do
        expect {
          post :create, params: {
            event: {
              name: "テストイベント",
              introduction: Faker::Lorem.characters(number: 20),
              genre_id: genre.id,
              start_at: "2021-11-01 00:00:00",
              finish_at: "2021-11-01 12:00:00",
              deadline: "2021-10-31 00:00:00",
              capacity:  3,
              tool: Faker::Lorem.characters(number: 5),
              is_valid: true,
              admin_user_id: user.id,
              tag_name: "タグ"
            }
          }
        }.to change(Event, :count).by(1)
      end

      it "グループ作成後の作成したグループの詳細ページに遷移しているか" do
        post :create, params: {
          event: {
            name: "テストイベント",
            introduction: Faker::Lorem.characters(number: 20),
            genre_id: genre.id,
            start_at: "2021-11-01 00:00:00",
            finish_at: "2021-11-01 12:00:00",
            deadline: "2021-10-31 00:00:00",
            capacity:  3,
            tool: Faker::Lorem.characters(number: 5),
            is_valid: true,
            admin_user_id: user.id,
            tag_name: "タグ"
          }
        }
        expect(response).to redirect_to "/events/1"
      end

      it "不正な値でグループが作成できないか" do
        expect {
          post :create, params: {
            event: {
              name: nil,
              introduction: Faker::Lorem.characters(number: 20),
              genre_id: genre.id,
              start_at: "2021-11-01 00:00:00",
              finish_at: "2021-11-01 12:00:00",
              deadline: "2021-10-31 00:00:00",
              capacity:  3,
              tool: Faker::Lorem.characters(number: 5),
              is_valid: true,
              admin_user_id: user.id,
              tag_name: "タグ"
            }
          }
        }.to_not change(Event, :count)
      end

      it "不正な値でグループを作成しようとすると、作成ページに遷移するか" do
        post :create, params: {
          event: {
            name: nil,
            introduction: Faker::Lorem.characters(number: 20),
            genre_id: genre.id,
            start_at: "2021-11-01 00:00:00",
            finish_at: "2021-11-01 12:00:00",
            deadline: "2021-10-31 00:00:00",
            capacity:  3,
            tool: Faker::Lorem.characters(number: 5),
            is_valid: true,
            admin_user_id: user.id,
            tag_name: "タグ"
          }
        }
        expect(response).to render_template :new
      end
    end

    describe "events#editのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "events#editが正常に作動しているか" do
        get :edit, params: {id: event.id}
        expect(response).to be_success
      end

      it "events#editへのアクセスに対して正常なレスポンスが返ってきているか" do
        get :edit, params: {id: event.id}
        expect(response).to have_http_status "200"
      end

      it "イベント作成者以外が編集ページに遷移できず、イベント詳細ページに遷移しているか" do
        sign_in another_user
        get :edit, params: {id: event.id}
        expect(response).to redirect_to event_path(event)
      end
    end

    describe "events#updateのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "正常にupdateできるか" do
        event_params = {name: "編集テスト", tag_name: "タグ"}
        patch :update, params: {id: event.id, event: event_params}
        expect(event.reload.name).to eq "編集テスト"
      end

      it "正常にupdate後、編集したeventの詳細ページに遷移するか" do
        event_params = {name: "編集テスト", tag_name: "タグ"}
        patch :update, params: {id: event.id, event: event_params}
        expect(response).to redirect_to event_path(event)
      end

      it "不正な値でイベントが更新できないか" do
        event_params = {name: nil, tag_name: "タグ"}
        patch :update, params: {id: event.id, event: event_params}
        expect(event.reload.name).to_not eq nil
      end

      it "不正な値でイベントを更新しようとすると、再度編集ページに遷移するか" do
        event_params = {name: nil, tag_name: "タグ"}
        patch :update, params: {id: event.id, event: event_params}
        expect(response).to render_template :edit
      end
    end

    describe "events#cancelのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "正常にイベントを中止できるか" do
        patch :cancel, params: {id: event.id}
        expect(event.reload.is_valid).to eq false
      end

      it "正常にイベントを中止後、中止したeventの詳細ページに遷移するか" do
        patch :cancel, params: {id: event.id}
        expect(response).to redirect_to event_path(event)
      end

      it "イベント作成者以外が中止できず、イベント詳細ページに遷移しているか" do
        sign_in another_user
        patch :cancel, params: {id: event.id}
        expect(response).to redirect_to event_path(event)
      end
    end
  end

  context "ログインしていない場合" do
    let(:user) { create(:user) }
    let(:genre) { create(:genre) }

    describe "groups#showのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "events#showが正常に作動していないか" do
        get :show, params: {id: event.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :show, params: {id: event.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "events#newのテスト" do

      it "events#showが正常に作動していないか" do
        get :new
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "events#createのテスト" do

      it "groups#createが正常に作動していないか" do
        expect {
          post :create, params: {
            event: {
              name: "テストイベント",
              introduction: Faker::Lorem.characters(number: 20),
              genre_id: genre.id,
              start_at: "2021-11-01 00:00:00",
              finish_at: "2021-11-01 12:00:00",
              deadline: "2021-10-31 00:00:00",
              capacity:  3,
              tool: Faker::Lorem.characters(number: 5),
              is_valid: true,
              admin_user_id: user.id,
              tag_name: "タグ"
            }
          }
        }.to_not change(Event, :count)
      end

      it "ログイン画面にリダイレクトされているか" do
        post :create, params: {
          event: {
            name: "テストイベント",
            introduction: Faker::Lorem.characters(number: 20),
            genre_id: genre.id,
            start_at: "2021-11-01 00:00:00",
            finish_at: "2021-11-01 12:00:00",
            deadline: "2021-10-31 00:00:00",
            capacity:  3,
            tool: Faker::Lorem.characters(number: 5),
            is_valid: true,
            admin_user_id: user.id,
            tag_name: "タグ"
          }
        }
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    describe "events#newのテスト" do
      let(:event) { create(:event, genre_id: genre.id, admin_user_id: user.id) }

      it "events#editが正常に作動していないか" do
        get :edit, params: {id: event.id}
        expect(response).to_not be_success
      end

      it "ログイン画面にリダイレクトされているか" do
        get :edit, params: {id: event.id}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end