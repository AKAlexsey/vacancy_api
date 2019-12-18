defmodule VacancyApi.ProfessionTableTest do
  use VacancyApi.DataCase

  alias VacancyApi.Jobs
  alias VacancyApi.ProfessionTable

  describe "#perform" do
    setup do
      %{id: profession1_id} = create_profession_fixture(%{name: "Developer", category_name: "IT"})

      %{id: profession2_id} =
        create_profession_fixture(%{name: "Concierge", category_name: "Tourism"})

      %{id: profession3_id} =
        create_profession_fixture(%{name: "Carpenter", category_name: "Industrial"})

      create_n_jobs(1, profession1_id, :north_america)
      create_n_jobs(2, profession1_id, :europe)
      create_n_jobs(3, profession1_id, :asia)
      create_n_jobs(4, profession2_id, :north_america)
      create_n_jobs(5, profession2_id, :europe)
      create_n_jobs(6, profession2_id, :asia)
      create_n_jobs(7, profession2_id, :australia)
      create_n_jobs(8, profession3_id, :north_america)
      create_n_jobs(9, profession3_id, :europe)
      create_n_jobs(10, profession3_id, :australia)
      create_n_jobs(11, profession3_id, :asia)

      result_standard = %ProfessionTable{
        headers: [
          :total,
          :north_america,
          :south_america,
          :europe,
          :africa,
          :australia,
          :asia,
          :antarctic,
          :pacific_ocean
        ],
        rows: [
          %{name: :total, columns: [66, 13, 0, 16, 0, 17, 20, 0, 0]},
          %{name: "IT", columns: [6, 1, 0, 2, 0, 0, 3, 0, 0]},
          %{name: "Industrial", columns: [38, 8, 0, 9, 0, 10, 11, 0, 0]},
          %{name: "Tourism", columns: [22, 4, 0, 5, 0, 7, 6, 0, 0]}
        ]
      }

      {:ok, result_standard: result_standard}
    end

    test "Return right statistics", %{result_standard: result_standard} do
      assert result_standard == ProfessionTable.perform()
    end
  end

  def create_profession_fixture(attrs) do
    {:ok, profession} = Jobs.create_profession(attrs)
    profession
  end

  def create_n_jobs(number, profession_id, region) do
    1..number
    |> Enum.each(fn n ->
      lat = :rand.uniform() * 180 - 90
      lon = :rand.uniform() * 360 - 180

      create_job_fixture(%{
        name: "Job name #{n}",
        office_latitude: lat,
        office_longitude: lon,
        profession_id: profession_id,
        region: region,
        contract_type: :internship
      })
    end)
  end

  def create_job_fixture(attrs) do
    {:ok, job} = Jobs.create_job(attrs)
    job
  end
end
