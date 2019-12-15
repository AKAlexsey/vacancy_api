defmodule VacancyApi.ContinentService do
  @moduledoc """
  Gets Latitude and Longitude and return continent which this coordinates belongs
  """

  @north_america_name :"North america"
  @latitude_north_america_1 [90, 90, 78.13, 57.5, 15, 15, 1.25, 1.25, 51, 60, 60]
  @longitude_north_america_1 [-168.75, -10, -10, -37.5, -30, -75, -82.5, -105, -180, -180, -168.75]
  @latitude_north_america_2 [51, 51, 60]
  @longitude_north_america_2 [166.6, 180, 180]

  @south_america_name :"South america"
  @latitude_south_america [1.25, 1.25, 15, 15, -60, -60]
  @longitude_south_america [-105, -82.5, -75, -30, -30, -105]

  @europe_name :"Europe"
  @latitude_europe [
    90, 90, 42.5, 42.5, 40.79, 41, 40.55, 40.40, 40.05,
    39.17, 35.46, 33, 38, 35.42, 28.25, 15, 57.5, 78.13
  ]
  @longitude_europe [
    -10, 77.5, 48.8, 30, 28.81, 29, 27.31, 26.75, 26.36,
    25.19, 27.91, 27.5, 10, -10, -13, -30, -37.5, -10
  ]

  @africa_name :"Africa"
  @latitude_africa [15, 28.25, 35.42, 38, 33, 31.74, 29.54, 27.78, 11.3, 12.5, -60, -60]
  @longitude_africa [-30, -13, -10, 10, 27.5, 34.58, 34.92, 34.46, 44.3, 52, 75, -30]

  @australia_name :"Australia"
  @latitude_australia [-11.88, -10.27, -10, -30, -52.5, -31.88]
  @longitude_australia [110, 140, 145, 161.25, 142.5, 110]

  @asia_name :"Asia"
  @latitude_asia_1 [
    90, 42.5, 42.5, 40.79, 41, 40.55, 40.4, 40.05, 39.17,
    35.46, 33, 31.74, 29.54, 27.78, 11.3, 12.5, -60, -60,
    -31.88, -11.88, -10.27, 33.13, 51, 60, 90
  ]
  @longitude_asia_1 [
    77.5, 48.8, 30, 28.81, 29, 27.31, 26.75, 26.36, 25.19,
    27.91, 27.5, 34.58, 34.92, 34.46, 44.3, 52, 75, 110,
    110, 110, 140, 140, 166.6, 180, 180
  ]
  @latitude_asia_2 [90, 90, 60, 60]
  @longitude_asia_2 [-180, -168.75, -168.75, -180]

  @antarctic_name :"Antarctic"
  @latitude_antarctic [-60, -60, -90, -90]
  @longitude_antarctic [-180, 180, 180, -180]

  @doc """
  Gets Latitude and Longitude and return continent which this coordinates belongs.
  Returns {:ok, "Europe"} or {:error, :invalid_params}
  """
  def which_continent(longitude, latitude, regions_polygons)
      when latitude <= 90 and latitude >= -90 and longitude <= 180 and longitude >= -180 do
    regions_polygons
    |> Enum.find(fn {region, polygons} ->

    end)
    |> case do
         {region, _polygons} -> region
         nil -> {:error, :unexpected_error}
       end
  end
  def which_continent(_, _, _), do: {:error, :invalid_params}

  @doc """
  Return Keyword of polygons those describe zones related to according continents. Those looks like:

  ```
  [
    ...
    ,{
      :"Asia",
      [
        %Geo.Polygon{coordinates: [{90, -10}, {90, 77.5}, {42.5, 48.8}...]}
      ]
    }
    ...
  ]
  ```
  """
  @spec get_polygons :: Keyword.t
  def get_polygons do
    []
  end
end
