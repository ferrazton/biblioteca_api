class MaterialsController < ApplicationController
    
    before_action(:authenticate_user!)

    # index, show, create, update, destroy

    def index()
        materials = Material.all()
        materials = materials.order(created_at: :desc)
        render(json: materials, status: 200)
    end

    def show()
        material_id = params[:id]
        material = Material.find(material_id)
        render(json: material, status: 200)
    end

    def create()

        material = current_user.materials.new(material_params())
    
        saved = material.save()

        if saved
            render(json: material, status: 201)
        else
            render(json: {errors: material.errors.full_messages}, status: 422)
        end
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