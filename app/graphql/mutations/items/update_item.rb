module Mutations
  module Items
    class UpdateItem < ::Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :title, String, required: false
      argument :artist_id, Integer, required: false
      argument :image_url, String, required: false
      argument :description, String, required: false

      type Types::ItemType

      def resolve(id:, **attributes)
        Item.find_by(id: id).tap do |item|
          item.update!(attributes)
        end
      end
    end
  end
end
