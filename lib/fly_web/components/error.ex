defmodule FlyWeb.Components.Error do
  @moduledoc """
  Helper for displaying errors
  """
  import Phoenix.LiveView, only: [assign: 3, assign_new: 3], warn: false
  import Phoenix.LiveView.Helpers
  import FlyWeb.ErrorHelpers

  @default_classes "mt-2 text-sm text-red-600 invalid-feedback"

  @doc """
  Render the error display. Takes a few different input options.

  Takes a Form or an `Ecto.Changeset` and the field to display errors for.

  ## Options

  - `:classes` - Classes to use for styling the error text.

  """
  def render(%{for: nil, field: _field} = assigns), do: ~H""

  def render(%{for: %Ecto.Changeset{} = changeset, field: field} = assigns) do
    assigns =
      assigns
      |> assign(:error, changeset[field])
      |> assign(:classes, assigns[:classes] || @default_classes)

    ~H"""
    <%= if @error do %>
      <p class={@classes} phx-feedback-for={Phoenix.HTML.Form.input_id(@changeset, @field)}>
        <%= translate_error(@error) %>
      </p>
    <% end %>
    """
  end

  def render(%{for: _form, field: _field} = assigns) do
    assigns = assign(assigns, :classes, assigns[:classes] || @default_classes)

    ~H"""
    <%= for error <- Keyword.get_values(@for.errors, @field) do %>
      <span class={@classes} phx-feedback-for={Phoenix.HTML.Form.input_id(@for, @field)}>
        <%= translate_error(error) %>
      </span>
    <% end %>
    """
  end
end
