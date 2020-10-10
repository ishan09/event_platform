defmodule EventPlatform.Repo.Migrations.AddUserTopicsOfInterests do
  use Ecto.Migration

  def change do
    create table(:users_topics_of_interests, primary_key: false) do
      add(
        :user_id,
        references(:users, column: :id, on_delete: :delete_all),
        null: false
      )

      add(
        :topic_of_interest_id,
        references(:topics_of_interests, column: :id, on_delete: :delete_all),
        null: false
      )
    end

    create(unique_index(:users_topics_of_interests, [:topic_of_interest_id, :user_id]))
  end
end
