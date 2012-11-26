module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @logged_in_user = create(:user)
      sign_in @logged_in_user
    end
  end
end