defmodule RakiaWeb.BlogResolver do
  alias Rakia.Blog

  def post(_root, %{id: id}, _info) do
    post = Blog.get_post!(id)
    {:ok, post}
  end

  def posts(_root, _args, _info) do
    posts = Blog.list_posts()
    {:ok, posts}
  end

  def my_posts(_root, _args, %{context: %{current_user: %{id: id}}}) do
    posts = Blog.user_posts(id)
    {:ok, posts}
  end

  def my_posts(_root, _args, _info) do
    {:error, "Not Authorized"}
  end

  def user(_root, %{id: id}, _info) do
    case Blog.get_user(id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def create_post(_root, args, _info) do
    Blog.create_post(args)
  end

  def update_post(_root, %{id: id, post: post_params}, _info) do
    Blog.get_post!(id)
    |> Blog.update_post(post_params)
  end

  def delete_post(_root, %{id: id}, _info) do
    Blog.get_post!(id)
    |> Blog.delete_post()
  end

  def update_user(_root, %{id: id, user: user_params}, _info) do
    Blog.get_user!(id)
    |> Blog.update_user(user_params)
  end

  def login(_root, args, _info) do
    with {:ok, user} <- Rakia.Session.authenticate(args),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user, :access) do
      {:ok, %{token: jwt}}
    end
  end
end
