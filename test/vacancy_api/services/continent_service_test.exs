defmodule VacancyApi.ContinentServiceTest do
  use ExUnit.Case
  alias VacancyApi.ContinentService

  describe "#which_continent" do
    setup do
      region_polygons = ContinentService.get_polygons()
      {:ok, region_polygons: region_polygons}
    end

    test "Check check if points return to right part of world", %{region_polygons: region_polygons} do

    end
  end

  describe "#get_polygons" do
    setup do
      {:ok, result_standard: []}
    end

    test "Return right polygons array", %{reuslt_standard: standard} do
      assert standard == ContinentService.get_polygons()
    end
  end
end
