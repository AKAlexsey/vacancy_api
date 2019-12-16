defmodule VacancyApi.ContinentService do
  @moduledoc """
  Gets Latitude and Longitude and return continent which this coordinates belongs
  """

  @north_america_name :"North america"
  @north_america_points_1 [
    {90, -168.75}, {90, -10}, {78.13, -10}, {57.5, -37.5}, {15, -30},
    {15, -75}, {1.25, -82.5}, {1.25, -105}, {51, -180}, {60, -180}, {60, -168.75}
  ]
  @north_america_points_2 [{51, 166.6}, {51, 180}, {60, 180}]

  @south_america_name :"South america"
  @south_america_points [{1.25, -105}, {1.25, -82.5}, {15, -75}, {15, -30}, {-60, -30}, {-60, -105}]

  @europe_name :"Europe"
  @europe_points [
    {90, -10}, {90, 77.5}, {42.5, 48.8}, {42.5, 30}, {40.79, 28.81},
    {41, 29}, {40.55, 27.31}, {40.4, 26.75}, {40.05, 26.36}, {39.17, 25.19},
    {35.46, 27.91}, {33, 27.5}, {38, 10}, {35.42, -10}, {28.25, -13},
    {15, -30}, {57.5, -37.5}, {78.13, -10}
  ]

  @africa_name :"Africa"
  @africa_points [
    {15, -30}, {28.25, -13}, {35.42, -10}, {38, 10},
    {33, 27.5}, {31.74, 34.58}, {29.54, 34.92},
    {27.78, 34.46}, {11.3, 44.3}, {12.5, 52},
    {-60, 75}, {-60, -30}
  ]

  @australia_name :"Australia"
  @australia_points [{-11.88, 110}, {-10.27, 140}, {-10, 145}, {-30, 161.25}, {-52.5, 142.5}, {-31.88, 110}]

  @asia_name :"Asia"
  @asia_points_1 [
    {90, 77.5}, {42.5, 48.8}, {42.5, 30}, {40.79, 28.81},
    {41, 29}, {40.55, 27.31}, {40.4, 26.75}, {40.05, 26.36},
    {39.17, 25.19}, {35.46, 27.91}, {33, 27.5}, {31.74, 34.58},
    {29.54, 34.92}, {27.78, 34.46}, {11.3, 44.3}, {12.5, 52},
    {-60, 75}, {-60, 110}, {-31.88, 110}, {-11.88, 110},
    {-10.27, 140}, {33.13, 140}, {51, 166.6}, {60, 180}, {90, 180}
  ]
  @asia_points_2 [{90, -180}, {90, -168.75}, {60, -168.75}, {60, -180}]

  @antarctic_name :"Antarctic"
  @antarctic_points [{-60, -180}, {-60, 180}, {-90, 180}, {-90, -180}]

  @doc """
  Gets Latitude and Longitude and return continent which this coordinates belongs.
  Returns {:ok, "Europe"} or {:error, :invalid_params}
  """
  def which_continent(latitude, longitude, regions_polygons)
      when latitude <= 90 and latitude >= -90 and longitude <= 180 and longitude >= -180 do
    map_point = %Geo.Point{coordinates: {latitude, longitude}}
    regions_polygons
    |> Enum.find(
         fn {region, polygons} ->
           Enum.any?(polygons, & Topo.intersects?(&1, map_point))
         end
       )
    |> case do
         {region, _polygons} -> {:ok, region}
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
        %Geo.Polygon{coordinates: [[{90, -10}, {90, 77.5}, {42.5, 48.8}...]]}
      ]
    }
    ...
  ]
  ```
  """
  @spec get_polygons :: Keyword.t
  def get_polygons do
    [
      make_region_polygons(@north_america_name, [@north_america_points_1, @north_america_points_2]),
      make_region_polygons(@south_america_name, [@south_america_points]),
      make_region_polygons(@europe_name, [@europe_points]),
      make_region_polygons(@africa_name, [@africa_points]),
      make_region_polygons(@australia_name, [@australia_points]),
      make_region_polygons(@asia_name, [@asia_points_1, @asia_points_2]),
      make_region_polygons(@antarctic_name, [@antarctic_points]),
    ]
  end
  defp make_region_polygons(region, coordinates) do
    coordinates
    |> Enum.map(&(%Geo.Polygon{coordinates: [&1]}))
    |> (fn polygons -> {region, polygons} end).()
  end
end
