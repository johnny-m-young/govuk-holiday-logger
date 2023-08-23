RSpec.describe RootController do
  describe "GET index" do
    it "redirects if user is not signed in" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "renders the index page if user is signed in" do
      sign_in create(:user)
      get :index
      expect(response).to render_template("index")
    end
  end
end
