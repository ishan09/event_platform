defmodule EventPlatformWeb.Plugs.VerifyUser do
  use Guardian.Plug.Pipeline,
    otp_app: :event_platform,
    module: EventPlatformWeb.AuthenticationHelper,
    error_handler: EventPlatformWeb.AuthenticationHelper

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource

end
