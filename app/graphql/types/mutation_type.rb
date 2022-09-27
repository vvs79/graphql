module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    # field :test_field, String, null: false,
    #   description: "An example field added by the generator"
    # def test_field
    #   "Hello World"
    # end

    field :create_item, ItemType#, 'Add new item' do
    #   argument :params, ItemInput
    # end

    def create_item(params:)
      puts "params === #{params}"
      # p object
    end
  end
end
