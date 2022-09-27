class ItemsController < ApplicationController

  def index
    query_string = '{
                      items {
                        id
                        title
                        description
                        imageUrl
                      }
                    }'
    @items = GraphqlSchema.execute(query_string).dig('data', 'items')
    # puts "items === #{@items.inspect}"
  end

  def show
    query_string = 'query getItem($itemId: ID!) {
                      item(id: $itemId) {
                        id
                        title
                        description
                        artist {
                          firstName
                          lastName
                          email
                        }
                      }
                    }'
    variables = { 'itemId' => params[:id] }
    @item = GraphqlSchema.execute(query_string, variables: variables).dig('data', 'item')
    # puts "item === #{@item}"
  end

  def new
    @item = Item.new
  end

  def create
    puts "params === #{params}"
    item_params = params[:item]
    item_params[:image_url] = Item.first&.image_url if item_params[:image_url].blank?
    item_params[:artist_id] = Artist.first&.id if item_params[:artist_id].blank?
    query_string = "mutation createItem($itemParams: ItemInput!){
                      createItem(item: $itemParams) {
                        id
                        title
                        description
                        imageUrl
                        artistId
                      }
                    }"
    variables = { 'itemParams' => {
      'title' => item_params[:title],
      'description' => item_params[:description],
      'imageUrl' => item_params[:image_url].blank? ? Item.first&.image_url : item_params[:image_url],
      'artistId' => Artist.first&.id }
    }
    puts "variables = #{variables}"
    item = GraphqlSchema.execute(query_string, variables: variables)
    puts "item === #{item.inspect}"
    redirect_to items_path
  end

  private

  # def item_params
  #   params.require(:item).permit(:title, :description, :image_url, :artist_id)
  # end
end
