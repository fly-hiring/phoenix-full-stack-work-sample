defmodule FlyWeb.Components.TabSelector do
  use Phoenix.Component
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

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
  def render(assigns) do
    ~H"""
    <div class="flex mb-3 mt-4 pl-1">
      <div class={tab_style(@selectedTab == "apps")}
        phx-click="select-tab"
        phx-value-tab="apps"
        >
        Apps
      </div>
      <div class={tab_style(@selectedTab == "volumes")}
        phx-click="select-tab"
        phx-value-tab="volumes"
        >
        Volumes
      </div>
    </div>
    """
  end
end
