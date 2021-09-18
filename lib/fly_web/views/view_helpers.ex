defmodule FlyWeb.ViewHelpers do
  @moduledoc """
  View Helpers used across the app.
  """
  use Phoenix.HTML
  alias FlyWeb.Router.Helpers, as: Routes

  def icon_tag(socket, name, opts \\ []) do
    classes = Keyword.get(opts, :class, "") <> " icon"

    content_tag(:svg, class: classes) do
      tag(:use, "xlink:href": Routes.static_path(socket, "/images/icons.svg#" <> name))
    end
  end
end
