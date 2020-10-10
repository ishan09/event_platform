defmodule EventPlatformWeb.InviteView do
  use EventPlatformWeb, :view
  alias EventPlatformWeb.InviteView

  @status %{1 => "invited", 2 => "rejected", 3 => "accepted"}

  def render("ok.json", _) do
    :ok
  end

  def render("index.json", %{invites: invites}) do
    %{data: render_many(invites, InviteView, "invite.json")}
  end


  def render("index_invitees.json", %{invites: invites}) do
    %{data: render_many(invites, InviteView, "invitee.json")}
  end

  def render("show.json", %{invite: invite}) do
    %{data: render_one(invite, InviteView, "invitee.json")}
  end

  def render("invitee.json", %{invite: invite}) do
    %{
      invite_id: invite.id, 
      status: Map.get(@status, invite.status),
      id: invite.user_id,
      first_name: invite.invitee.first_name,
      last_name: invite.invitee.last_name,
      event_id: invite.event_id
    }
  end

  def render("invite.json", %{invite: invite}) do
    %{
      id: invite.id, 
      status: Map.get(@status, invite.status),
      event_id: invite.event_id,
      invitee_id: invite.user_id
    }
  end

  def render("error.json", %{error: error}) do
    msg =
      cond do
        is_list(error) ->
          Enum.map(error, fn {k, v} -> "#{k} #{elem(v, 0)}" end)
          true -> 
            error
      end

    %{error: msg}
  end
end
