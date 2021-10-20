defmodule ExWikipedia.FileCase do
  @moduledoc """
  This module will be used to bring in support files
  as fixtures when testing.
  """

  use ExUnit.CaseTemplate

  # Setup a pipeline for the context metadata
  setup [:append_file_contents]

  defp append_file_contents(%{contents: filename}) when is_binary(filename) do
    %{contents: get_file_contents(filename)}
  end

  defp append_file_contents(context), do: context

  @doc """
  Loads up a supporting file
  """
  def get_file_contents(filename) do
    "test/support/files/#{filename}"
    |> File.read!()
  end

  # IO.inspect("hello")
end
