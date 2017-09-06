alias Rakia.Repo
alias Rakia.Blog.{Post, User}

users =
  [
    %User{name: "Jon snow", email: "jon.snow@example.com"} |> Repo.insert!,
    %User{name: "Ned Stark", email: "ned.stark@example.com"} |> Repo.insert!,
  ]

%Post{
  title: "Elixir Lang",
  body: "Elixir is a dynamic, functional language designed for building scalable and maintainable applications.",
  published_on: Date.utc_today,
  user_id: Enum.random(users).id,
}
|> Repo.insert!

%Post{
  title: "GraphQL",
  body: "GraphQL is a query language for APIs and a runtime for fulfilling those queries with your existing data.",
  published_on: Date.utc_today,
  user_id: Enum.random(users).id,
}
|> Repo.insert!

%Post{
  title: "Phoenix Framework",
  body: "A productive web framework that does not compromise speed and maintainability.",
  published_on: Date.utc_today,
  user_id: Enum.random(users).id,
}
|> Repo.insert!

%Post{
  title: "Absinthe",
  body: "The GraphQL toolkit for Elixir.",
  published_on: Date.utc_today,
  user_id: Enum.random(users).id,
}

|> Repo.insert!

%Post{
  title: "Apollo Client",
  body: "The flexible, production ready GraphQL client for React and native apps.",
  published_on: Date.utc_today,
  user_id: Enum.random(users).id,
}
|> Repo.insert!

%Post{
  title: "Ecto",
  body: "A database wrapper and language integrated query for Elixir.",
  published_on: Date.utc_today,
  user_id: Enum.random(users).id,
}
|> Repo.insert!
