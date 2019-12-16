defmodule VacancyApiWeb.Router do
  use VacancyApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VacancyApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/professions_table", PageController, :professions_table

    resources "/jobs", JobController
    resources "/professions", ProfessionController
    resources "/profession_categories", ProfessionCategoryController
  end

  # Other scopes may use custom stacks.
  # scope "/api", VacancyApiWeb do
  #   pipe_through :api
  # end
end
