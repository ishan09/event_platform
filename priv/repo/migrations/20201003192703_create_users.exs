defmodule EventPlatform.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :role, :string
      add :date_of_birth, :date
      add :gender, :string
      add :password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
