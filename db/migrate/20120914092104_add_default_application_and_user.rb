class AddDefaultApplicationAndUser < ActiveRecord::Migration
  def up
    user = User.create(email: "test@test.com", username: "truckingoffice", password: "topassword", password_confirmation: "topassword")
    user.client_applications.create(name: "truckingoffice", url: "http://localhost:3000", support_url: "", callback_url: "http://localhost:3000", key: "5db8bbea272298457b179665e1bc3e87d2c3f6e8", secret: "0544e99e100b3e7da51193fab4332dba726f397c")
  end

  def down
    User.where(:email => "test@test.com").destroy_all
    ClientApplication.where(:name => "truckingoffice").destroy_all
  end
end
