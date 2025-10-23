require 'swagger_helper'

RSpec.describe 'Auth', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/users' do
    post 'Register a new user' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: ['user']
      }

      response(201, 'created') do
        let(:payload) do
          { user: { email: 'newuser@example.com', password: '123456', password_confirmation: '123456' } }
        end
        run_test!
      end

      response(422, 'validation error') do
        let(:payload) { { user: { email: 'bad', password: 'x', password_confirmation: 'y' } } }
        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post 'Login to get JWT (Authorization header)' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['user']
      }

      response(200, 'ok', headers: {
        'Authorization' => {
          schema: { type: :string },
          description: 'JWT Bearer token. Copy this entire value and click the "Authorize" button (bearerAuth).'
        }
      }) do
        let(:payload) do
          { user: { email: 'newuser@example.com', password: '123456' } }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        let(:payload) { { user: { email: 'nope@example.com', password: 'wrong' } } }
        run_test!
      end
    end
  end
end
