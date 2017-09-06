defmodule Rakia.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rakia.Blog.Post


  schema "posts" do
    field :body, :string
    field :title, :string
    field :published_on, :date
    belongs_to :user, Rakia.Blog.User

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body, :published_on, :user_id])
    |> validate_required([:title, :body, :published_on, :user_id])
  end
end
