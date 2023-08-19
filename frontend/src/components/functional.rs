use crate::model::standings_response::StandingsResponse;
use gloo_net::http::Request;
use yew::prelude::*;
use yew_oauth2::prelude::*;

#[function_component(ViewAuthInfoFunctional)]
pub fn view_info() -> Html {
    let auth = use_context::<OAuth2Context>();
    let auth2 = use_context::<OAuth2Context>();
    let response = use_state(|| None);

    {
        let response = response.clone();
        use_effect_with_deps(
            move |_| {
                wasm_bindgen_futures::spawn_local(async move {
                    let auth3 = auth2.expect("TODO: add error handling");
                    let asd2 = auth3.authentication().expect("TODO: add error handling");
                    let standings_url = "https://fantasysports.yahooapis.com/fantasy/v2/league/418.l.9097/standings?format=json";
                    let url = [dotenv!("CORS_REVERSE_PROXY_ENDPOINT"), standings_url]
                        .iter()
                        .copied()
                        .skip_while(|&x| x.is_empty())
                        .collect::<Vec<&str>>()
                        .join("/");
                    let request = Request::get(url.as_str()).header(
                        "Authorization",
                        format!("Bearer {}", &asd2.access_token).as_str(),
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
