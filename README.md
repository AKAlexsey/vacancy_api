# VacancyApi

## Getting started

* Install dependencies with `mix deps.get`
* Create, migrate and seed database with `mix ecto.setup` (in case you need start from the beginning `mix ecto.reset`)
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

1. Move repo to separated application. We 

2. Distribute big database tables (horizontal sharding) for several nodes to share load between several nodes.
Also move high loaded tables to separate severs(vertical sharding)
 
3. Cache.
Most of my career i have used external caching like Memcached, Redis, Mnesia. This is most straight forward approach. But i know that in high performance systems also used in database caching. So it depends on details. 
At first i will use external caching system if it wouldn't be enough look for database tools.

## Third exercise

### API description

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
* **measure** - (Optional. Default: **km**) Permitted values: **[km, mile]**. 
* **page** - (Optional. Default: 1) Page of the request. If value is less than 1 - sets to default
* **per_page** - (Optional. Default: 100) Elements per page. Maximum value 1000. If value is more than maximum - set to maximum

### Request examples

* `http://localhost:4000/api/job_search?lat=48.8661039&lon=2.305791&radius=0.4` # => 428 results
* `http://localhost:4000/api/job_search?lat=48.8661039&lon=2.305791&radius=0.4&measure=mile` # => 451 result
but please look at search_point_distance it's different(where it's not zero) because it's in miles(in kilometers by default).
* `http://localhost:4000/api/job_search?lat=26.3659017&lon=-80.1343467&radius=75` # => 11 results
* `http://localhost:4000/api/job_search?lat=26.3659017&lon=-80.1343467&radius=100` # => 13 results
* `http://localhost:4000/api/job_search?lat=40.762264&lon=-73.9735165&radius=6000&per_page=4000` # => 4518 results
Passed per_page parameter 4000. But set to maximum - 1000

## Tests
  
For running tests:

* Create database `MIX_ENV=test mix ecto.create`
* Run tests `mix test --cover` (test coverage 72%. Actual is close to 100%. Because coverage count all modules, not only added by user)
