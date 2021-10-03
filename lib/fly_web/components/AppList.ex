defmodule FlyWeb.Components.AppList do
  use Phoenix.Component
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers
  alias FlyWeb.Router.Helpers, as: Routes
  alias FlyWeb.Components.AppListItem

  def render(assigns) do
    ~H"""
      <div class="bg-white rounded-lg shadow px-5 py-6">
        <div class="
          w-full
          flex justify-between
          bbg-blue-200
          text-gray-400
          text-sm
          mb-4
          ">
          <div class="w-2/6">Name</div>
          <div class="w-1/6">Regions</div>
          <div class="w-1/6">Load</div>
          <div class="w-1/6">Last deploy</div>
        </div>
        <div class="bg-white overflow-hidden mb-2">
          <%= for app <- @apps do %>
            <AppListItem.render app={app} socket={@socket} />
          <% end %>
        </div>
      </div>
    """
  end
end
