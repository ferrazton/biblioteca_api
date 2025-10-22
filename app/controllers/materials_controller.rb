class MaterialsController < ApplicationController
    
    before_action(:authenticate_user!)

    def index()
        materials = Material.all()

        title = params[:title]
        kind = params[:kind]
        status = params[:status]
        author_id = params[:author_id]

        if title
            materials = materials.where("title ILIKE ?", "%#{title}%")
        end
        if kind
            materials = materials.where(kind: kind)
        end
        if status
            materials = materials.where(status: status)
        end
        if author_id
            materials = materials.where(author_id: author_id)
        end

        # Pagination
        page_param     = params[:page].to_i
        per_page_param = params[:per_page].to_i
        page     = (page_param > 0) ? page_param : 1
        per_page = (per_page_param > 0) ? per_page_param : 10

        materials = materials.order(created_at: :desc).page(page).per(per_page)
        render(json: materials, status: 200)
    end

    def show()
        material_id = params[:id]
        material = Material.find(material_id)
        render(json: material, status: 200)
    end

    def create()

        attrs = material_params().to_h

        if attrs["isbn"].to_s.strip != "" && attrs["kind"] == "book"

            data = OpenLibraryClient.fetch_book_by_isbn(attrs["isbn"])

            if attrs["title"].to_s.strip == "" && data[:title]
                attrs["title"] = data[:title]
            end
            if attrs["pages"].to_s.strip == "" && data[:pages]
                attrs["pages"] = data[:pages]
            end
        end

        material = current_user.materials.new(attrs)
    
        saved = material.save()

        if saved
            render(json: material, status: 201)
        else
            render(json: {errors: material.errors.full_messages}, status: 422)
        end
    end

    def update()
        material_id = params[:id]

        material = Material.find(material_id)

        updated = material.update(material_params())

        if updated
            render(json: material, status: 200)
        else
            render(json: {errors: materials.errors.full_messages}, status: 422)
        end
    end

    def destroy()
        material_id = params[:id]
        material = Material.find(material_id)

        if material.user_id != current_user.id
            render(json:{ error: "Forbidden" }, status: 403) and return
        end

        material.destroy()
        head(204)
    end

    private

    def material_params()
        permited = params.require(:material).permit(
            :title,
            :description,
            :status,
            :kind,
            :isbn,
            :pages,
            :doi,
            :duration,
            :author_id
        )
        return permited
    end
end