require 'swagger_helper'

RSpec.describe 'Authors API', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/authors' do
    get 'List authors' do
      tags 'Authors'
      produces 'application/json'
      response(200, 'ok') { run_test! }
    end

    post 'Create author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]  # requires JWT

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          author: {
            type: :object,
            properties: {
              kind: { type: :string, enum: %w[person institution] },
              name: { type: :string },
              birth_date: { type: :string, format: :date }, # used when kind = person
              city: { type: :string }                       # used when kind = institution
            },
            required: %w[kind name]
          }
        },
        required: ['author']
      }

      response(201, 'created', examples: {
        'application/json' => { id: 1, name: 'Albert Camus', kind: 'person', birth_date: '1913-11-07' }
      }) { run_test! }

      response(401, 'unauthorized') { run_test! }
      response(422, 'validation error') { run_test! }
    end
  end
end
