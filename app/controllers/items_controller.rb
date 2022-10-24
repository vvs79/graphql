class ItemsController < ApplicationController

  def index
    @items = GraphqlSchema.execute(items_query_string, variables: {}, operation_name: nil, context: {}).dig('data', 'items')
  end

  def show
    query_string = 'query getItem($itemId: ID!) {
                      item(id: $itemId) {
                        id
                        title
                        description
                        artist {
                          fullName
                          email
                        }
                      }
                    }'
    variables = { 'itemId' => params[:id] }
    @item = GraphqlSchema.execute(query_string, variables: variables).dig('data', 'item')
  end

  def new
    @item = Item.new
  end

  def create
    item_params = params[:item]
    item_params = "title: \"#{item_params[:title]}\",
                   description: \"#{item_params[:description]}\",
                   imageUrl: \"#{item_params[:image_url].blank? ? Item.first&.image_url : item_params[:image_url]}\",
                   artistId: #{item_params[:artist_id] || Artist.first&.id}"

    query_string = "mutation {
                      createItem(#{item_params}) {
                        id
                        title
                        description
                        imageUrl
                        artistId
                      }
                    }"

    GraphqlSchema.execute(query_string)
    redirect_to items_path
  end

  def destroy
    id = params[:id]
    query_string = "mutation {
                      destroyItem(id: #{id}) {
                        id
                        title
                        description
                        imageUrl
                        artistId
                      }
                    }"

    item = GraphqlSchema.execute(query_string)
    redirect_to items_path
  end

  def edit
    @item = Item.find_by(id: params[:id])
  end

  def update
    item = Item.find_by(id: params[:id])
    item_params = params[:item]
    item_params = "title: \"#{item_params[:title]}\",
                   description: \"#{item_params[:description]}\",
                   imageUrl: \"#{item_params[:image_url]}\""

    query_string = "mutation {
                      updateItem(id: #{params[:id]}, #{item_params}) {
                        id
                        title
                        description
                        imageUrl
                        artistId
                      }
                    }"

    GraphqlSchema.execute(query_string)
    redirect_to item_path(item)
  end

  def multiplex
    artists_query_string = '{
                             artists {
                               id
                               email
                               fullName
                             }
                           }'

    res = GraphqlSchema.multiplex([
            {query: items_query_string},
            {query: artists_query_string},
          ])
    @items = res[0].dig('data', 'items')
    @artists = res[1].dig('data', 'artists')
  end

  private

  def items_query_string
    '{
      items {
        id
        title
        description
        imageUrl
      }
    }'
  end

  # def item_params
  #   params.require(:item).permit(:title, :description, :image_url, :artist_id)
  # end
end
