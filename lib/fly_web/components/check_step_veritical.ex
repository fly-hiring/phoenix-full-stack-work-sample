defmodule FlyWeb.Components.CheckStepVertical do
  @moduledoc """
  A component that renders a Tailwind vertical circle check for showing progress
  in an overall flow.

  https://tailwindui.com/components/application-ui/navigation/steps#component-fe94b9131ea11970b4653b2f0d0c83cd

  ## Options

  - `:position` - the position for the circle step in the process. Values are `:first`, `:middle`, `:last`.
  - `:check_state` - The state of the circle step. It is either `:complete`, `:current`, or `:future`.

  """
  import Phoenix.LiveView, only: [assign: 3, assign_new: 3], warn: false
  import Phoenix.LiveView.Helpers

  def render(assigns) do
    line_color =
      case assigns.check_state do
        :complete -> "bg-indigo-800"
        _other -> "bg-gray-300"
      end

    assigns = assign(assigns, :line_color, line_color)

    ~H"""
    <li class="relative pb-10">
      <%= if @position in [:first, :middle] do %>
        <div class={"-ml-px absolute mt-0.5 top-4 left-4 w-0.5 h-full #{@line_color}"} aria-hidden="true"></div>
      <% end %>
      <!-- Complete Step -->
      <div class="relative flex items-start group">
        <span class="h-9 flex items-center">
          <span class={"relative z-10 w-8 h-8 flex items-center justify-center #{@line_color} rounded-full"}>
            <.check_icon state={@check_state} />
          </span>
        </span>
        <span class="ml-4 min-w-0 flex flex-col">
          <span class="text-xs text-white font-semibold tracking-wide uppercase"><%= @title %></span>
          <span class="text-sm text-white opacity-90"><%= @subtitle %></span>
        </span>
      </div>
    </li>
    """
  end

  defp check_icon(%{state: :complete} = assigns) do
    ~H"""
    <!-- Heroicon name: solid/check -->
    <svg class="w-5 h-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
      <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
    </svg>
    """
  end

  defp check_icon(%{state: :current} = assigns) do
    ~H"""
    <span class="relative z-10 w-8 h-8 flex items-center justify-center bg-white border-2 border-indigo-600 rounded-full">
      <span class="h-2.5 w-2.5 bg-indigo-600 rounded-full"></span>
    </span>
    """
  end

  defp check_icon(%{state: :future} = assigns) do
    ~H"""
    <span class="relative z-10 w-8 h-8 flex items-center justify-center bg-white border-2 border-gray-300 rounded-full group-hover:border-gray-400 border-opacity-80">
      <span class="h-2.5 w-2.5 bg-transparent rounded-full group-hover:bg-gray-300"></span>
    </span>
    """
  end

  defp check_icon(assigns) do
    raise ArgumentError, "invalid check_icon state #{inspect(assigns)}"
  end
end
