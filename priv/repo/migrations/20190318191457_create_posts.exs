defmodule EctoExtensions.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :published_at, :utc_datetime
    end
  end
end
