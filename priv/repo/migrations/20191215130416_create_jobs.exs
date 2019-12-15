defmodule VacancyApi.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :name, :string, null: false
      add :contract_type, :integer, null: false
      add :office_latitude, :float, null: false
      add :office_longitude, :float, null: false
      add :profession_id, references(:professions, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:jobs, [:profession_id])
    create index(:jobs, [:contract_type])
    create index(:jobs, [:office_latitude])
    create index(:jobs, [:office_longitude])
  end
end
