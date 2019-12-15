# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VacancyApi.Repo.insert!(%VacancyApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias VacancyApi.{Jobs, Repo}
alias VacancyApi.Jobs.Profession

seed_data_path = "./priv/repo/seed_data"
professions_path = "#{seed_data_path}/technical-test-professions.csv"
jobs_path = "#{seed_data_path}/technical-test-jobs.csv"

professions_data_stream = professions_path
                          |> File.stream!()
                          |> CSV.decode()

category_names = professions_data_stream
                 |> Enum.map(fn {:ok, [_, _, category_name]} -> category_name end)
                 |> Enum.uniq()

category_name_ids = category_names
                    |> Enum.reduce(
                         %{},
                         fn name, acc ->
                           {:ok, %{id: category_id}} = Jobs.create_profession_category(%{name: name})
                           Map.put(acc, name, category_id)
                         end
                       )

professions_data_stream = professions_data_stream
                          |> Enum.each(
                               fn {:ok, [profession_id, profession_name, category_name]} ->
                                 category_id = category_name_ids[category_name]
                                 %Profession{}
                                 |> Profession.seed_changeset(
                                      %{id: profession_id, name: profession_name, category_id: category_id}
                                    )
                                 |> Repo.insert()
                               end
                             )

jobs_path
|> File.stream!()
|> CSV.decode()
|> Enum.each(fn {:ok, [profession_id, contract_type, name, office_latitude, office_longitude]} ->
  %{
    profession_id: profession_id,
    contract_type: String.downcase(contract_type),
    name: name,
    office_latitude: office_latitude,
    office_longitude: office_longitude
  }
  |> Jobs.create_job()
end)
