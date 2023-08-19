// use crate::components::view::ViewAuthContext;
use crate::model::standings_response::StandingsResponse;
use gloo_net::http::Request;
use yew::prelude::*;
use yew_oauth2::prelude::*;

#[function_component(ViewAuthInfoFunctional)]
pub fn view_info() -> Html {
    let auth = use_context::<OAuth2Context>();
    let response = use_state(|| None);
    {
        let auth = auth.clone();
        let response = response.clone();
        use_effect_with_deps(
            move |_| {
                wasm_bindgen_futures::spawn_local(async move {
                    let auth_binding = auth.expect("TODO: add error handling");
                    let oauth2_info = auth_binding
                        .authentication()
                        .expect("TODO: add error handling");
                    let standings_url = "https://fantasysports.yahooapis.com/fantasy/v2/league/418.l.9097/standings?format=json";
                    let url = [dotenv!("CORS_REVERSE_PROXY_ENDPOINT"), standings_url]
                        .iter()
                        .copied()
                        .skip_while(|&x| x.is_empty())
                        .collect::<Vec<&str>>()
                        .join("/");
                    let request = Request::get(url.as_str()).header(
                        "Authorization",
                        format!("Bearer {}", &oauth2_info.access_token).as_str(),
                    );
                    let auth_response = request.send().await.unwrap();
                    log::debug!("auth_response:\n{:?}", auth_response);

                    let s: StandingsResponse = auth_response.json().await.unwrap();
                    response.set(Some(s.clone()));
                });
                || ()
            },
            (),
        );
    }

    let auth = use_context::<OAuth2Context>();
    html!(
        <>
        if let Some(r) = (*response).as_ref() {
            <h3> { format!("{:?}", r.fantasy_content.league[0].name.clone().unwrap()) } </h3>
        }
        if let Some(auth) = auth {
                <h2> { "Function component example"} </h2>
                // <ViewAuthContext {auth} />
            } else {
                { "OAuth2 context not found." }
            }
        </>
    )
}
