defmodule VacancyApi.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset
  alias VacancyApi.Jobs.Profession

  @cast_fields [:name, :contract_type, :office_latitude, :office_longitude, :profession_id]
  @required_fields [:name, :contract_type, :office_latitude, :office_longitude, :profession_id]

  schema "jobs" do
    field :name, :string
    field :contract_type, ContractTypeEnum
    field :office_latitude, :float
    field :office_longitude, :float

    belongs_to :profession, Profession

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
