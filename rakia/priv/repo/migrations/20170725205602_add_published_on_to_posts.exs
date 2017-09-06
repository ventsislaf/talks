defmodule Rakia.Repo.Migrations.AddPublishedOnToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :published_on, :date
    end
  end
end
