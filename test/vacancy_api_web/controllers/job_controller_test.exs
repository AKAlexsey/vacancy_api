defmodule VacancyApiWeb.JobControllerTest do
  use VacancyApiWeb.ConnCase

  alias VacancyApi.Jobs

  @create_attrs %{contract_type: :internship, name: "some name", office_latitude: 120.5, office_longitude: 120.5}
  @update_attrs %{contract_type: :full_time, name: "some updated name", office_latitude: 456.7, office_longitude: 456.7}
  @invalid_attrs %{contract_type: nil, name: nil, office_latitude: nil, office_longitude: nil}

  def fixture(:job, params) do
    {:ok, job} = Jobs.create_job(Map.merge(@create_attrs, params))
    job
  end

  describe "index" do
    test "lists all jobs", %{conn: conn} do
      conn = get(conn, Routes.job_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Jobs"
    end
  end

  describe "new job" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.job_path(conn, :new))
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "create job" do
    setup [:create_profession]

    test "redirects to show when data is valid", %{conn: conn, profession_id: profession_id} do
      conn = post(conn, Routes.job_path(conn, :create), job: Map.put(@create_attrs, :profession_id, profession_id))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.job_path(conn, :show, id)

      conn = get(conn, Routes.job_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Job"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.job_path(conn, :create), job: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "edit job" do
    setup [:create_profession, :create_job]

    test "renders form for editing chosen job", %{conn: conn, job: job} do
      conn = get(conn, Routes.job_path(conn, :edit, job))
      assert html_response(conn, 200) =~ "Edit Job"
    end
  end

  describe "update job" do
    setup [:create_profession, :create_job]

    test "redirects when data is valid", %{conn: conn, job: job} do
      conn = put(conn, Routes.job_path(conn, :update, job), job: @update_attrs)
      assert redirected_to(conn) == Routes.job_path(conn, :show, job)

      conn = get(conn, Routes.job_path(conn, :show, job))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, job: job} do
      conn = put(conn, Routes.job_path(conn, :update, job), job: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Job"
    end
  end

  describe "delete job" do
    setup [:create_profession, :create_job]

    test "deletes chosen job", %{conn: conn, job: job} do
      conn = delete(conn, Routes.job_path(conn, :delete, job))
      assert redirected_to(conn) == Routes.job_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.job_path(conn, :show, job))
      end
    end
  end

  defp create_profession(_) do
    {:ok, %{id: category_id}} = Jobs.create_profession_category(%{name: "Backend"})
    {:ok, %{id: profession_id}} = Jobs.create_profession(%{name: "Backend", category_id: category_id})
    {:ok, profession_id: profession_id}
  end

  defp create_job(%{profession_id: profession_id}) do
    job = fixture(:job, %{profession_id: profession_id})
    {:ok, job: job}
  end
end
