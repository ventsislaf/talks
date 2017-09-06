defmodule RakiaWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Rakia.Repo

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :published_on, non_null(:date)
    field :author, non_null(:user), resolve: assoc(:user)
  end

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :posts, non_null(list_of(:post)), resolve: assoc(:posts)
  end

  input_object :update_post_params do
    field :title, :string
    field :body, :string
    field :user_id, :integer
  end

  input_object :update_user_params do
    field :name, :string
    field :email, :string
    field :password, :string
  end

  object :session do
    field :token, :string
  end

  # scalar :date do
  #   description """
  #   Date in IS8601 format.
  #   """
  #
  #   serialize &Date.to_iso8601/1
  #   parse &parse_date/1
  # end
  #
  # defp parse_date(%Absinthe.Blueprint.Input.String{value: value}) do
  #   case Date.from_iso8601(value) do
  #     {:ok, date} -> {:ok, date}
  #     _error -> :error
  #   end
  # end
  #
  # defp parse_date(_) do
  #   :error
  # end
end
