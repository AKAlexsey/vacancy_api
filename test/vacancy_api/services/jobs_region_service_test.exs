defmodule VacancyApi.JobsRegionServiceTest do
  use VacancyApi.DataCase
  alias VacancyApi.{Jobs, JobsRegionService}

  describe "#perform" do
    setup do
      {eur_lat, eur_lon} = {52.517301, 13.406871}
      {usa_lat, usa_lon} = {38.889304, -77.035242}
      {australia_lat, australia_lon} = {-33.856921, 151.215621}

      {:ok, %{id: category_id}} = Jobs.create_profession_category(%{name: "Backend"})

      {:ok, %{id: profession_id}} =
        Jobs.create_profession(%{name: "Backend", category_id: category_id})

      job1 =
        job_fixture(%{
          contract_type: :internship,
          name: "Spotify",
          office_latitude: eur_lat,
          office_longitude: eur_lon,
          profession_id: profession_id
        })

      job2 =
        job_fixture(%{
          contract_type: :full_time,
          name: "Facebook",
          office_latitude: usa_lat,
          office_longitude: usa_lon,
          region: :antarctic,
          profession_id: profession_id
        })

      job3 =
        job_fixture(%{
          contract_type: :apprenticeship,
          name: "Jira",
          office_latitude: australia_lat,
          office_longitude: australia_lon,
          profession_id: profession_id
        })

      {:ok, europe_job: job1, north_america_job: job2, australia_job: job3}
    end

    def job_fixture(attrs \\ %{}) do
      {:ok, job} = Jobs.create_job(attrs)

      job
    end

    test "Return OK. Update region if it's nil. ",
         %{
           europe_job: europe_job,
           north_america_job: north_america_job,
           australia_job: australia_job
         } do
      %{region: nil} = europe_job
      %{region: :antarctic} = north_america_job
      %{region: nil} = australia_job

      assert :ok == JobsRegionService.perform()

      assert %{region: :europe} = Jobs.get_job!(europe_job.id)
      assert %{region: :north_america} = Jobs.get_job!(north_america_job.id)
      assert %{region: :australia} = Jobs.get_job!(australia_job.id)
    end
  end
end
