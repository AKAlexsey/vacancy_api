defmodule VacancyApi.ProfessionTable do
  @moduledoc """
  Make two dimensional array for displaying jobs by regions.
  """

  # TODO add tests

  defstruct rows: [], headers: []

  @type t :: %__MODULE__{}

  @total_name :total
  @regions Keyword.keys(RegionEnum.__enum_map__())
  @table_headers [@total_name] ++ @regions

  alias VacancyApi.Jobs.Profession
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
      p in Profession,
      join: j in assoc(p, :jobs),
      group_by: [j.region, p.id],
      select: %{profession_name: p.name, jobs_count: count(j), region: j.region}
    )
    |> Repo.all()
  end

  defp make_rows(jobs_collection) do
    [make_total_row(jobs_collection)] ++ make_profession_rows(jobs_collection)
  end

  defp make_row(name, columns) do
    %{
      name: name,
      columns: columns
    }
  end

  defp make_total_row(jobs_collection) do
    jobs_by_region =
      jobs_collection
      |> Enum.group_by(fn %{region: region} -> region end)

    columns =
      @regions
      |> Enum.map(fn region ->
        jobs_by_region
        |> Map.get(region)
        |> case do
          nil ->
            0

          jobs_list ->
            Enum.reduce(jobs_list, 0, &(&1.jobs_count + &2))
        end
      end)

    make_row(@total_name, [Enum.sum(columns)] ++ columns)
  end

  defp make_profession_rows(jobs_collection) do
    jobs_collection
    |> Enum.group_by(fn %{profession_name: name} -> name end)
    |> Enum.map(fn {profession_name, jobs_list} ->
      columns =
        @regions
        |> Enum.map(fn region ->
          jobs_list
          |> Enum.find(fn %{region: jobs_region} -> jobs_region == region end)
          |> case do
            nil ->
              0

            %{jobs_count: jobs_count} ->
              jobs_count
          end
        end)

      make_row(profession_name, [Enum.sum(columns)] ++ columns)
    end)
  end

  defp return_result(rows) do
    %__MODULE__{
      headers: @table_headers,
      rows: rows
    }
  end
end
