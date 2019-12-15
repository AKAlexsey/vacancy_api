defmodule VacancyApi.Jobs.ProfessionCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias VacancyApi.Jobs.Profession

  @cast_fields [:name]
  @required_fields [:name]

  schema "profession_categories" do
    field :name, :string

    has_many :professions, Profession, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(profession_category, attrs) do
    profession_category
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
