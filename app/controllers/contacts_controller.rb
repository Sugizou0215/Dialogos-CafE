class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  # 確認画面を表示
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      render :new
    end
  end

  # 入力内容に誤りがあった場合、入力内容を保持したまま確認ページから前のページに戻る
  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to done_path
    else
      render :new
    end
  end

  # 送信完了画面を表示
  def done
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :title, :body)
  end
end
