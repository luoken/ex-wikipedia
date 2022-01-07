defmodule ExWikipedia.Page.PageTest do
  use ExWikipedia.FileCase
  alias ExWikipedia.Page.Page

  import Mox
  setup :verify_on_exit!

  describe "fetch/2" do
    @tag contents: "54173.json"
    test ":ok when able to parse response", %{contents: contents} do
      client =
        HTTPClientMock
        |> expect(:get, fn _, _, _ ->
          {:ok,
           %{
             body: contents,
             status_code: 200
           }}
        end)

      assert {:ok,
              %Page{
                page_id: 54_173,
                title: "Pulp Fiction",
                content: "Pulp Fiction is a 1994 American black comedycrime film" <> _,
                summary: "Pulp Fiction is a 1994 American black comedycrime film" <> _,
                url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
              }} = Page.fetch("12345", client: client)
    end

    @tag contents: "54173.json"
    test ":ok on string integer ids", %{contents: contents} do
      # decode the json then reencode it as a string to be passed into the response
      {:ok, encoded_contents} =
        Jason.decode!(contents)
        |> Jason.encode()

      client =
        HTTPClientMock
        |> expect(:get, fn _, _, _ ->
          {:ok,
           %{
             body: encoded_contents,
             status_code: 200
           }}
        end)

      assert {:ok,
              %Page{
                page_id: 54_173,
                title: "Pulp Fiction",
                content: "Pulp Fiction is a 1994 American black comedycrime film" <> _,
                summary: "Pulp Fiction is a 1994 American black comedycrime film" <> _,
                url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
              }} = Page.fetch("12345", client: client)
    end

    test ":ok when non 200 status code is returned" do
      client =
        HTTPClientMock
        |> expect(:get, fn _, _, _ ->
          {:ok, %{body: "redirected", status_code: 301}}
        end)

      assert {:ok, _} = Page.fetch(12_345, client: client)
    end

    test ":error when non integer id is supplied" do
      assert {:error, _} = Page.fetch("blah", [])
    end

    test ":error when non binary id is supplied" do
      assert {:error, _} = Page.fetch(%{})
    end
  end
end
