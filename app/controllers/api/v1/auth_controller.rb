module Api
  module V1
    class AuthController < ActionController::API
      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          token = generate_jwt(user)
          render json: {
            token: token,
            user: {
              id: user.id,
              email: user.email,
              first_name: user.first_name,
              last_name: user.last_name,
              role: user.role
            }
          }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def generate_jwt(user)
        payload = {
          user_id: user.id,
          exp: 24.hours.from_now.to_i
        }
        JWT.encode(payload, jwt_secret, "HS256")
      end

      def jwt_secret
        ENV.fetch("JWT_SECRET_KEY", Rails.application.credentials.secret_key_base)
      end
    end
  end
end
