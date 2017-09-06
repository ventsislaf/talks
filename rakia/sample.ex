# lib/rakia_web/resolvers/blog_resolver.ex

def login(_root, args, _info) do
  with {:ok, user} <- Rakia.Session.authenticate(args),
        {:ok, jwt, _} <- Guardian.encode_and_sign(user, :access) do
    {:ok, %{token: jwt}}
  end
end
