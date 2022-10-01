module Mutations
  module Items
    class DestroyItem < ::Mutations::BaseMutation
      argument :id, Integer, required: true

      type Types::ItemType

      def resolve(id:)
        Item.find_by(id: id).destroy
      end
    end
  end
end
