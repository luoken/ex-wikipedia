defmodule ExWikipedia.FetchWikipediaIdTest do
  use ExUnit.Case
  alias ExWikipedia.FetchWikipediaId

  import Mox
  setup :verify_on_exit!

  describe "fetch/2" do
    test ":ok when able to parse response" do
      client =
        HTTPClientMock
        |> expect(:get, fn _, _ ->
          {:ok,
           %FetchWikipediaId{
             page_id: 12345,
             title: "pulp fiction",
             content:
               "1994 film directed by Quentin Tarantino This article is about the film. For other uses, see  Pulp fiction .",
             summary: "1994 film directed by Quentin Tarantino",
             url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
           }}
        end)

      assert {:ok,
              %FetchWikipediaId{
                page_id: 12345,
                title: "pulp fiction",
                content:
                  "1994 film directed by Quentin Tarantino This article is about the film. For other uses, see  Pulp fiction .",
                summary: "1994 film directed by Quentin Tarantino",
                url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
              }} = FetchWikipediaId.fetch(12345, client: client)
    end

    test ":error when non 200 status code is returned" do
      client =
        HTTPClientMock
        |> expect(:get, fn _, _ ->
          {:ok, %HTTPoison.Response{body: "redirected", status_code: 301}}
        end)

      assert {:error, _} = FetchWikipediaId.fetch(12345, client: client)
    end

    test ":error when non integer id is supplied" do
      assert {:error, _} = FetchWikipediaId.fetch("blah", [])
    end

    test ":ok on string integer ids" do
      client =
        HTTPClientMock
        |> expect(:get, fn _, _ ->
          {:ok,
           %FetchWikipediaId{
             page_id: 12345,
             title: "pulp fiction",
             content:
               "1994 film directed by Quentin Tarantino This article is about the film. For other uses, see  Pulp fiction .",
             summary: "1994 film directed by Quentin Tarantino",
             url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
           }}
        end)

      assert {:ok,
              %FetchWikipediaId{
                page_id: 12345,
                title: "pulp fiction",
                content:
                  "1994 film directed by Quentin Tarantino This article is about the film. For other uses, see  Pulp fiction .",
                summary: "1994 film directed by Quentin Tarantino",
                url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
              }} = FetchWikipediaId.fetch("12345", client: client)
    end
  end
end
