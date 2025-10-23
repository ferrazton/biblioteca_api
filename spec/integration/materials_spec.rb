require 'swagger_helper'

RSpec.describe 'Materials API', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/materials' do
    get 'List materials' do
      tags 'Materials'
      produces 'application/json'
      parameter name: :title,  in: :query, schema: { type: :string }
      parameter name: :author, in: :query, schema: { type: :string }
      parameter name: :page,   in: :query, schema: { type: :integer }
      parameter name: :per,    in: :query, schema: { type: :integer }

      response(200, 'ok') { run_test! }
    end

    post 'Create material' do
      tags 'Materials'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]  # requires JWT
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          material: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              kind: { type: :string, enum: %w[book article video] },
              status: { type: :string, enum: %w[draft published archived] },
              isbn: { type: :string },
              pages: { type: :integer },
              doi: { type: :string },
              duration: { type: :integer },
              author_id: { type: :integer }
            },
            required: %w[kind status author_id]
          }
        },
        required: ['material']
      }

      response(201, 'created') { run_test! }
      response(401, 'unauthorized') { run_test! }
    end
  end

  path "/materials/{id}" do
    parameter name: :id, in: :path, schema: { type: :integer }, required: true, description: "Material ID"

    get "Show material" do
        tags "Materials"
        produces "application/json"
        response(200, "ok") { run_test! }
        response(404, "not found") { run_test! }
    end

    patch "Update material (owner only)" do
        tags "Materials"
        consumes "application/json"
        produces "application/json"
        security [bearerAuth: []]
        parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
            material: {
            type: :object,
            properties: {
                title: { type: :string },
                description: { type: :string },
                status: { type: :string, enum: %w[draft published archived] },
                isbn: { type: :string },
                pages: { type: :integer },
                doi: { type: :string },
                duration: { type: :integer },
                author_id: { type: :integer }
            }
            }
        },
        required: ["material"]
        }

        response(200, "updated") { run_test! }
        response(401, "unauthorized") { run_test! }
        response(403, "forbidden (not owner)") { run_test! }
        response(404, "not found") { run_test! }
        response(422, "validation error") { run_test! }
    end

    delete "Delete material (owner only)" do
        tags "Materials"
        security [bearerAuth: []]
        response(204, "no content (deleted)") { run_test! }
        response(401, "unauthorized") { run_test! }
        response(403, "forbidden (not owner)") { run_test! }
        response(404, "not found") { run_test! }
    end
  end
end
