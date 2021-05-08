defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias IEx.Info
  # socket is the state for a live view
  # assign puts data into the socket
  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Guess a number.",
       victory: false,
       user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
       session_id: session["live_socket_id"]
     )}
  end

  # score and message are keys of the socket.assigns map
  def render(assigns) do
    ~L"""
      <h1>Your score: <%= @score %></h1>
      <h2><%= @message %></h2>

      <h2>
        <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number="<%= n%>"><%= n%></a>
        <% end %>
      </h2>

      <h3><%= @victory %></h3>
      <%= if @victory == true do %>
        <h2>Congratulations, you won!</h2>
        <% end %>

        <pre>
          <%= @user.email %>
          <%= @user.username %>
          <%= @session_id %>
        </pre>
    """
  end

  # "guess" is the event name triggered by phx-click
  def handle_event("guess", %{"number" => guess}, socket) do
    assign =
      socket
      |> is_correct?(String.to_integer(guess))
      |> assign_message_score()
      |> is_winner?()

    {
      :noreply,
      assign
    }
  end

  # Time does not update on render since it isn't on socket.assigns
  def time() do
    DateTime.utc_now() |> to_string()
  end

  def random_num() do
    Enum.random(1..10)
  end

  def is_correct?(socket, number) do
    correct_number = random_num()
    IO.puts("Correct: #{correct_number}")
    IO.puts("Guess: #{number}")
    IO.puts(number == correct_number)
    {socket, number == correct_number, correct_number}
  end

  def assign_message_score({socket, true, correct}) do
    assign(socket,
      message: "Correct, congratulations! The number was #{correct}",
      score: socket.assigns.score + 1
    )
  end

  def assign_message_score({socket, false, correct}) do
    assign(socket,
      message: "You missed... The number was #{correct}. Guess again",
      score: socket.assigns.score - 1
    )
  end

  def is_winner?(socket) do
    score = socket.assigns.score
    is_winner = score >= 1
    assign(socket, victory: is_winner)
  end
end
