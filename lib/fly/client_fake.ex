defmodule Fly.ClientFake do
  @moduledoc """
  Implements stubded responses.
  """
  @behaviour Fly.ClientBehaviour

  @impl true
  # wrapped the arguments for other calling patterns
  def perform_query(query_string, %{input: %{faker: "single_error"}}, config, fun_name) do
    perform_query(query_string, %{faker: "single_error"}, config, fun_name)
  end

  def perform_query(query_string, %{input: %{faker: "double_error"}}, config, fun_name) do
    perform_query(query_string, %{faker: "double_error"}, config, fun_name)
  end

  def perform_query(_query_string, %{faker: "single_error"}, _config, _fun_name) do
    {:error,
     %Neuron.Response{
       body: %{
         "errors" => [
           %{
             "extensions" => %{"code" => "GRAPHQL_VALIDATION_FAILED"},
             "locations" => [%{"column" => 5, "line" => 3}],
             "message" => "A single error happened!"
           }
         ]
       },
       headers: [],
       status_code: 400
     }}
  end

  def perform_query(_query_string, %{faker: "double_error"}, _config, _fun_name) do
    {:error,
     %Neuron.Response{
       body: %{
         "errors" => [
           %{
             "extensions" => %{"code" => "GRAPHQL_VALIDATION_FAILED"},
             "locations" => [%{"column" => 5, "line" => 3}],
             "message" => "This error happened"
           },
           %{
             "extensions" => %{"code" => "GRAPHQL_VALIDATION_FAILED"},
             "locations" => [%{"column" => 5, "line" => 4}],
             "message" => "This 2nd error happened!"
           }
         ]
       },
       headers: [],
       status_code: 400
     }}
  end

  def perform_query(_query_string, %{faker: "404_html"}, _config, _fun_name) do
    {:error,
     %Neuron.JSONParseError{
       error: %Jason.DecodeError{data: "four-oh-four, maybe lost", position: 0, token: nil},
       response: %Neuron.Response{body: "four-oh-four, maybe lost", headers: [], status_code: 404}
     }}
  end

  def perform_query(_query_string, %{faker: "unauthorized"}, _config, _fun_name) do
    {:error,
     %Neuron.Response{
       body: %{
         "errors" => [
           %{
             "extensions" => %{"code" => "UNAUTHORIZED"},
             "message" => "Unauthorized"
           }
         ]
       },
       headers: [],
       status_code: 401
     }}
  end

  # fetch_template_options
  def perform_query(_query_string, _args, _config, :fetch_template_options) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
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
               %{"code" => "ams", "name" => "Amsterdam, Netherlands"},
               %{"code" => "atl", "name" => "Atlanta, Georgia (US)"},
               %{"code" => "cdg", "name" => "Paris, France"},
               %{"code" => "dfw", "name" => "Dallas, Texas (US)"},
               %{"code" => "ewr", "name" => "Secaucus, NJ (US)"},
               %{"code" => "fra", "name" => "Frankfurt, Germany"},
               %{"code" => "hkg", "name" => "Hong Kong"},
               %{"code" => "iad", "name" => "Ashburn, Virginia (US)"},
               %{"code" => "lax", "name" => "Los Angeles, California (US)"},
               %{"code" => "lhr", "name" => "London, United Kingdom"},
               %{"code" => "maa", "name" => "Chennai (Madras), India"},
               %{"code" => "nrt", "name" => "Tokyo, Japan"},
               %{"code" => "ord", "name" => "Chicago, Illinois (US)"},
               %{"code" => "scl", "name" => "Santiago, Chile"},
               %{"code" => "sea", "name" => "Seattle, Washington (US)"},
               %{"code" => "sin", "name" => "Singapore"},
               %{"code" => "sjc", "name" => "Sunnyvale, California (US)"},
               %{"code" => "syd", "name" => "Sydney, Australia"},
               %{"code" => "yyz", "name" => "Toronto, Canada"}
             ],
             "requestRegion" => "lax",
             "vmSizes" => [
               %{"memoryIncrementsMb" => [256, 1024, 2048], "name" => "shared-cpu-1x"},
               %{
                 "memoryIncrementsMb" => [2048, 4096, 8192],
                 "name" => "dedicated-cpu-1x"
               },
               %{
                 "memoryIncrementsMb" => [4096, 8192, 16384],
                 "name" => "dedicated-cpu-2x"
               },
               %{
                 "memoryIncrementsMb" => [8192, 16384, 32768],
                 "name" => "dedicated-cpu-4x"
               },
               %{
                 "memoryIncrementsMb" => [16384, 32768, 65536],
                 "name" => "dedicated-cpu-8x"
               }
             ]
           }
         }
       },
       headers: [],
       status_code: 200
     }}
  end

  # create_template_deployment
  def perform_query(_query_string, %{input: %{faker: "name_taken"}}, _config, :create_template_deployment) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{"createTemplateDeployment" => nil},
         "errors" => [
           %{
             "extensions" => %{"code" => "UNPROCESSABLE"},
             "locations" => [%{"column" => 3, "line" => 2}],
             "message" => "Validation failed: Name has already been taken",
             "path" => ["createTemplateDeployment"]
           }
         ]
       },
       headers: [],
       status_code: 200
     }}
  end

  def perform_query(
        _query_string,
        %{input: %{faker: "unexpected_return"}},
        _config,
        :create_template_deployment
      ) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{"createTemplateDeployment" => nil}
       },
       headers: [],
       status_code: 200
     }}
  end

  def perform_query(
        _query_string,
        %{input: %{faker: "invalid_input"}},
        _config,
        :create_template_deployment
      ) do
    {:ok,
     %Neuron.Response{
       body: %{
         "errors" => [
           %{
             "extensions" => %{
               "problems" => [
                 %{
                   "explanation" => "Field is not defined on CreateTemplateDeploymentInput",
                   "path" => ["app_name"]
                 },
                 %{
                   "explanation" => "Field is not defined on CreateTemplateDeploymentInput",
                   "path" => ["livebook_password"]
                 },
                 %{
                   "explanation" => "Field is not defined on CreateTemplateDeploymentInput",
                   "path" => ["organization_id"]
                 },
                 %{
                   "explanation" => "Field is not defined on CreateTemplateDeploymentInput",
                   "path" => ["region"]
                 },
                 %{
                   "explanation" => "Expected value to not be null",
                   "path" => ["organizationId"]
                 },
                 %{"explanation" => "Expected value to not be null", "path" => ["template"]}
               ],
               "value" => %{
                 "app_name" => "asdf",
                 "livebook_password" => "7p43esr7h7p3xu5ndlojrlsauiv3dekj",
                 "organization_id" => "fake_org_id",
                 "region" => "lax"
               }
             },
             "locations" => [%{"column" => 10, "line" => 1}],
             "message" =>
               "Variable $input of type CreateTemplateDeploymentInput! was provided invalid value for app_name (Field is not defined on CreateTemplateDeploymentInput), livebook_password (Field is not defined on CreateTemplateDeploymentInput), organization_id (Field is not defined on CreateTemplateDeploymentInput), region (Field is not defined on CreateTemplateDeploymentInput), organizationId (Expected value to not be null), template (Expected value to not be null)"
           }
         ]
       },
       headers: [],
       status_code: 200
     }}
  end

  # successful call
  def perform_query(_query_string, _args, _config, :create_template_deployment) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
           "createTemplateDeployment" => %{
             "templateDeployment" => %{
               "id" => "fake-generated-successful-id"
             }
           }
         }
       },
       headers: [],
       status_code: 200
     }}
  end

  # get_template_deployment_status calls
  def perform_query(
        _query_string,
        %{id: "id_not_found"},
        _config,
        :get_template_deployment_status
      ) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{"node" => nil},
         "errors" => [
           %{
             "extensions" => %{"code" => "NOT_FOUND"},
             "locations" => [%{"column" => 3, "line" => 2}],
             "message" => "Could not find node with id 'id_not_found'",
             "path" => ["node"]
           }
         ]
       },
       status_code: 200
     }}
  end

  def perform_query(_query_string, %{id: "unknown_error"}, _config, :get_template_deployment_status) do
    {:error,
     %Neuron.Response{
       body: %{
         "data" => %{},
         "errors" => [
           %{
             "extensions" => %{"code" => "SERVER_ERROR"},
             "message" => "An unknown error occured."
           }
         ]
       },
       headers: [],
       status_code: 500
     }}
  end

  def perform_query(_query_string, %{id: "fake-status-pending"}, _config, :get_template_deployment_status) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
           "node" => %{
             "apps" => %{"nodes" => []},
             "id" => "fake-deployment-id",
             "status" => "pending"
           }
         }
       },
       headers: [],
       status_code: 200
     }}
  end

  def perform_query(_query_string, %{id: "fake-status-running"}, _config, :get_template_deployment_status) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
           "node" => %{
             "apps" => %{"nodes" => []},
             "id" => "fake-deployment-id",
             "status" => "running"
           }
         }
       },
       headers: [],
       status_code: 200
     }}
  end

  def perform_query(_query_string, _args, _config, :get_template_deployment_status) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
           "node" => %{
             "apps" => %{
               "nodes" => [
                 %{
                   "allocations" => [
                     %{
                       "id" => "0577b5bb-45dd-4949-5be5-f18d16413308",
                       "status" => "running"
                     }
                   ],
                   "id" => "fake-app-name",
                   "name" => "fake-app-name",
                   "state" => "DEPLOYED"
                 }
               ]
             },
             "id" => "fake-generated-successful-id",
             "status" => "completed"
           }
         }
       },
       headers: [],
       status_code: 200
     }}
  end

  # HTTP Status Check for new site
  @impl true
  def perform_http_get("https://missing_domain.fly.dev", _opts) do
    {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
  end

  def perform_http_get("https://404.fly.dev", _opts) do
    {:ok,
     %HTTPoison.Response{
       body:
         "<!DOCTYPE html>\n<html lang=en>\n  <meta charset=utf-8>\n  <meta name=viewport content=\"initial-scale=1, minimum-scale=1, width=device-width\">\n  <title>Error 404 (Not Found)!!1</title>\n  <style>\n    *{margin:0;padding:0}html,code{font:15px/22px arial,sans-serif}html{background:#fff;color:#222;padding:15px}body{margin:7% auto 0;max-width:390px;min-height:180px;padding:30px 0 15px}* > body{background:url(//www.google.com/images/errors/robot.png) 100% 5px no-repeat;padding-right:205px}p{margin:11px 0 22px;overflow:hidden}ins{color:#777;text-decoration:none}a img{border:0}@media screen and (max-width:772px){body{background:none;margin-top:0;max-width:none;padding-right:0}}#logo{background:url(//www.google.com/images/branding/googlelogo/1x/googlelogo_color_150x54dp.png) no-repeat;margin-left:-5px}@media only screen and (min-resolution:192dpi){#logo{background:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) no-repeat 0% 0%/100% 100%;-moz-border-image:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) 0}}@media only screen and (-webkit-min-device-pixel-ratio:2){#logo{background:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) no-repeat;-webkit-background-size:100% 100%}}#logo{display:inline-block;height:54px;width:150px}\n  </style>\n  <a href=//www.google.com/><span id=logo aria-label=Google></span></a>\n  <p><b>404.</b> <ins>That’s an error.</ins>\n  <p>The requested URL <code>/invalid</code> was not found on this server.  <ins>That’s all we know.</ins>\n",
       headers: [],
       request: %HTTPoison.Request{
         body: "",
         headers: [],
         method: :get,
         options: [],
         params: %{},
         url: "http://google.com/invalid"
       },
       request_url: "http://google.com/invalid",
       status_code: 404
     }}
  end

  def perform_http_get("https://400.fly.dev", _opts) do
    {:ok,
     %HTTPoison.Response{
       body:
         "<!DOCTYPE html>\n<html lang=en>\n  <meta charset=utf-8>\n  <meta name=viewport content=\"initial-scale=1, minimum-scale=1, width=device-width\">\n  <title>Error 400</title>\n  <style>\n    *{margin:0;padding:0}html,code{font:15px/22px arial,sans-serif}html{background:#fff;color:#222;padding:15px}body{margin:7% auto 0;max-width:390px;min-height:180px;padding:30px 0 15px}* > body{background:url(//www.google.com/images/errors/robot.png) 100% 5px no-repeat;padding-right:205px}p{margin:11px 0 22px;overflow:hidden}ins{color:#777;text-decoration:none}a img{border:0}@media screen and (max-width:772px){body{background:none;margin-top:0;max-width:none;padding-right:0}}#logo{background:url(//www.google.com/images/branding/googlelogo/1x/googlelogo_color_150x54dp.png) no-repeat;margin-left:-5px}@media only screen and (min-resolution:192dpi){#logo{background:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) no-repeat 0% 0%/100% 100%;-moz-border-image:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) 0}}@media only screen and (-webkit-min-device-pixel-ratio:2){#logo{background:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) no-repeat;-webkit-background-size:100% 100%}}#logo{display:inline-block;height:54px;width:150px}\n  </style>\n  <a href=//www.google.com/><span id=logo aria-label=Google></span></a>\n  <p><b>404.</b> <ins>That’s an error.</ins>\n  <p>The requested URL <code>/invalid</code> was not found on this server.  <ins>That’s all we know.</ins>\n",
       headers: [],
       request: %HTTPoison.Request{
         body: "",
         headers: [],
         method: :get,
         options: [],
         params: %{},
         url: "http://google.com/invalid"
       },
       request_url: "http://google.com/invalid",
       status_code: 400
     }}
  end

  def perform_http_get("https://500.fly.dev", _opts) do
    {:ok,
     %HTTPoison.Response{
       body:
         "Server Error\n",
       headers: [],
       request: %HTTPoison.Request{
         body: "",
         headers: [],
         method: :get,
         options: [],
         params: %{},
         url: ""
       },
       request_url: "",
       status_code: 500
     }}
  end

  def perform_http_get("https://redirect.fly.dev", _opts) do
    {:ok,
     %HTTPoison.Response{
       body:
         "<HTML><HEAD><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n<TITLE>301 Moved</TITLE></HEAD><BODY>\n<H1>301 Moved</H1>\nThe document has moved\n<A HREF=\"http://www.google.com/\">here</A>.\r\n</BODY></HTML>\r\n",
       headers: [],
       request: %HTTPoison.Request{
         body: "",
         headers: [],
         method: :get,
         options: [],
         params: %{},
         url: "http://google.com"
       },
       request_url: "http://google.com",
       status_code: 301
     }}
  end

  def perform_http_get("https://unknown_error.fly.dev", _opts) do
    {:error, %HTTPoison.Error{id: nil, reason: :other_error}}
  end

  def perform_http_get(_url, _opts) do
    {:ok,
     %HTTPoison.Response{
       body: "<!doctype html><html>page contents</html>",
       headers: [],
       request: %HTTPoison.Request{
         body: "",
         headers: [],
         method: :get,
         options: [],
         params: %{},
         url: "http://www.google.com"
       },
       request_url: "http://www.google.com",
       status_code: 200
     }}
  end
end
