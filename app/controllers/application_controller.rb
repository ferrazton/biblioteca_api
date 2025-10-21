class ApplicationController < ActionController::API
    rescue_from(ActiveRecord::RecordNotFound, with: :render_not_found)

    private

    def render_not_found(exception)
        render(json: { error: exception.message }, status: 404)
    end
end
