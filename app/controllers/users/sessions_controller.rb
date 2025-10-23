# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    # Successful sign in
    render(json: { user: resource }, status: 200)
  end

  def respond_to_on_destroy
    # Successful sign out
    head(204)
  end
end
