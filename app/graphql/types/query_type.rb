module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :items, 
    [Types::ItemType],
    null: false, 
    description: 'Return a list of items'

    field :item, ItemType, 'Find an item by ID' do
      argument :id, ID
    end

    field :artists,
    [Types::ArtistType],
    null: false,
    description: 'Return a list of artists'

    def items
      Item.all
    end

    def item(id:)
      Item.find_by(id: id)
    end

    def artists
      Artist.all
    end
  end
end

# {
#   items {
#     id
#     title
#     description
#     artist {
#       firstName
#       lastName
#       email
#       createdAt
#     }
#   }
# }
