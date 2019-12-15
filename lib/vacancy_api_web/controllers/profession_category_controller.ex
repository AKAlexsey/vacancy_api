defmodule VacancyApiWeb.ProfessionCategoryController do
  use VacancyApiWeb, :controller

  alias VacancyApi.Jobs
  alias VacancyApi.Jobs.ProfessionCategory

  def index(conn, _params) do
    profession_categories = Jobs.list_profession_categories()
    render(conn, "index.html", profession_categories: profession_categories)
  end

  def new(conn, _params) do
    changeset = Jobs.change_profession_category(%ProfessionCategory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"profession_category" => profession_category_params}) do
    case Jobs.create_profession_category(profession_category_params) do
      {:ok, profession_category} ->
        conn
        |> put_flash(:info, "Profession category created successfully.")
        |> redirect(to: Routes.profession_category_path(conn, :show, profession_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profession_category = Jobs.get_profession_category!(id)
    render(conn, "show.html", profession_category: profession_category)
  end

  def edit(conn, %{"id" => id}) do
    profession_category = Jobs.get_profession_category!(id)
    changeset = Jobs.change_profession_category(profession_category)
    render(conn, "edit.html", profession_category: profession_category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profession_category" => profession_category_params}) do
    profession_category = Jobs.get_profession_category!(id)

    case Jobs.update_profession_category(profession_category, profession_category_params) do
      {:ok, profession_category} ->
        conn
        |> put_flash(:info, "Profession category updated successfully.")
        |> redirect(to: Routes.profession_category_path(conn, :show, profession_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profession_category: profession_category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profession_category = Jobs.get_profession_category!(id)
    {:ok, _profession_category} = Jobs.delete_profession_category(profession_category)

    conn
    |> put_flash(:info, "Profession category deleted successfully.")
    |> redirect(to: Routes.profession_category_path(conn, :index))
  end
end
