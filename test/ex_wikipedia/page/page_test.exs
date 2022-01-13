defmodule ExWikipedia.Page.PageTest do
  use ExWikipedia.FileCase
  alias ExWikipedia.Page

  import Mox
  setup :verify_on_exit!

  describe "fetch/2" do
    @tag contents: "54173.json"
    test ":ok when able to parse response", %{contents: contents} do
      http_client =
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
              }} = Page.fetch("12345", http_client: http_client)
    end

    @tag contents: "54173.json"
    test ":ok when specifying keys used by different HTTP clients", %{contents: contents} do
      http_client =
        HTTPClientMock
        |> expect(:get, fn _, _, _ ->
          {:ok,
           %{
             payload: contents,
             status: 200
           }}
        end)

      assert {:ok, %Page{}} =
               Page.fetch("12345",
                 http_client: http_client,
                 body_key: :payload,
                 status_key: :status
               )
    end

    @tag contents: "54173.json"
    test ":ok on string integer ids", %{contents: contents} do
      http_client =
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
              }} = Page.fetch("12345", http_client: http_client)
    end

    test ":error when non 200 status code is returned" do
      http_client =
        HTTPClientMock
        |> expect(:get, fn _, _, _ ->
          {:ok, %{body: "redirected", status_code: 301}}
        end)

      assert {:error, _} = Page.fetch(12_345, http_client: http_client)
    end

    test ":error when non integer id is supplied" do
      assert {:error, _} = Page.fetch("blah", [])
    end

    test ":error when non binary id is supplied" do
      assert {:error, _} = Page.fetch(%{})
    end

    test ":error when unable to find body key" do
      http_client =
        HTTPClientMock
        |> expect(:get, fn _, _, _ ->
          {:ok,
           %{
             body: "contents",
             status_code: 200
           }}
        end)

      assert {:error, _} = Page.fetch(12_345, http_client: http_client, body_key: :payload)
    end
  end
end
