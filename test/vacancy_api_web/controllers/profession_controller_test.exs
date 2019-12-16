defmodule VacancyApiWeb.ProfessionControllerTest do
  use VacancyApiWeb.ConnCase

  alias VacancyApi.Jobs

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, category_id: nil}

  def fixture(:profession, attrs) do
    {:ok, profession} = Jobs.create_profession(Map.merge(@create_attrs, attrs))
    profession
  end

  describe "index" do
    test "lists all professions", %{conn: conn} do
      conn = get(conn, Routes.profession_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Professions"
    end
  end

  describe "new profession" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.profession_path(conn, :new))
      assert html_response(conn, 200) =~ "New Profession"
    end
  end

  describe "create profession" do
    setup [:create_category]

    test "redirects to show when data is valid", %{conn: conn, category_id: category_id} do
      conn =
        post(
          conn,
          Routes.profession_path(conn, :create),
          profession: Map.put(@create_attrs, :category_id, category_id)
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.profession_path(conn, :show, id)

      conn = get(conn, Routes.profession_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Profession"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.profession_path(conn, :create), profession: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profession"
    end
  end

  describe "edit profession" do
    setup [:create_category, :create_profession]

    test "renders form for editing chosen profession", %{conn: conn, profession: profession} do
      conn = get(conn, Routes.profession_path(conn, :edit, profession))
      assert html_response(conn, 200) =~ "Edit Profession"
    end
  end

  describe "update profession" do
    setup [:create_category, :create_profession]

    test "redirects when data is valid", %{conn: conn, profession: profession} do
      conn =
        put(conn, Routes.profession_path(conn, :update, profession), profession: @update_attrs)

      assert redirected_to(conn) == Routes.profession_path(conn, :show, profession)

      conn = get(conn, Routes.profession_path(conn, :show, profession))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, profession: profession} do
      conn =
        put(conn, Routes.profession_path(conn, :update, profession), profession: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Profession"
    end
  end

  describe "delete profession" do
    setup [:create_category, :create_profession]

    test "deletes chosen profession", %{conn: conn, profession: profession} do
      conn = delete(conn, Routes.profession_path(conn, :delete, profession))
      assert redirected_to(conn) == Routes.profession_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.profession_path(conn, :show, profession))
      end
    end
  end

  def create_category(_) do
    {:ok, %{id: category_id}} = Jobs.create_profession_category(%{name: "Backend"})
    {:ok, category_id: category_id}
  end

  defp create_profession(%{category_id: category_id}) do
    profession = fixture(:profession, %{category_id: category_id})
    {:ok, profession: profession}
  end
end
