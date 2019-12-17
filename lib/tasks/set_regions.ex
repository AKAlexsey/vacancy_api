defmodule Mix.Tasks.SetRegions do
  @moduledoc "Set regions to all jobs in database"

  use Mix.Task

  alias VacancyApi.JobsRegionService

  @shortdoc "Set regions to all jobs in database"
  def run(_) do
    init()

    IO.puts("Working...")
    JobsRegionService.perform()

    stop()
  end

  defp init do
    IO.puts("Starting dependencies...")
    Enum.each([:logger, :ssl, :postgrex, :ecto], &Application.ensure_all_started/1)

    IO.puts("Starting repos...")

    :vacancy_api
    |> Application.get_env(:ecto_repos)
    |> Enum.each(& &1.start_link(pool_size: 10))
  end

  defp stop do
    IO.puts("Success!")
    :init.stop()
  end
end
