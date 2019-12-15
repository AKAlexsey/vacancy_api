defmodule VacancyApiWeb.ProfessionController do
  use VacancyApiWeb, :controller

  alias VacancyApi.Jobs
  alias VacancyApi.Jobs.Profession

  def index(conn, _params) do
    professions = Jobs.list_professions()
    render(conn, "index.html", professions: professions)
  end

  def new(conn, _params) do
    changeset = Jobs.change_profession(%Profession{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"profession" => profession_params}) do
    case Jobs.create_profession(profession_params) do
      {:ok, profession} ->
        conn
        |> put_flash(:info, "Profession created successfully.")
        |> redirect(to: Routes.profession_path(conn, :show, profession))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profession = Jobs.get_profession!(id)
    render(conn, "show.html", profession: profession)
  end

  def edit(conn, %{"id" => id}) do
    profession = Jobs.get_profession!(id)
    changeset = Jobs.change_profession(profession)
    render(conn, "edit.html", profession: profession, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profession" => profession_params}) do
    profession = Jobs.get_profession!(id)

    case Jobs.update_profession(profession, profession_params) do
      {:ok, profession} ->
        conn
        |> put_flash(:info, "Profession updated successfully.")
        |> redirect(to: Routes.profession_path(conn, :show, profession))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profession: profession, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profession = Jobs.get_profession!(id)
    {:ok, _profession} = Jobs.delete_profession(profession)

    conn
    |> put_flash(:info, "Profession deleted successfully.")
    |> redirect(to: Routes.profession_path(conn, :index))
  end
end
