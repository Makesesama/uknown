defmodule Pokequiz.QuizTest do
  use Pokequiz.DataCase

  alias Pokequiz.Quiz

  describe "sessions" do
    alias Pokequiz.Quiz.Session

    import Pokequiz.QuizFixtures

    @invalid_attrs %{session_type: nil, players: nil, game_master: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Quiz.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Quiz.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{session_type: "some session_type", players: 42, game_master: true}

      assert {:ok, %Session{} = session} = Quiz.create_session(valid_attrs)
      assert session.session_type == "some session_type"
      assert session.players == 42
      assert session.game_master == true
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quiz.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{session_type: "some updated session_type", players: 43, game_master: false}

      assert {:ok, %Session{} = session} = Quiz.update_session(session, update_attrs)
      assert session.session_type == "some updated session_type"
      assert session.players == 43
      assert session.game_master == false
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Quiz.update_session(session, @invalid_attrs)
      assert session == Quiz.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Quiz.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Quiz.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Quiz.change_session(session)
    end
  end

  describe "quiz_sessions" do
    alias Pokequiz.Quiz.Sessions

    import Pokequiz.QuizFixtures

    @invalid_attrs %{players: nil, game_master: nil}

    test "list_quiz_sessions/0 returns all quiz_sessions" do
      sessions = sessions_fixture()
      assert Quiz.list_quiz_sessions() == [sessions]
    end

    test "get_sessions!/1 returns the sessions with given id" do
      sessions = sessions_fixture()
      assert Quiz.get_sessions!(sessions.id) == sessions
    end

    test "create_sessions/1 with valid data creates a sessions" do
      valid_attrs = %{players: 42, game_master: true}

      assert {:ok, %Sessions{} = sessions} = Quiz.create_sessions(valid_attrs)
      assert sessions.players == 42
      assert sessions.game_master == true
    end

    test "create_sessions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quiz.create_sessions(@invalid_attrs)
    end

    test "update_sessions/2 with valid data updates the sessions" do
      sessions = sessions_fixture()
      update_attrs = %{players: 43, game_master: false}

      assert {:ok, %Sessions{} = sessions} = Quiz.update_sessions(sessions, update_attrs)
      assert sessions.players == 43
      assert sessions.game_master == false
    end

    test "update_sessions/2 with invalid data returns error changeset" do
      sessions = sessions_fixture()
      assert {:error, %Ecto.Changeset{}} = Quiz.update_sessions(sessions, @invalid_attrs)
      assert sessions == Quiz.get_sessions!(sessions.id)
    end

    test "delete_sessions/1 deletes the sessions" do
      sessions = sessions_fixture()
      assert {:ok, %Sessions{}} = Quiz.delete_sessions(sessions)
      assert_raise Ecto.NoResultsError, fn -> Quiz.get_sessions!(sessions.id) end
    end

    test "change_sessions/1 returns a sessions changeset" do
      sessions = sessions_fixture()
      assert %Ecto.Changeset{} = Quiz.change_sessions(sessions)
    end
  end
end
