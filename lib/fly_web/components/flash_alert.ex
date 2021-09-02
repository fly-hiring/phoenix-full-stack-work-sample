defmodule FlyWeb.Components.FlashAlert do
  import Phoenix.LiveView, only: [assign: 3, assign_new: 3], warn: false
  import Phoenix.LiveView.Helpers
  alias FlyWeb.Components.Alert

  def render(%{flash: flash, type: type} = assigns) do
    assigns
    |> assign(:flash_msg, live_flash(flash, type))
    |> render_alert()
  end

  defp render_alert(%{flash_msg: nil} = assigns), do: ~H""
  defp render_alert(%{flash_msg: _, type: type} = assigns) do
    assigns =
      assigns
      |> assign(:type_string, Atom.to_string(type))
      |> assign(:alert_color, Alert.alert_color_for(type))

    ~H"""
    <div class={"absolute bottom-6 left-1/2 transform -translate-x-1/2 max-w-4xl mx-auto rounded-xl bg-#{@alert_color}-600 px-5 py-4 text-sm font-medium text-white shadow-lg"} role="alert">
      <div class="flex">
        <div class="flex-shrink-0">
          <Alert.alert_icon type={@type} />
        </div>
        <div class="ml-3">
          <p class="text-white">
            <%= live_flash(@flash, @type) %>
          </p>
        </div>
        <div class="ml-auto pl-3">
          <div class="-mx-1.5 -my-1.5">
            <button phx-click="lv:clear-flash" phx-value-key={@type_string} class="inline-flex rounded-md p-1.5 bg-black bg-opacity-0 hover:bg-opacity-10 transition-colors focus:outline-none text-opacity-50 hover:text-opacity-100 transition ease-in-out duration-150" aria-label="Dismiss">
              <!-- Heroicon name: x -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
