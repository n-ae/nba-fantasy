use yew::prelude::*;
use yew_oauth2::oauth2::*;
use yew_oauth2::prelude::*; // use `openid::*` when using OpenID connect

pub struct Login;

impl Component for Login {
    type Message = ();
    type Properties = ();

    fn create(ctx: &Context<Self>) -> Self {
        Self
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let login = ctx.link().callback_once(|_: MouseEvent| {
            OAuth2Dispatcher::<Client>::new().start_login();
        });
        let logout = ctx.link().callback_once(|_: MouseEvent| {
            OAuth2Dispatcher::<Client>::new().logout();
        });

        let config = Config {
            client_id: "<client_id>".into(),
            //   auth_url: "https://api.login.yahoo.com/oauth/v2/request_auth".into(),
            auth_url: "https://api.login.yahoo.com/oauth2/request_auth".into(),
            //   token_url: "https://api.login.yahoo.com/oauth/v2/get_token".into(),
            token_url: "https://api.login.yahoo.com/oauth2/get_token".into(),
        };

        html!(
          <OAuth2 config={config}>
            <Failure><FailureMessage/></Failure>
            <Authenticated>
              <button onclick={logout}>{ "Logout" }</button>
            </Authenticated>
            <NotAuthenticated>
              <button onclick={login.clone()}>{ "Login" }</button>
            </NotAuthenticated>
          </OAuth2>
        )
    }
}
