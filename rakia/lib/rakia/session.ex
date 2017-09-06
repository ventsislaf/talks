defmodule Rakia.Session do
  alias Rakia.Repo
  alias Rakia.Blog.User

  def authenticate(%{email: email, password: password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect email or password"}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end
end
