defmodule EventPlatform.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:title, :string)
      add(:description, :text)
      add(:type, :string)
      add(:start_time, :naive_datetime)
      add(:end_time, :naive_datetime)
      add(:location, :string)
      add(:host_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:events, [:host_id]))
  end
end
