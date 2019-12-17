defmodule VacancyApi.JobsRegionSearchTest do
  use VacancyApi.DataCase

  alias VacancyApi.Jobs
  alias VacancyApi.JobsRegionSearch

  describe "#perform" do
    setup do
      {lat_0, lon_0} = {43.594860, 1.452913}
      {lat_1, lon_1} = {48.814438, 2.084081}
      {lat_2, lon_2} = {48.804938, 2.120060}
      {lat_3, lon_3} = {48.859284, 2.233996}

      {:ok, %{id: category_id}} = Jobs.create_profession_category(%{name: "Backend"})

      {:ok, %{id: profession_id}} =
        Jobs.create_profession(%{name: "Backend", category_id: category_id})

      job1 =
        job_fixture(%{
          contract_type: :internship,
          name: "Spotify",
          office_latitude: lat_1,
          office_longitude: lon_1,
          profession_id: profession_id
        })

      job2 =
        job_fixture(%{
          contract_type: :full_time,
          name: "Facebook",
          office_latitude: lat_2,
          office_longitude: lon_2,
          region: :antarctic,
          profession_id: profession_id
        })

      job3 =
        job_fixture(%{
          contract_type: :apprenticeship,
          name: "Jira",
          office_latitude: lat_3,
          office_longitude: lon_3,
          profession_id: profession_id
        })

      {:ok,
       remote_search_point: {lat_0, lon_0},
       search_point: {lat_1, lon_1},
       job1: job1,
       job2: job2,
       job3: job3}
    end

    def job_fixture(attrs \\ %{}) do
      {:ok, job} = Jobs.create_job(attrs)

      job
    end

    test "Return right jobs if params valid",
         %{
           remote_search_point: {fail_lat, fail_lon},
           search_point: {success_lat, success_lon},
           job1: job1,
           job2: job2,
           job3: job3
         } do
      assert {:ok, []} = JobsRegionSearch.perform(fail_lat, fail_lon, 1)

      assert {:ok, [^job1]} = JobsRegionSearch.perform(success_lat, success_lon, 1)

      assert {:ok, results_2} = JobsRegionSearch.perform(success_lat, success_lon, 3)
      assert length(results_2) == 2
      assert job1 in results_2
      assert job2 in results_2

      assert {:ok, results_3} = JobsRegionSearch.perform(success_lat, success_lon, 13)
      assert length(results_3) == 3
      assert job1 in results_3
      assert job2 in results_3
      assert job3 in results_3
    end

    test "Return {:error, :invalid_params} if params invalid" do
      assert {:error, :invalid_params} == JobsRegionSearch.perform(90.1, 20.0, 1, :km)
      assert {:error, :invalid_params} == JobsRegionSearch.perform(-90.1, 20.0, 1, :mile)
      assert {:error, :invalid_params} == JobsRegionSearch.perform(10, 180.1, 1)
      assert {:error, :invalid_params} == JobsRegionSearch.perform(10, -180.1, 1)
      assert {:error, :invalid_params} == JobsRegionSearch.perform(10, 20, 0)
      assert {:error, :invalid_params} == JobsRegionSearch.perform(10, 20, -1)
      assert {:error, :invalid_params} == JobsRegionSearch.perform(10, 20, 1, :funt)
    end
  end
end
