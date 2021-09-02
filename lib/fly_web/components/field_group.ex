defmodule FlyWeb.Components.FieldGroup do
  @moduledoc false
  # See `FlyWeb.Components.field_group/3` for usage documentation
  import Phoenix.LiveView, only: [assign: 3, assign_new: 3], warn: false
  import Phoenix.LiveView.Helpers
  import FlyWeb.Components

  def render(%{form: form, field: field} = assigns) do
    # Inspired by solution found here:
    # http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/
    # Render the "wrappers" around the desired field type. That is the content
    # of the block.
    # include aria-describedby as a generated name
    help_id = "#{field}-description"
    type = assigns[:type] || :text_field

    assigns =
      assigns
      |> assign(:type, type)
      |> assign(:help, assigns[:help] || nil)
      |> assign(:class, "#{class_for_field_type(type)} #{field_error_class(form, field)}")
      # Gets a default type for the field type on the form
      |> assign(:label_opts, Map.take(assigns, [:label, :required]))
      |> assign(:input_opts, Map.merge(%{:"aria-describedby" => help_id}, assigns))

    ~H"""
    <div class={@class}>
      <%= field_label(@form, @field, @label_opts) %>
      <%= render_input(@type, @form, @field, @input_opts) %>
      <.error for={@form} field={@field} />
      <.help text={@help} id={@help_id} />
    </div>
    """
  end

  # Expects a function named for the type to be defined on the Components
  # module.
  defp render_input(type, form, field, input_opts) do
    apply(FlyWeb.Components, type, [form, field, input_opts])
  end
end
