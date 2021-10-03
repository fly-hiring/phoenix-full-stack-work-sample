defmodule FlyWeb.Components.HeaderLinks do
  use Phoenix.Component
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

  def link_style(isActive) do
    color = case isActive do
      true -> "text-purple-500"
      _ -> "text-gray-500"
    end
    "ml-4
    text-sm
    font-medium
    #{color}
    "
  end
  def render(assigns) do
    ~H"""
    <nav class="flex" aria-label="Link">
      <ol role="list" class="flex items-center space-x-4">
        <%= for {{label, href,regex}, idx} <- Enum.with_index(@links) do %>
          <li>
            <div class="flex items-center">
              <%= live_patch label, to: href, class: link_style(Regex.match?(regex, @currentUrl)) %>
            </div>
          </li>
        <% end %>
      </ol>
    </nav>
    """
  end
end
