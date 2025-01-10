defmodule PokequizWeb.Plug.PutUserFromCookie do
  @moduledoc """
  Reads a user_details cookie and puts user_details into session
  """
  import Plug.Conn

  def init(_) do
    %{}
  end

  def call(conn, _opts) do
    conn = fetch_cookies(conn)

    cookie = conn.cookies["user_session"]

    user_details = case cookie do
      nil ->
          ?a..?z
          |> Enum.take_random(6)
          |> List.to_string()
      _ ->
        cookie
        
    end

    conn
    |> put_resp_cookie("user_session", user_details, same_site: "Lax")
    |> put_session(:user_cookie, user_details) # Makes it available in LiveView
    |> assign(:user_cookie, user_details) # Makes it available in traditional controllers etc
  end

end
