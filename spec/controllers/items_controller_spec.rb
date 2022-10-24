# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  render_views

  let(:artist) { create(:artist) }
  before do
    create_list(:item, 3, artist_id: artist.id)
  end

  it '#index' do
    get :index

    expect(response.status).to eq 200
    expect(artist.items.size).to eq 3
    artist.items.each do |item|
      expect(response.body).to include(item.title)
      expect(response.body).to include(item.description)
      expect(response.body).to include(item.image_url)
    end
    expect(response.body).not_to include(artist.email)
  end

  it '#multiplex' do
    get :multiplex

    expect(response.status).to eq 200
    expect(Item.all.size).to eq 3
    expect(Artist.all.size).to eq 1
    Item.all.each do |item|
      expect(response.body).to include(item.title)
      expect(response.body).to include(item.description)
      expect(response.body).to include(item.image_url)
    end
    Artist.all.each do |artist|
      expect(response.body).to include(artist.email)
      expect(response.body).to include(artist.full_name)
    end
  end

  it '#show' do
    item = artist.items.last
    get :show, params: { id: item.id }

    expect(response.status).to eq 200
    expect(response.body).to include(artist.email)
    expect(response.body).to include(artist.full_name)
    expect(response.body).to include(item.title)
    expect(response.body).to include(item.description)
    expect(response.body).not_to include(item.image_url)
  end

  it '#update' do
    item = artist.items.last
    patch :update, params: {
      id: item.id,
      item: {
        title: 'New title',
        description: 'New description',
        image_url: 'https://image.com/new_image.png'
      }
    }

    item = artist.items.find_by(id: item.id)
    expect(response).to redirect_to(item_path(item))
    expect(item.title).to eq('New title')
    expect(item.description).to eq('New description')
    expect(item.image_url).to eq('https://image.com/new_image.png')
  end

  it '#create' do
    post :create, params: {
      item: {
        title: 'New title',
        description: 'New description',
        image_url: 'https://image.com/new_image.png',
        artist_id: artist.id
      }
    }

    expect(artist.items.size).to eq 4
    expect(response).to redirect_to(items_path)

    item = artist.items.order(:id).last
    expect(item.title).to eq('New title')
    expect(item.description).to eq('New description')
    expect(item.image_url).to eq('https://image.com/new_image.png')
    expect(item.artist_id).to eq(artist.id)
  end

  it '#destroy' do
    item = artist.items.last
    delete :destroy, params: { id: item.id }

    expect(artist.items.size).to eq 2
    expect(response).to redirect_to(items_path)

    item = artist.items.find_by(id: item.id)
    expect(item).to be_nil
  end
end
