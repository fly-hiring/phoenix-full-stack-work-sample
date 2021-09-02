defmodule Fly.ClientTest do
  use ExUnit.Case

  doctest Fly.Client

  alias Fly.Client
  alias Fly.Client.TemplateOptions

  # placeholder for config used to talk to a real server
  @confg []

  describe "create_template_deployment/2" do
    test "handles receiving an error" do
      {:error, reason} = Client.create_template_deployment(%{faker: "single_error"}, @confg)
      assert reason == "A single error happened!"

      {:error, reason} = Client.create_template_deployment(%{faker: "double_error"}, @confg)
      assert reason == "This error happened, This 2nd error happened!"
    end

    test "returns error message when input data invalid" do
      {:error, reason} = Client.create_template_deployment(%{faker: "invalid_input"}, @confg)

      assert reason ==
               "Variable $input of type CreateTemplateDeploymentInput! was provided invalid value for app_name (Field is not defined on CreateTemplateDeploymentInput), livebook_password (Field is not defined on CreateTemplateDeploymentInput), organization_id (Field is not defined on CreateTemplateDeploymentInput), region (Field is not defined on CreateTemplateDeploymentInput), organizationId (Expected value to not be null), template (Expected value to not be null)"
    end

    test "returns error when server validation failure encountered" do
      {:error, reason} = Client.create_template_deployment(%{faker: "name_taken"}, @confg)
      assert reason == "Validation failed: Name has already been taken"
    end

    test "returns error when server return doesn't match expected" do
      {:error, reason} = Client.create_template_deployment(%{faker: "unexpected_return"}, @confg)
      assert reason == "Failed to receive ID for created app"
    end

    test "handles successful response" do
      assert {:ok, "fake-generated-successful-id"} == Client.create_template_deployment(%{}, @confg)
    end
  end

  describe "fetch_template_options/2" do
    test "handles server response with invalid JSON" do
      {:error, error} = Client.fetch_template_options(%{faker: "404_html"}, @confg)
      assert error == "Error making API request"
    end

    test "handles unauthorized failures" do
      assert {:error, :unauthorized} = Client.fetch_template_options(%{faker: "unauthorized"}, @confg)
    end

    test "successfully parses organizations and default region" do
      {:ok, %TemplateOptions{} = data} = Client.fetch_template_options(%{}, @confg)

      assert data.organizations == [
               %{id: "demo_id", name: "Demo Sandbox"},
               %{id: "chucky_id", name: "Chucky Cheese"}
             ]

      assert data.request_region == "lax"
    end

    test "successfully parses regions" do
      {:ok, %TemplateOptions{} = data} = Client.fetch_template_options(%{}, @confg)

      assert data.regions == %{
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
    end

    test "successfully parses VM Sizes" do
      {:ok, %TemplateOptions{} = data} = Client.fetch_template_options(%{}, @confg)

      assert data.vm_sizes == [
               %{memory: [256, 1024, 2048], name: "shared-cpu-1x"},
               %{memory: [2048, 4096, 8192], name: "dedicated-cpu-1x"},
               %{memory: [4096, 8192, 16384], name: "dedicated-cpu-2x"},
               %{memory: [8192, 16384, 32768], name: "dedicated-cpu-4x"},
               %{memory: [16384, 32768, 65536], name: "dedicated-cpu-8x"}
             ]
    end
  end

  describe "get_template_deployment_status/2" do
    test "handles when ID not found" do
      assert {:error, reason} = Client.get_template_deployment_status("id_not_found", @confg)

      assert reason == "Could not find node with id 'id_not_found'"
    end

    test "handles an unknown error" do
      assert {:error, reason} = Client.get_template_deployment_status("unknown_error", @confg)
      assert reason == "An unknown error occured."
    end

    test "handles when returns it is pending" do
      assert {:ok, "pending"} == Client.get_template_deployment_status("fake-status-pending", @confg)
    end

    test "handles when returns it is running" do
      assert {:ok, "running"} == Client.get_template_deployment_status("fake-status-running", @confg)
    end

    test "successfully handles when completed" do
      assert {:ok, status} = Client.get_template_deployment_status("fake-id", @confg)
      assert status == "completed"
    end
  end

  describe "check_http_response/1" do
    test "treats a 200 as success" do
      assert :ready == Client.check_http_response("https://success.fly.dev")
    end

    test "treats a redirect as success" do
      assert :ready == Client.check_http_response("https://redirect.fly.dev")
    end

    test "treats 404 as not ready" do
      assert :not_ready == Client.check_http_response("https://404.fly.dev")
    end

    test "treats 400 as error" do
      assert {:error, reason} = Client.check_http_response("https://400.fly.dev")
      assert reason == "Received unexpected status code 400"
    end

    test "missing domain" do
      assert :not_ready == Client.check_http_response("https://missing_domain.fly.dev")
    end

    test "treats 500s as error" do
      assert {:error, reason} = Client.check_http_response("https://500.fly.dev")
      assert reason == "Received unexpected status code 500"
    end

    test "treats other errors as errors" do
      assert {:error, reason} = Client.check_http_response("https://unknown_error.fly.dev")
      assert reason == "Unexpected error: :other_error"
    end
  end
end
