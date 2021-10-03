defmodule FlyWeb.Components.SideApp do
  use Phoenix.Component
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers
  alias FlyWeb.Router.Helpers, as: Routes

  def tab_style(isSelected) do
    highlight = case isSelected do
      true -> "text-green-500 border-b-2 border-green-400"
      _ -> ""
    end
    "mr-2
     px-2 py-1
     text-gray-500
     cursor-pointer
     #{highlight}"
  end
  def tab_selector(assigns) do
    ~H"""
    <div class="flex mb-3 mt-4 pl-1">
      <div class={tab_style(true)}
        >
        Overview
      </div>
      <div class={tab_style(false)}>
        Attached volumes
      </div>
      <div class={tab_style(false)}>
        Environment variables
      </div>
      <div class={tab_style(false)}>
        Logs
      </div>
    </div>
    """
  end
  def status_pill(status) do
    bg = case status do
      "running" -> "bg-green-500"
      _ -> "bg-red-500"
    end
    "
      text-sm
      h-auto
      p-0
      px-2
      flex
      items-center
      text-white
      rounded-lg
      #{bg}
    "
  end
  def header(assigns) do
    ~H"""
    <div class="flex w-full justify-between">
      <div class="flex">
        <div class="text-bold text-3xl mr-2">
          <%= @app["name"] %>
        </div>
        <div class={status_pill(@app["status"])}>
          <%= @app["status"] %>
        </div>
      </div>
      <div class="text-bold">
        <span
          class="cursor-pointer"
          phx-click="close-app">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </span>
      </div>
    </div>
    """
  end
  def render_section(assigns, value) when is_map(value) do
    ~H"""
      <div class="flex">
        <%= for field <- value do %>
          <%= render_section(assigns, field) %>
        <% end %>
      </div>
    """
  end
  def render_section(assigns, {key, value}) when is_map(value) do
    ~H"""
    <div class="mb-2">
      <span class="text-gray-400 font-bold text-sm"> <%= key %> </span>
      <div class="flex">
        <%= for field <- value do %>
          <%= render_section(assigns, field) %>
        <% end %>
      </div>
    </div>
    """
  end
  def render_section(assigns, {key, value}) when is_list(value) do
    ~H"""
    <div class="flex flex-col mb-2">
      <span class="text-gray-400 font-bold text-sm"> <%= key %> </span>
      <div class="w-full border-b border-gray-200"></div>
      <div class="flex flex-col">
        <%= for element <- value do %>
          <%= render_section(assigns, element) %>
        <% end %>
      </div>
    </div>
    """
  end
  def render_section(assigns, {key, value}) when is_binary(value) or is_number(value) do
    ~H"""
    <div class="flex mb-2 mr-2">
      <span class="font-bold mr-1"> <%= key %>: </span>
      <span class=""> <%= value %> </span>
    </div>
    """
  end
  def render(assigns) do
    ~H"""
      <div
        class="fixed top-0 left-0 w-full h-full flex justify-end bg-black bg-opacity-50">
        <div phx-click="close-app" class="absolute w-full h-full">
        </div>
        <div class="w-1/2 p-6 bg-white rounded-lg border shadow-3xl z-20">
          <%= header(assigns) %>
          <%= tab_selector(assigns) %>
          <div class="p-2 flex flex-col">
            <%= render_section(assigns, {"App IP", @app["appUrl"]}) %>
            <%= render_section(assigns, {"App Hostname", @app["hostname"]}) %>
            <%= render_section(assigns, {"Current Release", @app["currentRelease"]["createdAt"]}) %>
            <%= render_section(assigns, {"Regions", @app["regions"]}) %>
            <%= render_section(assigns, {"Backup Regions", @app["backupRegions"]}) %>
            <%= render_section(assigns, {"VM Information", @app["vmSize"]}) %>
            <%= render_section(assigns, {"Network", @app["ipAddresses"]["nodes"]}) %>
          </div>
        </div>
      </div>
    """
  end
end
