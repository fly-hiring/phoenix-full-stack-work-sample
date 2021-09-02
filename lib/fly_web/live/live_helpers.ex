defmodule FlyWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `FlyWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal FlyWeb.TemplateLive.FormComponent,
        id: @template.id || :new,
        action: @live_action,
        template: @template,
        return_to: Routes.template_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(FlyWeb.ModalComponent, modal_opts)
  end

  # Sets target to '_blank' and rel to 'nofollow' on external links
  def link_out(text, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:target, "_blank")
      |> Keyword.put_new(:rel, "nofollow noopener")

    Phoenix.HTML.Link.link(text, opts)
  end

  # url to sign in with proper return_to
  def sign_in_url(opts \\ []) do
    if Keyword.has_key?(opts, :return_to) do
      "https://web.fly.io/app/sign-in?return_to=#{URI.encode_www_form(opts[:return_to])}"
    else
      "https://web.fly.io/app/sign-in"
    end
  end

  # url to sign up with proper return to
  def sign_up_url(opts \\ []) do
    return_to = opts[:return_to] || ""
    "https://web.fly.io/app/sign-up?return_to=#{URI.encode_www_form(return_to)}"
  end

  # oauth url
  def oauth_url(opts \\ []) do
    provider = opts[:provider]
    return_to = opts[:return_to] || ""

    "https://web.fly.io/app/auth/#{provider}/?origin=#{URI.encode_www_form(return_to)}"
  end
end
