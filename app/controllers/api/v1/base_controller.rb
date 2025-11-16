module Api
  module V1
    class BaseController < ActionController::API
      include Pagy::Backend

      before_action :authenticate_api_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :bad_request

      private

      def authenticate_api_user!
        token = request.headers["Authorization"]&.split(" ")&.last
        return render_unauthorized unless token

        begin
          decoded = JWT.decode(token, jwt_secret, true, algorithm: "HS256")
          @current_api_user = User.find(decoded[0]["user_id"])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          render_unauthorized
        end
      end

      def current_api_user
        @current_api_user
      end

      def jwt_secret
        ENV.fetch("JWT_SECRET_KEY", Rails.application.credentials.secret_key_base)
      end

      def render_unauthorized
        render json: { error: "Unauthorized" }, status: :unauthorized
      end

      def not_found
        render json: { error: "Resource not found" }, status: :not_found
      end

      def bad_request(exception)
        render json: { error: exception.message }, status: :bad_request
      end

      def pagy_metadata(pagy)
        {
          current_page: pagy.page,
          total_pages: pagy.pages,
          total_items: pagy.count,
          items_per_page: pagy.items
        }
      end
    end
  end
end
