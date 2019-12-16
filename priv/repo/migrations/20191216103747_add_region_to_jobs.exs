defmodule VacancyApi.Repo.Migrations.AddRegionToJobs do
  use Ecto.Migration

  def change do
    alter(table(:jobs)) do
      add(:region, :integer)
    end

    create index(:jobs, [:region])
  end
end
