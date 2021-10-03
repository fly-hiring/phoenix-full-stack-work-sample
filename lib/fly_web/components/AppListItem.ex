defmodule FlyWeb.Components.AppListItem do
  use Phoenix.Component
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers
  alias FlyWeb.Router.Helpers, as: Routes

  def render_regions(regions) when regions == [], do: nil
  def render(assigns) do
    ~H"""
      <div
        phx-click="select-app"
        phx-value-app_id={@app["id"]}
        class="
        w-full
        flex justify-between items-center
        rounded-md
        px-2 py-1
        mb-2
        cursor-pointer
        border
        border-gray-300
        hover:border-gray-400
        hover:shadow-lg
        ">
          <div class="w-2/6 flex flex-col">
            <div class="w-1/4">
            </div>
            <div class="w-3/4 flex flex-col">
              <div class="flex content-center">
                <div class="font-bold mr-1">
                  <%= @app["name"] %>
                </div>
                <div class="text-xs text-gray-400 flex items-center">
                  <div>
                    <%= @app |> Kernel.get_in(["vmSize", "name"]) %>
                  </div>
                  <div class="ml-1">
                    (
                    <%= @app |> Kernel.get_in(["vmSize", "memoryMb"]) %>MB
                    )
                  </div>
                </div>
              </div>
              <span>
              <a class="w-auto text-xs underline text-blue-400" href={"https://#{@app["hostname"]}"}>https://<%= @app["hostname"] %></a>
              </span>
            </div>
          </div>
          <div class="w-1/6">
            <%= for r <- @app["regions"] do %>
              <span class="
                text-xs text-green-600
                w-auto
                rounded-md
                px-1
                mr-1
                border border-green-400">
                <%= r["code"] |> String.upcase %>
              </span>
            <% end %>
            <%= for r <- @app["backupRegions"] do %>
              <span class="
                text-xs text-gray-400
                w-auto
                rounded-md
                px-1
                mr-1
                border border-gray-300">
                <%= r["code"] |> String.upcase %>
              </span>
            <% end %>
          </div>
          <div class="w-1/6 flex">
            <div class="flex items-center relative group">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
              </svg>
              <span class="text-gray-500 text-sm">
                <%= @app |> Kernel.get_in(["usage", "cpu"]) %>%
              </span>
              <div class="absolute -left-16 flex flex-col items-center hidden mb-3 group-hover:flex">
			          <span class="relative p-1 text-xs text-white bg-black">CPU usage</span>
    		      </div>
            </div>
            <div class="ml-2 flex items-center relative group">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
              </svg>
              <span class="text-gray-500 text-sm">
                <%= @app |> Kernel.get_in(["usage", "ram"]) %>%
              </span>
              <div class="absolute -left-16 flex flex-col items-center hidden mb-3 group-hover:flex">
			          <span class="relative p-1 text-xs text-white bg-black">RAM usage</span>
    		      </div>
            </div>
          </div>
          <div class="w-1/6 text-sm">
            <%= @app |> Kernel.get_in(["currentRelease", "createdAt"]) %>MB
          </div>
      </div>
    """
  end
  #def render(assigns) do
  #  ~H"""
  #    <div class="w-full bg-orange-200">
  #      <%= link to: Routes.app_show_path(@socket, :show, @app["name"])  do %>
  #        <div class="">
  #          <div class="">
  #            <p class="text-sm font-medium text-indigo-600 truncate">
  #              <%= @app["name"] %>
  #              <%= @app["regions"] |> Enum.map(&Map.get(&1, "code")) %>
  #              <%= @app["backupRegions"] |> Enum.map(&Map.get(&1, "code")) %>
  #            </p>
  #            <div class="ml-2 flex-shrink-0 flex">
  #              <p class={"px-2 inline-flex text-xs leading-5 font-semibold rounded-full #{status_bg_color(@app)} #{status_text_color(@app)}"}>
  #                <%= @app["status"] %>
  #              </p>
  #            </div>
  #          </div>
  #          <div class="mt-2 sm:flex sm:justify-between">
  #            <div class="sm:flex">
  #              <p class="flex items-center text-sm text-gray-500">
  #                <!-- Heroicon name: solid/users -->
  #                <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
  #                  <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
  #                </svg>
  #                <%= @app["organization"]["slug"] %>
  #              </p>
  #            </div>
  #            <div class="mt-2 flex items-center text-sm text-gray-500 sm:mt-0">
  #              <p>
  #                Last deploy on
  #                <time datetime={@app["currentRelease"]["createdAt"]}><%= @app["currentRelease"]["createdAt"] %></time>
  #              </p>
  #            </div>
  #          </div>
  #        </div>
  #      <% end %>
  #    </div>
  #  """
  #end

  def status_bg_color(app) do
    case app["status"] do
      "running" -> "bg-green-100"
      "dead" -> "bg-red-100"
      _ -> "bg-yellow-100"
    end
  end
  def status_text_color(app) do
    case app["status"] do
      "running" -> "text-green-800"
      "dead" -> "text-red-800"
      _ -> "text-yellow-800"
    end
  end
end
