defmodule VacancyApiWeb.JobSearchController do
  use VacancyApiWeb, :controller

  alias VacancyApi.Jobs
  alias VacancyApi.Jobs.Job

  def index(conn, _params) do
    render(conn, "index.json")
  end
end
