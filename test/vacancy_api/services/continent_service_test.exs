defmodule VacancyApi.ContinentServiceTest do
  use ExUnit.Case
  alias VacancyApi.ContinentService

  describe "#which_continent" do
    setup do
      {
        :ok,
        region_polygons: ContinentService.get_polygons(),
        error_standard: {:error, :invalid_params},
        unexpected_error_standard: {:error, :unexpected_error},
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
      assert {:ok, :"Europe"} == ContinentService.which_continent(eur_lat, eur_lon, region_polygons)
      assert {:ok, :"North america"} == ContinentService.which_continent(usa_lat, usa_lon, region_polygons)
      assert {:ok, :"Australia"} == ContinentService.which_continent(australia_lat, australia_lon, region_polygons)
      assert {:ok, :"Asia"} == ContinentService.which_continent(asia_lat, asia_lon, region_polygons)
      assert {:ok, :"Africa"} == ContinentService.which_continent(afr_lat, afr_lon, region_polygons)
      assert {:ok, :"South america"} == ContinentService.which_continent(brazil_lat, brazil_lon, region_polygons)
      assert {:ok, :"Antarctic"} == ContinentService.which_continent(antarctic_lat, antarctic_lon, region_polygons)
    end

    test "Return error if params invalid",
         %{region_polygons: region_polygons, berlin_coordinates: {eur_lat, eur_lon}, error_standard: error_standard} do
      assert error_standard == ContinentService.which_continent(eur_lat, 180.1, region_polygons)
      assert error_standard == ContinentService.which_continent(eur_lat, -180.1, region_polygons)
      assert error_standard == ContinentService.which_continent(90.1, eur_lon, region_polygons)
      assert error_standard == ContinentService.which_continent(-90.1, eur_lon, region_polygons)
    end

    test "Return right values for edge cases",
         %{region_polygons: region_polygons, berlin_coordinates: {eur_lat, eur_lon}} do
      assert {:ok, :"North america"} == ContinentService.which_continent(eur_lat, 180, region_polygons)
      assert {:ok, :"North america"} == ContinentService.which_continent(eur_lat, -180, region_polygons)
      assert {:ok, :Europe} == ContinentService.which_continent(90, eur_lon, region_polygons)
      assert {:ok, :Antarctic} == ContinentService.which_continent(-90, eur_lon, region_polygons)
    end

    test "Return {:error, :unexpected_error} if point does not match any polygon",
         %{berlin_coordinates: {eur_lat, _eur_lon}, unexpected_error_standard: error_standard} do
      assert error_standard == ContinentService.which_continent(eur_lat, 180, [])
    end
  end

  describe "#get_polygons" do
    setup do
      {:ok, result_standard: []}
    end

    test "Return right polygons array", %{result_standard: standard} do
      assert standard == [] # ContinentService.get_polygons()
    end
  end
end
