# VacancyApi

## Getting started

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Set regions to all jobs `mix set_regions`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix endpoint with `mix phx.server`
* Visit [`localhost:4000`](http://localhost:4000)
* On page header there is **navigation links** to available pages

## First exercise

To see jobs grouped by regions and professions please visit `http://localhost:4000/professions_table`.
It's also available from **navigation links** by name `Professions table`

## Second exercise

In case of high load i will:

1. Move repo to separated application (may be in future we will partition jobs table values to several nodes) 
2. Implement caching system

## Third exercise

### Request

API description:
To request jobs you can request `/api/job_search`. It return result as JSON those looks like:
 
```
{
    page: 1,
    per_page: 100,
    total_results: 123,
    results: [
        ...
        ,{
            contract_type: "internship",
            name: "[Christian Dior UK Ltd] Reception Intern, London",
            office_latitude: 48.8661039,
            office_longitude: 2.305791,
            region: "europe",
            search_point_distance: 0.0
        },
        ...
    ]
}
```

Names of fields speaks for themselves.

### Accepted parameters

This is list of permitted values. Some of them are required. Some are optional.

* **lat** - Latitude of the point
* **lon** - Longitude of the point
* **redius** - Radius of search field in (kilometers or miles. Depends on **measure** parameter)
* **measure** - (optional) Permitted values: **[km, mile]**. Default: **km**
* **page** - (optional) Nuff said. Default: 1. If value is less than 1 - sets to default
* **per_page** - (optional) Nuff said. Default: 100. Maximum value 1000. If value is more than maximum - set to maximum  

## Tests
  
For running tests:

* Create database `MIX_ENV=test mix ecto.create`
* Run tests `mix test --cover` (test coverage 75%. Actual is approximately 100%. Because coverage count all modules, not only added by user)
