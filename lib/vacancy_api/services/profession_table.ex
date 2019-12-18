defmodule VacancyApi.ProfessionTable do
  @moduledoc """
  Make two dimensional array for displaying jobs by regions.
  """

  defstruct rows: [], headers: []

  @type t :: %__MODULE__{}

  @total_name :total
  @regions Keyword.keys(RegionEnum.__enum_map__())
  @table_headers [@total_name] ++ @regions

  alias VacancyApi.Jobs.Job
  alias VacancyApi.Repo
  import Ecto.Query

  @doc """
  Perform sql request for calculation statistics.
  Based on data requested from database make two dimensional array.
  """
  @spec perform :: t()
  def perform do
    fetch_data_from_database()
    |> make_rows()
    |> return_result()
  end

  defp fetch_data_from_database do
    from(
      j in Job,
      join: p in assoc(j, :profession),
      distinct: j.id,
      select: %{
        id: j.id,
        region: j.region,
        category_name: p.category_name
      }
    )
    |> Repo.all()
  end

  defp make_rows(jobs_collection) do
    [make_total_row(jobs_collection)] ++ make_profession_category_rows(jobs_collection)
  end

  defp make_row(name, columns) do
    %{
      name: name,
      columns: columns
    }
  end

  defp make_total_row(jobs_collection) do
    jobs_in_region = Enum.group_by(jobs_collection, fn %{region: region} -> region end)

    columns = Enum.map(@regions, &count_total_jobs_in_region(&1, jobs_in_region))

    make_row(@total_name, [Enum.sum(columns)] ++ columns)
  end

  defp count_total_jobs_in_region(region, jobs_in_region) do
    jobs_in_region
    |> Map.get(region)
    |> case do
      nil -> 0
      jobs_list -> length(jobs_list)
    end
  end

  defp make_profession_category_rows(jobs_collection) do
    jobs_collection
    |> Enum.group_by(fn %{category_name: category_name} -> category_name end)
    |> Enum.map(fn {category_name, jobs_by_category} ->
      columns = Enum.map(@regions, &count_jobs_by_category_name_in_region(&1, jobs_by_category))

      make_row(category_name, [Enum.sum(columns)] ++ columns)
    end)
  end

  defp count_jobs_by_category_name_in_region(region, jobs_by_category) do
    jobs_by_category
    |> Enum.reduce(
      0,
      fn %{region: job_region}, acc ->
        if(job_region == region, do: acc + 1, else: acc)
      end
    )
  end

  defp return_result(rows) do
    %__MODULE__{
      headers: @table_headers,
      rows: rows
    }
  end
end
