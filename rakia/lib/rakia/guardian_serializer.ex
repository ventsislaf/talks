defmodule Rakia.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Rakia.Blog

  def for_token(user = %Blog.User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Blog.get_user(id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
