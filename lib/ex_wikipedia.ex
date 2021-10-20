defmodule ExWikipedia do
  @moduledoc """
  `ExWikipedia` is an Elixir wrapper for the Wikipedia [API](https://en.wikipedia.org/w/api.php).
  """

  @callback fetch(input :: integer(), opts :: keyword()) :: {:ok, map()} | {:error, any()}

  def client do
    Application.fetch_env!(:ex_wikipedia, :http_client)
  end
end
