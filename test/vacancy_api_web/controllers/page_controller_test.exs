defmodule VacancyApiWeb.PageControllerTest do
  use VacancyApiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Vacancy API"
  end
end
