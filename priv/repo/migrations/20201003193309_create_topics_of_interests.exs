defmodule EventPlatform.Repo.Migrations.CreateTopicsOfInterests do
  use Ecto.Migration

  def change do
    create table(:topics_of_interests) do
      add :title, :string

      timestamps()
    end

    create unique_index(:topics_of_interests, [:title])
  end
end
