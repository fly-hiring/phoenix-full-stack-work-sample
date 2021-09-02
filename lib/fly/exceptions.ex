defmodule Fly.LaunchTemplateError do
  @moduledoc """
  Exception raised when a launch template is missing.
  """
  defexception plug_status: 404, message: "Launch template not found"

  def exception(_opts) do
    %__MODULE__{}
  end
end

defimpl Plug.Exception, for: Fly.LaunchTemplateError do
  def status(_exception), do: 404

  def actions(_), do: []
end
