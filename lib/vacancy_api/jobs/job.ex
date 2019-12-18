defmodule VacancyApi.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset
  alias VacancyApi.Jobs.Profession

  @cast_fields [
    :name,
    :contract_type,
    :office_latitude,
    :office_longitude,
    :profession_id,
    :region
  ]
  @required_fields [:name, :contract_type, :office_latitude, :office_longitude, :profession_id]

  schema "jobs" do
    field :name, :string
    field :contract_type, ContractTypeEnum
    field :office_latitude, :float
    field :office_longitude, :float
    field :region, RegionEnum
    field :search_point_distance, :float, virtual: true

    belongs_to :profession, Profession

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(prepare_attrs(attrs), @cast_fields)
    |> validate_required(@required_fields)
    |> validate_number(:office_latitude, less_than_or_equal_to: 90, greater_than_or_equal_to: -90)
    |> validate_number(:office_longitude,
      less_than_or_equal_to: 180,
      greater_than_or_equal_to: -180
    )
  end

  defp prepare_attrs(attrs) do
    attrs
    |> symbolize_keys()
    |> string_param_to_integer(:contract_type)
    |> string_param_to_integer(:region)
  end

  defp string_param_to_integer(attrs, key) do
    case attrs[key] do
      value when is_binary(value) ->
        updated_value =
          if(String.match?(value, ~r/^\d+$/), do: String.to_integer(value), else: value)

        Map.put(attrs, key, updated_value)

      value when is_integer(value) ->
        Map.put(attrs, key, value)

      _ ->
        attrs
    end
  end

  defp symbolize_keys(attrs) do
    attrs
    |> Enum.map(fn
      {key, value} when is_binary(key) ->
        {String.to_existing_atom(key), value}

      {key, value} ->
        {key, value}
    end)
    |> Enum.into(%{})
  end
end
