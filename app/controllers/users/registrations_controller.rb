# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render(json: { user: resource }, status: 201)
    else
      render(json: { errors: resource.errors.full_messages }, status: 422)
    end
  end
end
