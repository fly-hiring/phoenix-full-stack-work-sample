defmodule FlyWeb.Components do
  @moduledoc """
  Defines a set of web components for use in static and LiveView templates.
  """

  import Phoenix.LiveView, only: [assign: 3, assign_new: 3], warn: false
  import Phoenix.LiveView.Helpers
  # use Phoenix.HTML

  @doc """
  Display a non-dismissable alert message. Not related to flash messages.

      <.alert type={:info} msg="You look nice today"/>
      <.alert type={:success} msg="We found the cookies!"/>
      <.alert type={:warn} msg="Water levels are rising"/>
      <.alert type={:error} msg="The butterfly apocalypse is approaching"/>
  """
  defdelegate alert(assigns), to: FlyWeb.Components.Alert, as: :render

  @doc """
  Flash Alert display. For LiveView pages when flash message needs to be shown.

      <.flash_alert flash={@flash} type={:info} />
      <.flash_alert flash={@flash} type={:success} />
      <.flash_alert flash={@flash} type={:warn} />
      <.flash_alert flash={@flash} type={:error} />

  """
  defdelegate flash_alert(assigns), to: FlyWeb.Components.FlashAlert, as: :render

  @doc """
  Render an icon. Specify the icon by the name.
  """
  defdelegate icon(assigns), to: FlyWeb.Components.Icons, as: :render

  @doc """
  Render a loader graphic while an operation is pending.
  """
  def loader(assigns) do
    assigns =
      assigns
      |> assign_new(:size, fn -> "6px" end)
      |> assign_new(:color, fn -> "text-blue-600" end)
      |> assign_new(:overlay, fn -> false end)
      |> assign_new(:loading, fn -> false end)

    ~H"""
    <span class={"#{@color} #{@overlay && "overlay"} #{@loading && "loading"}"}>
      <span class="dots" style={"--dot-size: #{@size}"}>
          <span></span>
          <span></span>
      </span>
    </span>
    """
  end

  @doc """
  Render a label, input, optional hint text, field error messages, etc.

  Assigns with special meaning:

  - `:label` - Specify the label to use. Otherwise attempts to create a default
    label from the field name.
  - `:help` - Optional help text to display.
  - `:required` - Set to `true` to display the field as required with an "*".
  - `:using` - An atom that specifies the function used in the `Web.Components`
    module to use for rendering the input. By default, it uses `:text_field`.

  An other assigns passed through are used directly on the input. The input has
  a set of default classes applied including error classes. When a `:class`
  option is used it completely overrides the value.`
  """
  defdelegate field_group(assigns), to: FlyWeb.Components.FieldGroup, as: :render

  @doc """
  Return the label text to use for a form label. If an explicit value is given
  in `label_text`, that is used. If not provided, then the `field` value is used
  to derive a default value.

  ## Options

  - `:label` - An explicitly named label value
  - `:required` - Boolean value to specify if the field is required or not. If
    required, a "*" is appended to the label text.
  """
  @spec label_text(field :: atom(), opts :: Keyword.t()) ::
          {text :: String.t(), opts :: Keyword.t()}
  def label_text(field, opts \\ []) do
    {required, opts} = Keyword.pop(opts, :required, false)
    {label_text, opts} = Keyword.pop(opts, :label)
    label_text = label_text || Phoenix.HTML.Form.humanize(field)

    use_text =
      if required do
        label_text <> " *"
      else
        label_text
      end

    {use_text, opts}
  end

  @doc """
  Render a Phoenix Form Label. Applies a default set of Tailwind classes. Can be
  overriden with options. Any additional options are passed through to the
  label.

  ## Options

  - `:class` - Explicit overide classes to use.
  - `:added_classes` - Appended to the default set of classes used on the input.
  - `:label` - An explicitly named label value. Otherwise a default derived one
    will be used.
  - `:required` - Boolean value to specify if the field is required or not. If
    required, a "*" is appended to the label text.

  """
  def field_label(form, field, opts \\ []) do
    {text, opts} = label_text(field, opts)
    {classes, opts} = merge_classes("block text-sm font-medium text-gray-700", opts)

    Phoenix.HTML.Form.label(form, field, text, Keyword.merge(opts, class: classes))
  end

  @doc """
  Return the CSS class name to use for the given field type. Used specifically
  to help with styling on a FieldGroup.
  """
  @spec class_for_field_type(atom()) :: String.t()
  def class_for_field_type(:text_field), do: "form-text-field"
  def class_for_field_type(:select_field), do: "form-select-field"
  def class_for_field_type(:checkbox_field), do: "form-checkbox-field"
  def class_for_field_type(:email_field), do: "form-email-field"
  def class_for_field_type(:password_field), do: "form-password-field"
  def class_for_field_type(:textarea_field), do: "form-textarea-field"
  def class_for_field_type(_), do: "form-generic-field"

  @doc """
  Return a boolean value for if a field has an error or not.
  """
  def field_has_error?(form, field) do
    !!form.errors[field]
  end

  @doc """
  Return the CSS class to indicate that the field has an error. When no error is
  found, returns an empty string.
  """
  def field_error_class(form, field) do
    if field_has_error?(form, field) do
      "has-error"
    else
      ""
    end
  end

  def default_field_opts(opts, form, field) do
    opts = Keyword.put(opts, :phx_feedback_for, Phoenix.HTML.Form.input_name(form, field))

    if field_has_error?(form, field) do
      Keyword.put(opts, :aria_invalid, "true")
    else
      opts
    end
  end

  @doc """
  Text Field.  See `Phoenix.HTML.Form.text_input/3`.
  """
  def text_field(form, field, opts \\ []) do
    opts = default_field_opts(opts, form, field)
    Phoenix.HTML.Form.text_input(form, field, opts)
  end

  @doc """
  Update the opts to merge `:added_classes` into any existing `:class` values.
  Helpful for letting a component define a more minimal set of classes for
  appearance and then adding extra classes for more specific usage.

  ## Options

  - `:class` - String value with the classes to use on the HTML element. Base value of classes.
  - `:added_classes` - Optional addition classes to combine.

  ## Examples

      iex> merge_classes("default-class mt-4", [])
      {"default-class mt-4", []}

      iex> merge_classes("default-class mt-4", [class: "replacing"])
      {"replacing", []}

      iex> merge_classes("default-class mt-4", [added_classes: "text-gray-700"])
      {"default-class mt-4 text-gray-700", []}

      iex> merge_classes("default-class mt-4", [added_classes: "text-gray-700", class: "override"])
      {"override text-gray-700", []}

      iex> merge_classes("default-class mt-4", [added_classes: "text-gray-700", class: "override", other: "other"])
      {"override text-gray-700", [other: "other"]}

      iex> merge_classes("default-class mt-4", [added_classes: "text-gray-700", other: "other"])
      {"default-class mt-4 text-gray-700", [other: "other"]}

  """
  @spec merge_classes(default_class :: String.t(), opts :: Keyword.t()) ::
          {class :: String.t(), opts :: Keyword.t()}
  def merge_classes(default_class, opts) do
    {class, opts} = Keyword.pop(opts, :class, default_class)
    {extra, opts} = Keyword.pop(opts, :added_classes, nil)

    use_class =
      if extra do
        class <> " " <> extra
      else
        class
      end

    {use_class, opts}
  end

  @doc """
  Select Field.  See `Phoenix.HTML.Form.select/4`.

  ## Options

  - `:selected` - The value of the item that is selected.
  - `:options` - A list of option items for the select.

  ## Example

      <%= select_field(form, :size, options: ["Big": "big", "Medium": "medium"]) %>

      <%= select_field(form, :size, options: ["Big": "big", "Medium": "medium"], selected: "big") %>
  """
  def select_field(form, field, opts \\ []) do
    opts = default_field_opts(opts, form, field)
    {options_list, opts} = Keyword.pop(opts, :options, [])
    Phoenix.HTML.Form.select(form, field, options_list, opts)
  end

  @doc """
  Render a circle graphic for showing that a step in a process is in not done, the current step or complete.

  ## Attributes

  - `:title` - the title
  - `:subtitle` - the subtitle
  - `:position` - the position for the circle step in the process. Values are `:first`, `:middle`, `:last`.
  - `:check_state` - The state of the circle step. It is either `:complete`, `:current`, or `:future`.

  ## Example

  ```html
  <ol role="list" class="overflow-hidden">
    <.check_step_vertical
      title="Preparing"
      subtitle="Preparing to deploy."
      position={:first}
      check_state={:complete} />

    <.check_step_vertical
      title="Deploying"
      subtitle="App being deployed!"
      position={:middle}
      check_state={:current} />
  </ol>
  ```
"""
  defdelegate check_step_vertical(assigns),
    to: FlyWeb.Components.CheckStepVertical,
    as: :render

  @doc """
  Displays error notifications.

  ## Assigns

    * `:for` - The required `%Ecto.Changeset{}` or map with `:errors`.
    * `:field` - The required field to show errors on `:for`.
    * `:classes` - The optional classes to place on the element.

  ## Examples

      <.error for={@changeset} field={:email} />
      <.error for={@changeset} field={:email} class="errors" />
  """
  defdelegate error(assigns),
    to: FlyWeb.Components.Error,
    as: :render

  @doc """
  Displays help text.

  Accepts the `:text` assign for the help text to display
  and merges all other assigns as tag attributes.

  ## Examples

      <.help text="Oh no!" />
      <.help text="Oh no!" id="help" />
  """
  def help(%{text: nil} = assigns), do: ~H""
  def help(%{text: _text} = assigns) do
    ~H"""
    <div class="mt-2 text-sm text-gray-500" {assigns_to_attributes(assigns, [:text])}><%= @text %></div>
    """
  end
end
