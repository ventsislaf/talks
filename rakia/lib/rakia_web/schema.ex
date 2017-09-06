defmodule RakiaWeb.Schema do
  use Absinthe.Schema
  import_types RakiaWeb.Schema.Types
  import_types Absinthe.Type.Custom

  query do
    field :posts, non_null(list_of(non_null(:post))) do
      resolve &RakiaWeb.BlogResolver.posts/3
    end

    field :post, :post do
      arg :id, non_null(:id)
      resolve &RakiaWeb.BlogResolver.post/3
    end

    field :user, :user do
      arg :id, non_null(:id)
      resolve &RakiaWeb.BlogResolver.user/3
    end

    field :my_posts, list_of(:post) do
      resolve &RakiaWeb.BlogResolver.my_posts/3
    end
  end

  mutation do
    field :create_post, :post do
      arg :title, non_null(:string)
      arg :body, non_null(:string)
      arg :published_on, non_null(:date)
      arg :user_id, non_null(:integer)
      resolve &RakiaWeb.BlogResolver.create_post/3
    end

    field :update_post, :post do
      arg :id, non_null(:integer)
      arg :post, :update_post_params
      resolve &RakiaWeb.BlogResolver.update_post/3
    end

    field :delete_post, :post do
      arg :id, non_null(:integer)
      resolve &RakiaWeb.BlogResolver.delete_post/3
    end

    field :update_user, :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params

      resolve &RakiaWeb.BlogResolver.update_user/3
    end

    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &RakiaWeb.BlogResolver.login/3
    end
  end
end
