defmodule VacancyApi.Repo do
  use Ecto.Repo,
    otp_app: :vacancy_api,
    adapter: Ecto.Adapters.Postgres
end
