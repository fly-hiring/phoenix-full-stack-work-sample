defmodule Fly.Client.TemplateOptionsTest do
  use Fly.DataCase

  doctest Fly.Client.TemplateOptions

  alias Fly.Client.TemplateOptions

  describe "parse_vm_sizes/1" do
    test "converts to expected format" do
      data = [
        %{"memoryIncrementsMb" => [256, 1024, 2048], "name" => "shared-cpu-1x"},
        %{"memoryIncrementsMb" => [2048, 4096, 8192], "name" => "dedicated-cpu-1x"}
      ]

      results = TemplateOptions.parse_vm_sizes(data)
      assert length(results) == 2
      [shared, dedicated] = results
      assert shared.name == "shared-cpu-1x"
      assert shared.memory == [256, 1024, 2048]
      assert dedicated.name == "dedicated-cpu-1x"
      assert dedicated.memory == [2048, 4096, 8192]
    end
  end

  describe "vm_options/1" do
    test "return formatted for UI selection" do
      data = %TemplateOptions{
        vm_sizes: [
          %{name: "shared-cpu-1x", memory: [256, 1024]},
          %{name: "dedicated-cpu-1x", memory: [2048, 4096]}
        ]
      }

      results = TemplateOptions.vm_options(data)

      assert results == [
               {"shared-cpu-1x - 256 MB", "shared-cpu-1x@256"},
               {"shared-cpu-1x - 1 GB", "shared-cpu-1x@1024"},
               {"dedicated-cpu-1x - 2 GB", "dedicated-cpu-1x@2048"},
               {"dedicated-cpu-1x - 4 GB", "dedicated-cpu-1x@4096"}
             ]
    end
  end

  describe "region_options/1" do
    test "returns formatted data" do
      data = %TemplateOptions{
        regions: %{
          "ams" => "Amsterdam, Netherlands",
          "atl" => "Atlanta, Georgia (US)",
          "cdg" => "Paris, France",
          "dfw" => "Dallas, Texas (US)",
          "ewr" => "Secaucus, NJ (US)",
          "fra" => "Frankfurt, Germany",
          "hkg" => "Hong Kong",
          "iad" => "Ashburn, Virginia (US)",
          "lax" => "Los Angeles, California (US)",
          "lhr" => "London, United Kingdom",
          "maa" => "Chennai (Madras), India",
          "nrt" => "Tokyo, Japan",
          "ord" => "Chicago, Illinois (US)",
          "scl" => "Santiago, Chile",
          "sea" => "Seattle, Washington (US)",
          "sin" => "Singapore",
          "sjc" => "Sunnyvale, California (US)",
          "syd" => "Sydney, Australia",
          "yyz" => "Toronto, Canada"
        }
      }

      results = TemplateOptions.region_options(data)

      # They should be ordered alphabetically by the city name
      assert results == [
               {"Amsterdam, Netherlands", "ams"},
               {"Ashburn, Virginia (US)", "iad"},
               {"Atlanta, Georgia (US)", "atl"},
               {"Chennai (Madras), India", "maa"},
               {"Chicago, Illinois (US)", "ord"},
               {"Dallas, Texas (US)", "dfw"},
               {"Frankfurt, Germany", "fra"},
               {"Hong Kong", "hkg"},
               {"London, United Kingdom", "lhr"},
               {"Los Angeles, California (US)", "lax"},
               {"Paris, France", "cdg"},
               {"Santiago, Chile", "scl"},
               {"Seattle, Washington (US)", "sea"},
               {"Secaucus, NJ (US)", "ewr"},
               {"Singapore", "sin"},
               {"Sunnyvale, California (US)", "sjc"},
               {"Sydney, Australia", "syd"},
               {"Tokyo, Japan", "nrt"},
               {"Toronto, Canada", "yyz"}
             ]
    end
  end

  describe "transform/1" do
    test "errors pass through" do
      assert {:error, "Pass on by"} == TemplateOptions.transform({:error, "Pass on by"})
    end

    test "returns error when parsing fails" do
      {:error, reason} = TemplateOptions.transform({:ok, "unexpected"})
      assert reason == "Failed to parse TemplateOptions data"
    end

    test "returns parsed structure from valid data" do
      valid_data =
        {:ok,
         %{
           "organizations" => %{
             "nodes" => [
               %{
                 "id" => "demo_id",
                 "name" => "Demo Sandbox",
                 "slug" => "demo-sandbox",
                 "type" => "SHARED"
               },
               %{
                 "id" => "chucky_id",
                 "name" => "Chucky Cheese",
                 "slug" => "personal",
                 "type" => "PERSONAL"
               }
             ]
           },
           "platform" => %{
             "regions" => [
               %{"code" => "ord", "name" => "Chicago, Illinois (US)"},
               %{"code" => "yyz", "name" => "Toronto, Canada"}
             ],
             "requestRegion" => "lax",
             "vmSizes" => [
               %{"memoryIncrementsMb" => [256, 1024, 2048], "name" => "shared-cpu-1x"},
               %{
                 "memoryIncrementsMb" => [2048, 4096, 8192],
                 "name" => "dedicated-cpu-1x"
               }
             ]
           }
         }}

      {:ok, %TemplateOptions{} = parsed_data} = TemplateOptions.transform(valid_data)
      assert length(parsed_data.organizations) == 2
      assert parsed_data.personal_org_id == "chucky_id"
      assert is_map(parsed_data.regions)
      assert parsed_data.regions["ord"] == "Chicago, Illinois (US)"
      assert parsed_data.request_region == "lax"
      assert length(parsed_data.vm_sizes) == 2
    end

    test "sets personal_org_id to nil when none present" do
      valid_data =
        {:ok,
         %{
           "organizations" => %{
             "nodes" => [
               %{
                 "id" => "demo_id",
                 "name" => "Demo Sandbox",
                 "slug" => "demo-sandbox",
                 "type" => "SHARED"
               }
             ]
           },
           "platform" => %{
             "regions" => [],
             "requestRegion" => nil,
             "vmSizes" => []
           }
         }}

      {:ok, %TemplateOptions{} = parsed_data} = TemplateOptions.transform(valid_data)
      assert length(parsed_data.organizations) == 1
      assert parsed_data.personal_org_id == nil
    end
  end
end
