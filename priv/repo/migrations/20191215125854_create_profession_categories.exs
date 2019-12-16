defmodule VacancyApi.Repo.Migrations.CreateProfessionCategories do
  use Ecto.Migration

  def change do
    create table(:profession_categories) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
