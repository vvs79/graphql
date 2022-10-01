module Mutations
  module Items
    class CreateItem < ::Mutations::BaseMutation
      argument :title, String, required: true
      argument :artist_id, Integer, required: true
      argument :image_url, String, required: true
      argument :description, String, required: true

      type Types::ItemType

      def resolve(artist_id:, **attributes)
        Artist.find_by(id: artist_id).items.create!(attributes)
      end
    end
  end
end
