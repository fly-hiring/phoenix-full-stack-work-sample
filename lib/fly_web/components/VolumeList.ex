defmodule FlyWeb.Components.VolumeList do
  use Phoenix.Component
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

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
          <div class="w-1/6">Size</div>
        </div>
        <div class="bg-white overflow-hidden mb-2 text-gray-500 italic">
          Display all Volumes here just like Apps, soon!
        </div>
      </div>
    """
  end
end
