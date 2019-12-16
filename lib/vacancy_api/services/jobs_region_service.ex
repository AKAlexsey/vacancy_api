defmodule VacancyApi.JobsRegionService do
  @moduledoc """
  Perform assertion of regions to jobs
  """

  alias VacancyApi.{RegionService, Jobs}

  @doc """
  Workhorse function. Request jobs and by its longitude and latitude assign it's region
  """
  @spec perform :: :ok
  def perform do
    continent_polygons = RegionService.get_polygons()

    Jobs.list_jobs()
    |> Enum.each(fn %{office_latitude: latitude, office_longitude: longitude} = job ->
      {:ok, region} = RegionService.which_region(latitude, longitude, continent_polygons)
      {:ok, _} = Jobs.update_job(job, %{region: region})
    end)
  end
end
