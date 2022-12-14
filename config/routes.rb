Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'items#index'
  resources :items do
    collection do
      get :multiplex
    end
  end

  get :all_items, to: 'items#all_items'
end
