defmodule ExWikipedia.Parser do
  @moduledoc """
  Holds parser behaviours.
  """

  @callback parse(json :: map(), opts :: keyword()) :: {:ok, map()} | {:error, binary()}
end
