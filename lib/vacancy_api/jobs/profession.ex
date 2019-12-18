defmodule VacancyApi.Jobs.Profession do
  use Ecto.Schema
  import Ecto.Changeset

  alias VacancyApi.Jobs.Job

  @cast_fields [:name, :category_name]
  @required_fields [:name, :category_name]

  schema "professions" do
    field :name, :string
    field :category_name, :string

    has_many :jobs, Job

    timestamps()
  end

  @doc false
  def changeset(profession, attrs) do
    profession
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end

  def seed_changeset(profession, attrs) do
    profession
    |> cast(attrs, @cast_fields ++ [:id])
    |> validate_required(@required_fields ++ [:id])
  end
end
