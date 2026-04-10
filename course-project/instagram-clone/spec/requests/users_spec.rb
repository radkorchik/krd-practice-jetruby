require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { build_user }
  let(:other_user) { build_user }

  it "requires authentication for users pages" do
    get users_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "renders index and profile for signed in user" do
    sign_in_user(user)

    get users_path
    expect(response).to have_http_status(:ok)

    get user_path(other_user)
    expect(response).to have_http_status(:ok)
  end
end
