defmodule FlyWeb.Components.Alert do
  import Phoenix.LiveView, only: [assign: 3, assign_new: 3], warn: false
  import Phoenix.LiveView.Helpers

  def render(%{type: type, msg: _msg} = assigns) do
    assigns = assign(assigns, :alert_color, alert_color_for(type))

    ~H"""
    <div class={"rounded-md bg-#{@alert_color}-50 p-4"} role="alert">
      <div class="flex">
        <div class="flex-shrink-0">
          <.alert_icon type={@type} />
        </div>
        <div class="ml-3">
          <p class={"text-sm leading-5 font-medium text-#{@alert_color}-800"}>
            <%= @msg %>
          </p>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Return the SVG graphic that works as an alert icon for a flash message of the given type.
  """
  def alert_icon(%{type: :info} = assigns) do
    # Heroicon name: information-circle
    ~H"""
    <svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
    </svg>
    """
  end

  def alert_icon(%{type: :success} = assigns) do
    # Heroicon name: check-circle
    ~H"""
    <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
    </svg>
    """
  end

  def alert_icon(%{type: :warn} = assigns) do
    # Heroicon name: exclamation
    ~H"""
    <svg class="h-5 w-5 text-yellow-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
    </svg>
    """
  end

  def alert_icon(%{type: :error} = assigns) do
    # Heroicon name: x-circle
    ~H"""
    <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
    </svg>
    """
  end

  @doc """
  Return the color to used for the alert type.
  """
  @spec alert_color_for(:info | :success | :warn | :error) :: String.t()
  def alert_color_for(:info), do: "blue"
  def alert_color_for(:success), do: "green"
  def alert_color_for(:warn), do: "yellow"
  def alert_color_for(:error), do: "red"
end
