defmodule VacancyApiWeb.ProfessionCategoryControllerTest do
  use VacancyApiWeb.ConnCase

  alias VacancyApi.Jobs

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:profession_category) do
    {:ok, profession_category} = Jobs.create_profession_category(@create_attrs)
    profession_category
  end

  describe "index" do
    test "lists all profession_categories", %{conn: conn} do
      conn = get(conn, Routes.profession_category_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Profession categories"
    end
  end

  describe "new profession_category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.profession_category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Profession category"
    end
  end

  describe "create profession_category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.profession_category_path(conn, :create), profession_category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.profession_category_path(conn, :show, id)

      conn = get(conn, Routes.profession_category_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Profession category"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.profession_category_path(conn, :create), profession_category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profession category"
    end
  end

  describe "edit profession_category" do
    setup [:create_profession_category]

    test "renders form for editing chosen profession_category", %{conn: conn, profession_category: profession_category} do
      conn = get(conn, Routes.profession_category_path(conn, :edit, profession_category))
      assert html_response(conn, 200) =~ "Edit Profession category"
    end
  end

  describe "update profession_category" do
    setup [:create_profession_category]

    test "redirects when data is valid", %{conn: conn, profession_category: profession_category} do
      conn = put(conn, Routes.profession_category_path(conn, :update, profession_category), profession_category: @update_attrs)
      assert redirected_to(conn) == Routes.profession_category_path(conn, :show, profession_category)

      conn = get(conn, Routes.profession_category_path(conn, :show, profession_category))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, profession_category: profession_category} do
      conn = put(conn, Routes.profession_category_path(conn, :update, profession_category), profession_category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Profession category"
    end
  end

  describe "delete profession_category" do
    setup [:create_profession_category]

    test "deletes chosen profession_category", %{conn: conn, profession_category: profession_category} do
      conn = delete(conn, Routes.profession_category_path(conn, :delete, profession_category))
      assert redirected_to(conn) == Routes.profession_category_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.profession_category_path(conn, :show, profession_category))
      end
    end
  end

  defp create_profession_category(_) do
    profession_category = fixture(:profession_category)
    {:ok, profession_category: profession_category}
  end
end
