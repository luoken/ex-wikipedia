defmodule ExWikipedia.Structs.WikipediaPage do
  @moduledoc """
  Describes a Wikipedia page.
  """

  @typedoc """
  - `:external_links` - List of fully qualified URLs to associate with the Wikipedia page.
  - `:categories` - List of categories the Wikipedia page belongs to
  - `:content` - String text found on Wikipedia page
  - `:images` - List of relative URLs pointing to images found on the Wikipedia page
  - `:page_id` - Wikipedia page id represented as an integer
  - `:revision_id` - Wikipedia page revision id represented as an integer
  - `:summary` - String text representing Wikipedia page's summary
  - `:title` - String title of the Wikipedia page
  - `:url` - Fully qualified URL belonging to Wikipedia page
  """

  @type t :: %__MODULE__{
          external_links: [String.t()],
          categories: [String.t()],
          content: binary(),
          images: [String.t()],
          page_id: integer(),
          revision_id: integer(),
          summary: binary(),
          title: binary(),
          url: binary()
        }

  @enforce_keys [:content, :page_id, :summary, :title, :url]

  defstruct external_links: [],
            categories: [],
            content: "",
            images: [],
            page_id: nil,
            revision_id: nil,
            summary: "",
            title: "",
            url: ""
end
