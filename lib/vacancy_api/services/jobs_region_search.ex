defmodule VacancyApi.JobsRegionSearch do
  @moduledoc """
  Request all jobs in given range
  """

  alias VacancyApi.Jobs.Job
  alias VacancyApi.Repo
  import Ecto.Query

  @mile_coefficient 0.621371
  @permitted_measurements [:km, :mile]

  @doc """
  Workhorse function those gets latitude, longitude, radius and measurement(:km, :miles).
  """
  @spec perform(float, float, float, atom) :: {:ok, list()} | {:error, :invalid_params}
  def perform(latitude, longitude, radius, measurement \\ :km)

  def perform(latitude, longitude, radius, measurement)
      when latitude <= 90 and latitude >= -90 and
             longitude <= 180 and longitude >= -180 and
             radius > 0 and measurement in @permitted_measurements do
    {:ok, request_points(latitude, longitude, get_search_radius(radius, measurement))}
  end

  def perform(_, _, _, _), do: {:error, :invalid_params}

  defp request_points(latitude, longitude, radius) do
    from(
      j in Job,
      where:
        fragment(
          "point(?, ?) <@> point(?, ?) < ?",
          ^longitude,
          ^latitude,
          j.office_longitude,
          j.office_latitude,
          ^radius
        )
    )
    |> Repo.all()
  end

  defp get_search_radius(radius, :km), do: radius * @mile_coefficient
  defp get_search_radius(radius, _), do: radius
end
