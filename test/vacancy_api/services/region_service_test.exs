defmodule VacancyApi.RegionServiceTest do
  use ExUnit.Case
  alias VacancyApi.RegionService

  describe "#which_region" do
    setup do
      {
        :ok,
        region_polygons: RegionService.get_polygons(),
        error_standard: {:error, :invalid_params},
        non_continent_region: {:ok, :pacific_ocean},
        berlin_coordinates: {52.517301, 13.406871},
        washington_coordinates: {38.889304, -77.035242},
        sydney_coordinates: {-33.856921, 151.215621},
        beiging_coordinates: {39.916493, 116.397840},
        cape_town_coordinates: {-33.918068, 18.404582},
        rio_coordinates: {-22.952009, -43.210306},
        antarctic_coordinates: {-68.575812, 77.981644}
      }
    end

    test "Check check if points return to right part of world",
         %{
           region_polygons: region_polygons,
           berlin_coordinates: {eur_lat, eur_lon},
           washington_coordinates: {usa_lat, usa_lon},
           sydney_coordinates: {australia_lat, australia_lon},
           beiging_coordinates: {asia_lat, asia_lon},
           cape_town_coordinates: {afr_lat, afr_lon},
           rio_coordinates: {brazil_lat, brazil_lon},
           antarctic_coordinates: {antarctic_lat, antarctic_lon}
         } do
      assert {:ok, :europe} == RegionService.which_region(eur_lat, eur_lon, region_polygons)

      assert {:ok, :north_america} ==
               RegionService.which_region(usa_lat, usa_lon, region_polygons)

      assert {:ok, :australia} ==
               RegionService.which_region(australia_lat, australia_lon, region_polygons)

      assert {:ok, :asia} == RegionService.which_region(asia_lat, asia_lon, region_polygons)
      assert {:ok, :africa} == RegionService.which_region(afr_lat, afr_lon, region_polygons)

      assert {:ok, :south_america} ==
               RegionService.which_region(brazil_lat, brazil_lon, region_polygons)

      assert {:ok, :antarctic} ==
               RegionService.which_region(antarctic_lat, antarctic_lon, region_polygons)
    end

    test "Return error if params invalid",
         %{
           region_polygons: region_polygons,
           berlin_coordinates: {eur_lat, eur_lon},
           error_standard: error_standard
         } do
      assert error_standard == RegionService.which_region(eur_lat, 180.1, region_polygons)
      assert error_standard == RegionService.which_region(eur_lat, -180.1, region_polygons)
      assert error_standard == RegionService.which_region(90.1, eur_lon, region_polygons)
      assert error_standard == RegionService.which_region(-90.1, eur_lon, region_polygons)
    end

    test "Return right values for edge cases",
         %{region_polygons: region_polygons, berlin_coordinates: {eur_lat, eur_lon}} do
      assert {:ok, :north_america} == RegionService.which_region(eur_lat, 180, region_polygons)
      assert {:ok, :north_america} == RegionService.which_region(eur_lat, -180, region_polygons)
      assert {:ok, :europe} == RegionService.which_region(90, eur_lon, region_polygons)
      assert {:ok, :antarctic} == RegionService.which_region(-90, eur_lon, region_polygons)
    end

    test "Return {:ok, :pacific_ocean} if point does not match any polygon",
         %{berlin_coordinates: {eur_lat, _eur_lon}, non_continent_region: non_continent_region} do
      assert non_continent_region == RegionService.which_region(eur_lat, 180, [])
    end
  end

  describe "#get_polygons" do
    setup do
      {
        :ok,
        result_standard: [
          north_america: [
            %Geo.Polygon{
              coordinates: [
                [
                  {90, -168.75},
                  {90, -10},
                  {78.13, -10},
                  {57.5, -37.5},
                  {15, -30},
                  {15, -75},
                  {1.25, -82.5},
                  {1.25, -105},
                  {51, -180},
                  {60, -180},
                  {60, -168.75}
                ]
              ],
              properties: %{},
              srid: nil
            },
            %Geo.Polygon{
              coordinates: [[{51, 166.6}, {51, 180}, {60, 180}]],
              properties: %{},
              srid: nil
            }
          ],
          south_america: [
            %Geo.Polygon{
              coordinates: [
                [{1.25, -105}, {1.25, -82.5}, {15, -75}, {15, -30}, {-60, -30}, {-60, -105}]
              ],
              properties: %{},
              srid: nil
            }
          ],
          europe: [
            %Geo.Polygon{
              coordinates: [
                [
                  {90, -10},
                  {90, 77.5},
                  {42.5, 48.8},
                  {42.5, 30},
                  {40.79, 28.81},
                  {41, 29},
                  {40.55, 27.31},
                  {40.4, 26.75},
                  {40.05, 26.36},
                  {39.17, 25.19},
                  {35.46, 27.91},
                  {33, 27.5},
                  {38, 10},
                  {35.42, -10},
                  {28.25, -13},
                  {15, -30},
                  {57.5, -37.5},
                  {78.13, -10}
                ]
              ],
              properties: %{},
              srid: nil
            }
          ],
          africa: [
            %Geo.Polygon{
              coordinates: [
                [
                  {15, -30},
                  {28.25, -13},
                  {35.42, -10},
                  {38, 10},
                  {33, 27.5},
                  {31.74, 34.58},
                  {29.54, 34.92},
                  {27.78, 34.46},
                  {11.3, 44.3},
                  {12.5, 52},
                  {-60, 75},
                  {-60, -30}
                ]
              ],
              properties: %{},
              srid: nil
            }
          ],
          australia: [
            %Geo.Polygon{
              coordinates: [
                [
                  {-11.88, 110},
                  {-10.27, 140},
                  {-10, 145},
                  {-30, 161.25},
                  {-52.5, 142.5},
                  {-31.88, 110}
                ]
              ],
              properties: %{},
              srid: nil
            }
          ],
          asia: [
            %Geo.Polygon{
              coordinates: [
                [
                  {90, 77.5},
                  {42.5, 48.8},
                  {42.5, 30},
                  {40.79, 28.81},
                  {41, 29},
                  {40.55, 27.31},
                  {40.4, 26.75},
                  {40.05, 26.36},
                  {39.17, 25.19},
                  {35.46, 27.91},
                  {33, 27.5},
                  {31.74, 34.58},
                  {29.54, 34.92},
                  {27.78, 34.46},
                  {11.3, 44.3},
                  {12.5, 52},
                  {-60, 75},
                  {-60, 110},
                  {-31.88, 110},
                  {-11.88, 110},
                  {-10.27, 140},
                  {33.13, 140},
                  {51, 166.6},
                  {60, 180},
                  {90, 180}
                ]
              ],
              properties: %{},
              srid: nil
            },
            %Geo.Polygon{
              coordinates: [[{90, -180}, {90, -168.75}, {60, -168.75}, {60, -180}]],
              properties: %{},
              srid: nil
            }
          ],
          antarctic: [
            %Geo.Polygon{
              coordinates: [[{-60, -180}, {-60, 180}, {-90, 180}, {-90, -180}]],
              properties: %{},
              srid: nil
            }
          ]
        ]
      }
    end

    test "Return right polygons array", %{result_standard: standard} do
      assert standard == RegionService.get_polygons()
    end
  end
end
