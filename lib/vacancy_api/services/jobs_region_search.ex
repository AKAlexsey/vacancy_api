defmodule VacancyApi.JobsRegionSearch do
  @moduledoc """
  Request all jobs in given range
  """

  defstruct results: [], page: nil, per_page: nil, total_results: nil

  @type t :: %__MODULE__{}

  @mile_coefficient 0.621371
  @permitted_measurements [:km, :mile]
  @job_white_list_attributes [
    :name,
    :contract_type,
    :office_latitude,
    :office_longitude,
    :region,
    :search_point_distance
  ]
  @default_per_page 100
  @maximum_per_page 1000

  alias VacancyApi.Jobs.Job
  alias VacancyApi.Repo
  import Ecto.Query

  @doc """
  Workhorse function those gets latitude, longitude, radius and measurement(:km, :miles).
  """
  @spec perform({float, float, float, atom}, map) :: {:ok, t()} | {:error, :invalid_params}
  def perform(query_params, pagination_params \\ %{})

  def perform({latitude, longitude, radius, measurement}, pagination_params)
      when latitude <= 90 and latitude >= -90 and
             longitude <= 180 and longitude >= -180 and
             radius > 0 and measurement in @permitted_measurements do
    search_query = get_search_query({latitude, longitude, get_search_radius(radius, measurement)})
    %{page: page, per_page: per_page} = get_pagination_params(pagination_params)

    {
      :ok,
      %{
        results: request_jobs(search_query, measurement, page, per_page),
        page: page,
        per_page: per_page,
        total_results: get_total_results(search_query)
      }
    }
  end

  def perform(_, _), do: {:error, :invalid_params}

  defp get_search_query({latitude, longitude, search_radius}) do
    from(
      j in Job,
      where:
        fragment(
          "point(?, ?) <@> point(?, ?) < ?",
          ^longitude,
          ^latitude,
          j.office_longitude,
          j.office_latitude,
          ^search_radius
        ),
      select: %{
        j
        | search_point_distance:
            fragment(
              "point(?, ?) <@> point(?, ?)",
              ^longitude,
              ^latitude,
              j.office_longitude,
              j.office_latitude
            )
      }
    )
  end

  defp request_jobs(query, measurement, page, per_page) do
    query
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
    |> Repo.all()
    |> Enum.map(fn job ->
      Map.update(
        job,
        :search_point_distance,
        0.0,
        fn value ->
          if(measurement == :km, do: value / @mile_coefficient, else: value)
        end
      )
    end)
    |> sanitize_job_attributes()
  end

  defp sanitize_job_attributes(jobs_collection) do
    Enum.map(
      jobs_collection,
      fn job ->
        {permitted_fields, _rejected_fields} = Map.split(job, @job_white_list_attributes)
        permitted_fields
      end
    )
  end

  defp get_total_results(query) do
    Repo.aggregate(query, :count, :id)
  end

  defp get_search_radius(radius, :km), do: radius * @mile_coefficient
  defp get_search_radius(radius, _), do: radius

  defp get_pagination_params(pagination_params) do
    %{
      page: get_page_from_params(pagination_params),
      per_page: get_per_page_from_params(pagination_params)
    }
  end

  defp get_page_from_params(pagination_params) do
    with page when is_binary(page) <- Map.get(pagination_params, :page, "0"),
         {page, ""} when page >= 1 <- Integer.parse(page) do
      page
    else
      page when is_integer(page) and page >= 1 -> page
      _ -> 1
    end
  end

  defp get_per_page_from_params(pagination_params) do
    with per_page when is_binary(per_page) <-
           Map.get(pagination_params, :per_page, "#{@default_per_page}"),
         {per_page, ""} when per_page < @maximum_per_page <- Integer.parse(per_page) do
      per_page
    else
      per_page when is_integer(per_page) and per_page < @maximum_per_page -> per_page
      _ -> @maximum_per_page
    end
  end
end
