defmodule EventPlatform.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :status, :integer
      add :event_id, references(:events, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:invites, [:event_id])
    create index(:invites, [:user_id])
    create unique_index(:invites, [:event_id, :user_id])

  end
end
