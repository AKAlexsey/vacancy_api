defmodule VacancyApi.Repo.Migrations.AddExtensionForGeoSearch do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION cube;")
    execute("CREATE EXTENSION earthdistance;")
  end
end
