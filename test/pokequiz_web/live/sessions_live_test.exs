defmodule PokequizWeb.SessionsLiveTest do
  use PokequizWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pokequiz.QuizFixtures

  @create_attrs %{players: 42, game_master: true}
  @update_attrs %{players: 43, game_master: false}
  @invalid_attrs %{players: nil, game_master: false}

  defp create_sessions(_) do
    sessions = sessions_fixture()
    %{sessions: sessions}
  end

  describe "Index" do
    setup [:create_sessions]

    test "lists all quiz_sessions", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/quiz_sessions")

      assert html =~ "Listing Quiz sessions"
    end

    test "saves new sessions", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/quiz_sessions")

      assert index_live |> element("a", "New Sessions") |> render_click() =~
               "New Sessions"

      assert_patch(index_live, ~p"/quiz_sessions/new")

      assert index_live
             |> form("#sessions-form", sessions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sessions-form", sessions: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/quiz_sessions")

      html = render(index_live)
      assert html =~ "Sessions created successfully"
    end

    test "updates sessions in listing", %{conn: conn, sessions: sessions} do
      {:ok, index_live, _html} = live(conn, ~p"/quiz_sessions")

      assert index_live |> element("#quiz_sessions-#{sessions.id} a", "Edit") |> render_click() =~
               "Edit Sessions"

      assert_patch(index_live, ~p"/quiz_sessions/#{sessions}/edit")

      assert index_live
             |> form("#sessions-form", sessions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sessions-form", sessions: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/quiz_sessions")

      html = render(index_live)
      assert html =~ "Sessions updated successfully"
    end

    test "deletes sessions in listing", %{conn: conn, sessions: sessions} do
      {:ok, index_live, _html} = live(conn, ~p"/quiz_sessions")

      assert index_live |> element("#quiz_sessions-#{sessions.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#quiz_sessions-#{sessions.id}")
    end
  end

  describe "Show" do
    setup [:create_sessions]

    test "displays sessions", %{conn: conn, sessions: sessions} do
      {:ok, _show_live, html} = live(conn, ~p"/quiz_sessions/#{sessions}")

      assert html =~ "Show Sessions"
    end

    test "updates sessions within modal", %{conn: conn, sessions: sessions} do
      {:ok, show_live, _html} = live(conn, ~p"/quiz_sessions/#{sessions}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sessions"

      assert_patch(show_live, ~p"/quiz_sessions/#{sessions}/show/edit")

      assert show_live
             |> form("#sessions-form", sessions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sessions-form", sessions: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/quiz_sessions/#{sessions}")

      html = render(show_live)
      assert html =~ "Sessions updated successfully"
    end
  end
end
