defmodule VacancyApi.Repo.Migrations.CreateProfessions do
  use Ecto.Migration

  def change do
    create table(:professions) do
      add :name, :string, null: false
      add :category_id, references(:profession_categories, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:professions, [:category_id])
  end
end
