defmodule VacancyApi.ContinentServiceTest do
  use ExUnit.Case
  alias VacancyApi.ContinentService

  describe "#which_continent" do
    setup do
      {
        :ok,
        region_polygons: ContinentService.get_polygons(),
        error_standard: {:error, :invalid_params},
        moscow_coordinates: {55.752322, 37.669502},
        washington_coordinates: {},
        sydney_coordinates: {},
        beiging_coordinates: {}
      }
    end

    test "Check check if points return to right part of world",
         %{region_polygons: region_polygons, moscow_coordinates: {msk_lon, msk_lat}} do
      assert {:ok, :"Europe"} == ContinentService.which_continent(msk_lon, msk_lat, region_polygons)
    end

    test "Return error if params invalid",
         %{region_polygons: region_polygons, moscow_coordinates: {msk_lon, msk_lat}, error_standard: error_standard} do
      assert error_standard == ContinentService.which_continent(180.1, msk_lat, region_polygons)
      assert error_standard == ContinentService.which_continent(-180.1, msk_lat, region_polygons)
      assert error_standard == ContinentService.which_continent(msk_lon, 90.1, region_polygons)
      assert error_standard == ContinentService.which_continent(msk_lon, -90.1, region_polygons)
    end


    test "Return right values for edge cases",
         %{region_polygons: region_polygons, moscow_coordinates: {msk_lon, msk_lat}} do
      assert {:ok, :"Europe"} == ContinentService.which_continent(180, msk_lat, region_polygons)
      assert {:ok, :"Europe"} == ContinentService.which_continent(-180, msk_lat, region_polygons)
      assert {:ok, :"Europe"} == ContinentService.which_continent(msk_lon, 90, region_polygons)
      assert {:ok, :"Europe"} == ContinentService.which_continent(msk_lon, -90, region_polygons)
    end
  end

  describe "#get_polygons" do
    setup do
      {:ok, result_standard: []}
    end

    test "Return right polygons array", %{result_standard: standard} do
      assert standard == ContinentService.get_polygons()
    end
  end
end
