defmodule VacancyApiWeb.PageController do
  use VacancyApiWeb, :controller

  alias VacancyApi.ProfessionTable

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def professions_table(conn, _params) do
    professions_table = ProfessionTable.perform()

    conn
    |> assign(:professions_table, professions_table)
    |> render("professions_table.html")
  end
end
