module Types
  class MutationType < Types::BaseObject
    field :create_item, mutation: Mutations::Items::CreateItem
    field :destroy_item, mutation: Mutations::Items::DestroyItem
    field :update_item, mutation: Mutations::Items::UpdateItem
  end
end
