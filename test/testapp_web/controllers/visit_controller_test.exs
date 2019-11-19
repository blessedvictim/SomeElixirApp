defmodule TestappWeb.VisitControllerTest do
  use TestappWeb.ConnCase, async: false

  @start_time DateTime.utc_now() |> DateTime.to_unix()

  def redis_cleanup do
    Redix.command(:redix, ["flushall"])
  end

  setup_all do
    redis_cleanup()

    case Redix.command(:redix, ["ping"]) do
      {:ok, "PONG"} -> :ok
      _ -> raise "Redis seems to not connected!"
    end
  end

  setup do
    on_exit(&redis_cleanup/0)
  end

  test "Post invalid json", %{conn: conn} do
    response =
      conn
      |> post(Routes.visit_path(conn, :visited_links))
      |> json_response(200)

    assert response == %{"status" => "error", "reason" => "Invalid JSON"}
  end

  test "Post valid json(1 url)", %{conn: conn} do
    response =
      conn
      |> post(Routes.visit_path(conn, :visited_links, %{"links" => ["google.ru"]}))
      |> json_response(200)

    assert response == %{"status" => "ok"}
  end

  test "Post 1 invalid url", %{conn: conn} do
    response =
      conn
      |> post(Routes.visit_path(conn, :visited_links, %{"links" => ["https://yandexru/?lol=test"]}))
      |> json_response(200)

    assert response == %{"status" => "error", "reason" => "Not valid url in links"}
  end

  test "Post 1 url and get it", %{conn: conn} do
    response =
      conn
      |> post(Routes.visit_path(conn, :visited_links, %{"links" => ["https://yandex.ru/?lol=test"]}))
      |> json_response(200)

    assert response == %{"status" => "ok"}

    end_time = DateTime.utc_now() |> DateTime.to_unix()

    %{"from" => @start_time, "to" => end_time} |> IO.inspect

    response =
      conn
      |> get(Routes.visit_path(conn, :visited_domains, %{"from" => @start_time, "to" => end_time}))
      |> json_response(200)

    assert response == %{
             "domains" => ["yandex.ru"],
             "status" => "ok"
           }
  end

  test "Get urls", %{conn: conn} do
    response =
      conn
      |> post(
        Routes.visit_path(conn, :visited_links, %{
          "links" => [
            "https://yandex.ru/?lol=test",
            "funbox.ru",
            "www.funbox.ru/sdfsdfd",
            "https://www.youtube.com/watch?v=jcu581GBmPs&t=738s",
            "www.youtube.com/watch?v=jcu581GBmPs&t=738s",
            "http://youtube.com",
            "youtube.com/watch?v=jcu581GBmPs&t=738s",
            "https://hexdocs.pm/redix/readme.html#content"
          ]
        })
      )
      |> json_response(200)

    assert response == %{"status" => "ok"}

    end_time = DateTime.utc_now() |> DateTime.to_unix()

    response =
      conn
      |> get(
        Routes.visit_path(conn, :visited_domains, %{"from" => @start_time, "to" => end_time})
      )
      |> json_response(200)

    right_response_domains = ["yandex.ru", "funbox.ru", "youtube.com", "hexdocs.pm"]

    assert response["status"] == "ok" and
             Enum.all?(response["domains"], fn domain -> domain in right_response_domains end)
  end
end
