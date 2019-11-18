defmodule TestappWeb.UrlMatchingTest do
  use ExUnit.Case

  test "Match urls" do
    assert TestappWeb.VisitController.matchUrl("https://yandex.ru/?lol=test")
    assert TestappWeb.VisitController.matchUrl("funbox.ru")
    assert TestappWeb.VisitController.matchUrl("www.funbox.ru/sdfsdfd")
    assert TestappWeb.VisitController.matchUrl("https://youtu.be/-50NdPawLVY?t=13364")
    assert TestappWeb.VisitController.matchUrl("www.youtu.be/-50NdPawLVY?t=13364")
    assert TestappWeb.VisitController.matchUrl("http://youtube.com")
    assert TestappWeb.VisitController.matchUrl("https://www.youtu.be/-50NdPawLVY?t=13364")
    assert TestappWeb.VisitController.matchUrl("youtu.be/-50NdPawLVY?t=13364")
    assert TestappWeb.VisitController.matchUrl("https://hexdocs.pm/redix/readme.html#content")
    refute TestappWeb.VisitController.matchUrl("httpsqw://hexdocs.pm/redix/readme.html#content")
    refute TestappWeb.VisitController.matchUrl("https:///hexdocs.pm/redix/readme.html#content")
    refute TestappWeb.VisitController.matchUrl("https://youtu.be-50NdPawLVY?t=13364")
    refute TestappWeb.VisitController.matchUrl("https://he xdocs.pm/redix/rea asdfdsf sd dme.html#content")
    refute TestappWeb.VisitController.matchUrl("https:sd f sd//hexsdf ocs.sdf pm/red sf sdf /readme.html#content")
    refute TestappWeb.VisitController.matchUrl("http  s://h xdocs.pm/redix read   me.html#content")
  end

  test "Extract domains" do
    assert TestappWeb.VisitController.extractDomain("https://yandex.ru/?lol=test") == {:ok, "yandex.ru"}
    assert TestappWeb.VisitController.extractDomain("funbox.ru") == {:ok, "funbox.ru"}
    assert TestappWeb.VisitController.extractDomain("www.funbox.ru/sdfsdfd") == {:ok, "funbox.ru"}
    assert TestappWeb.VisitController.extractDomain("https://youtu.be/-50NdPawLVY?t=13364") == {:ok, "youtu.be"}
    assert TestappWeb.VisitController.extractDomain("www.youtu.be/-50NdPawLVY?t=13364") == {:ok, "youtu.be"}
    assert TestappWeb.VisitController.extractDomain("http://youtube.com") == {:ok, "youtube.com"}
    assert TestappWeb.VisitController.extractDomain("https://www.youtu.be/-50NdPawLVY?t=13364") == {:ok, "youtu.be"}
    assert TestappWeb.VisitController.extractDomain("youtu.be/-50NdPawLVY?t=13364") == {:ok, "youtu.be"}
    assert TestappWeb.VisitController.extractDomain("https://hexdocs.pm/redix/readme.html#content") == {:ok, "hexdocs.pm"}
    assert TestappWeb.VisitController.extractDomain("https://hexdocs/redix/readme.html#content") == {:error, "Can't parse domain in url"}
  end
end
