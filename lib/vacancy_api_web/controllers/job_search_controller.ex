defmodule VacancyApiWeb.JobSearchController do
  use VacancyApiWeb, :controller

  alias VacancyApi.{Jobs, JobsRegionSearch}
  alias VacancyApi.Jobs.Job

  @permitted_pagination_params ["page", "per_page"]

  def index(conn, params) do
    with {:ok, search_params} <- get_search_params(params),
         {:ok, pagination_params} <- get_pagination_params(params),
         {:ok, jobs_search_result} <-
           JobsRegionSearch.perform(search_params, pagination_params) do
      conn
      |> put_status(:ok)
      |> json(jobs_search_result)
    else
      {:error, :invalid_params} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid params"})

      {:error, :invalid_request_params} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid request params"})
    end
  end

  defp get_search_params(params) do
    with latitude when not is_nil(latitude) <- Map.get(params, "lat"),
         longitude when not is_nil(longitude) <- Map.get(params, "lon"),
         radius when not is_nil(radius) <- Map.get(params, "radius"),
         measurement when not is_nil(measurement) <- Map.get(params, "measure", "km") do
      {
        :ok,
        {
          to_float_param(latitude),
          to_float_param(longitude),
          to_float_param(radius),
          String.to_atom(measurement)
        }
      }
    else
      _ ->
        {:error, :invalid_request_params}
    end
  end

  defp get_pagination_params(params) do
    {permitted_pagination_params, _} = Map.split(params, @permitted_pagination_params)
    {:ok, symbolize_keys(permitted_pagination_params)}
  end

  defp to_float_param(string) do
    case Integer.parse(string) do
      {whole, ""} -> whole * 1.0
      {whole, decimal} -> whole + String.to_float("0#{decimal}")
    end
  end

  defp symbolize_keys(attrs) do
    attrs
    |> Enum.map(fn
      {key, value} when is_binary(key) ->
        {String.to_existing_atom(key), value}

      {key, value} ->
        {key, value}
    end)
    |> Enum.into(%{})
  end
end
