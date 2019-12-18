defmodule VacancyApi.JobsTest do
  use VacancyApi.DataCase

  alias VacancyApi.Jobs

  describe "professions" do
    alias VacancyApi.Jobs.Profession

    @valid_attrs %{name: "some name", category_name: "Backend"}
    @update_attrs %{name: "some updated name", category_name: "Mangement"}
    @invalid_attrs %{name: nil, category_name: nil}

    def profession_fixture(attrs \\ %{}) do
      {:ok, profession} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Jobs.create_profession()

      profession
    end

    test "list_professions/0 returns all professions" do
      profession = profession_fixture()
      assert Jobs.list_professions() == [profession]
    end

    test "get_profession!/1 returns the profession with given id" do
      profession = profession_fixture()
      assert Jobs.get_profession!(profession.id) == profession
    end

    test "create_profession/1 with valid data creates a profession" do
      assert {:ok, %Profession{} = profession} = Jobs.create_profession(@valid_attrs)

      assert profession.name == "some name"
    end

    test "create_profession/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_profession(@invalid_attrs)
    end

    test "update_profession/2 with valid data updates the profession" do
      profession = profession_fixture()
      assert {:ok, %Profession{} = profession} = Jobs.update_profession(profession, @update_attrs)
      assert profession.name == "some updated name"
    end

    test "update_profession/2 with invalid data returns error changeset" do
      profession = profession_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_profession(profession, @invalid_attrs)
      assert profession == Jobs.get_profession!(profession.id)
    end

    test "delete_profession/1 deletes the profession" do
      profession = profession_fixture()
      assert {:ok, %Profession{}} = Jobs.delete_profession(profession)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_profession!(profession.id) end
    end

    test "change_profession/1 returns a profession changeset" do
      profession = profession_fixture()
      assert %Ecto.Changeset{} = Jobs.change_profession(profession)
    end
  end

  describe "jobs" do
    alias VacancyApi.Jobs.Job

    @valid_attrs %{
      contract_type: :internship,
      name: "some name",
      office_latitude: 20.5,
      office_longitude: 120.5,
      region: :europe
    }
    @update_attrs %{
      contract_type: :full_time,
      name: "some updated name",
      office_latitude: 56.7,
      office_longitude: 56.7,
      region: :north_america
    }
    @invalid_attrs %{contract_type: nil, name: nil, office_latitude: nil, office_longitude: nil}

    def job_fixture(attrs \\ %{}) do
      {:ok, %{id: profession_id}} =
        Jobs.create_profession(%{name: "Backend", category_name: "Backend"})

      {:ok, job} =
        attrs
        |> Enum.into(Map.put(@valid_attrs, :profession_id, profession_id))
        |> Jobs.create_job()

      job
    end

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Jobs.list_jobs() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Jobs.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      {:ok, %{id: profession_id}} =
        Jobs.create_profession(%{name: "Backend", category_name: "Backend"})

      assert {:ok, %Job{} = job} =
               Jobs.create_job(Map.put(@valid_attrs, :profession_id, profession_id))

      assert job.contract_type == :internship
      assert job.name == "some name"
      assert job.office_latitude == 20.5
      assert job.office_longitude == 120.5
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      assert {:ok, %Job{} = job} = Jobs.update_job(job, @update_attrs)
      assert job.contract_type == :full_time
      assert job.name == "some updated name"
      assert job.office_latitude == 56.7
      assert job.office_longitude == 56.7
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(job, @invalid_attrs)
      assert job == Jobs.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
