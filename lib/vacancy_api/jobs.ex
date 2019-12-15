defmodule VacancyApi.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias VacancyApi.Repo

  alias VacancyApi.Jobs.ProfessionCategory

  @doc """
  Returns the list of profession_categories.

  ## Examples

      iex> list_profession_categories()
      [%ProfessionCategory{}, ...]

  """
  def list_profession_categories do
    Repo.all(ProfessionCategory)
  end

  @doc """
  Gets a single profession_category.

  Raises `Ecto.NoResultsError` if the Profession category does not exist.

  ## Examples

      iex> get_profession_category!(123)
      %ProfessionCategory{}

      iex> get_profession_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profession_category!(id), do: Repo.get!(ProfessionCategory, id)

  @doc """
  Creates a profession_category.

  ## Examples

      iex> create_profession_category(%{field: value})
      {:ok, %ProfessionCategory{}}

      iex> create_profession_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profession_category(attrs \\ %{}) do
    %ProfessionCategory{}
    |> ProfessionCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profession_category.

  ## Examples

      iex> update_profession_category(profession_category, %{field: new_value})
      {:ok, %ProfessionCategory{}}

      iex> update_profession_category(profession_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profession_category(%ProfessionCategory{} = profession_category, attrs) do
    profession_category
    |> ProfessionCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProfessionCategory.

  ## Examples

      iex> delete_profession_category(profession_category)
      {:ok, %ProfessionCategory{}}

      iex> delete_profession_category(profession_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profession_category(%ProfessionCategory{} = profession_category) do
    Repo.delete(profession_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profession_category changes.

  ## Examples

      iex> change_profession_category(profession_category)
      %Ecto.Changeset{source: %ProfessionCategory{}}

  """
  def change_profession_category(%ProfessionCategory{} = profession_category) do
    ProfessionCategory.changeset(profession_category, %{})
  end

  alias VacancyApi.Jobs.Profession

  @doc """
  Returns the list of professions.

  ## Examples

      iex> list_professions()
      [%Profession{}, ...]

  """
  def list_professions do
    Repo.all(Profession)
  end

  @doc """
  Gets a single profession.

  Raises `Ecto.NoResultsError` if the Profession does not exist.

  ## Examples

      iex> get_profession!(123)
      %Profession{}

      iex> get_profession!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profession!(id), do: Repo.get!(Profession, id)

  @doc """
  Creates a profession.

  ## Examples

      iex> create_profession(%{field: value})
      {:ok, %Profession{}}

      iex> create_profession(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profession(attrs \\ %{}) do
    %Profession{}
    |> Profession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profession.

  ## Examples

      iex> update_profession(profession, %{field: new_value})
      {:ok, %Profession{}}

      iex> update_profession(profession, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profession(%Profession{} = profession, attrs) do
    profession
    |> Profession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Profession.

  ## Examples

      iex> delete_profession(profession)
      {:ok, %Profession{}}

      iex> delete_profession(profession)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profession(%Profession{} = profession) do
    Repo.delete(profession)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profession changes.

  ## Examples

      iex> change_profession(profession)
      %Ecto.Changeset{source: %Profession{}}

  """
  def change_profession(%Profession{} = profession) do
    Profession.changeset(profession, %{})
  end

  alias VacancyApi.Jobs.Job

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id), do: Repo.get!(Job, id)

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{source: %Job{}}

  """
  def change_job(%Job{} = job) do
    Job.changeset(job, %{})
  end
end
