defmodule TestappWeb.VisitController do
  use TestappWeb, :controller

  @regurl ~r/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
  @regdomain ~r/(https?:\/\/)?(www\.)?(?<dmurl>.+\.\w+)(\/.*|\?.*)?$/

  def extractDomain(url) do
    case Regex.named_captures(@regdomain, url) do
      %{"dmurl" => domainUrl} -> {:ok, domainUrl}
      _ -> {:error, "Can't parse domain in url"}
    end
  end

  def matchUrl(url) do
    String.match?(url, @regurl)
  end

  defp getRangeFromRedis(from, to) do
    Redix.command(:redix, ["zrangebyscore", "data", from, to])
  end

  defp saveToRedis(urls) when is_list(urls) do
    key = DateTime.utc_now() |> DateTime.to_unix()
    cmds = Enum.map(urls, fn url -> ["zadd", "data", key, url] end)
    Redix.pipeline(:redix, [["multi"]] ++ cmds ++ [["persist", key], ["exec"]])
  end

  def visited_links(conn, params) do
    result =
      case params do
        %{"links" => list = [_ | _]} ->
          if Enum.all?(list, &matchUrl/1) do
            case saveToRedis(list) do
              {:ok, _} ->
                %{"status" => :ok}

              {:error, reason} ->
                %{
                  "status" => :error,
                  "reason" => "error while save in redis:#{Exception.message(reason)}"
                }
            end
          else
            %{"status" => :error, "reason" => "Not valid url in links"}
          end

        _ ->
          %{"status" => :error, "reason" => "Invalid JSON"}
      end

    json(conn, result)
  end

  def visited_domains(conn, %{"from" => from, "to" => to})
      when is_number(from) and is_number(to) do
    result =
      case getRangeFromRedis(from, to) do
        {:ok, list} ->
          domains = list |> Enum.map(&extractDomain/1) |> Enum.uniq()

          %{
            "domains" =>
              for {:ok, domain} <- domains do
                domain
              end,
            "status" => :ok
          }

        {:error, reason} ->
          %{
            "status" => :error,
            "reason" => Exception.message(reason)
          }
      end

    json(conn, result)
  end
end
