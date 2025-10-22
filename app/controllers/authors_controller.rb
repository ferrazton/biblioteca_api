class AuthorsController < ApplicationController

    before_action(:authenticate_user!)

    # index, show, create, update, destroy

    def index()
        authors = Author.all()
        authors = authors.order(created_at: :desc)
        render(json: authors, status: 200)
    end

    def show()
        author_id = params[:id]
        author = Author.find(author_id)
        render(json: author, status: 200)
    end

    def create()

        author = Author.new(author_params())

        if author.save()
            render(json: author, status: 201)
        else
            render(json: {errors: author.errors.full_messages}, status: 422)
        end
    end

    private

    def author_params()
        permited = params.require(:author).permit(
            :name,
            :kind,
            :birth_date,
            :city
        )
        return permited
    end
end