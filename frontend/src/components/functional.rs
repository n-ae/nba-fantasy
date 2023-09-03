use crate::components::view::ViewAuthContext;
use crate::proxy::get_proxied_url;
use gloo_net::http::Request;
use yahoo_fantasy_sports_api::get_standings;
use yahoo_fantasy_sports_api::models::standings::FantasyContent;
use yew::prelude::*;
use yew_oauth2::prelude::*;

#[function_component(ViewAuthInfoFunctional)]
pub fn view_info() -> Html {
    let auth = use_context::<OAuth2Context>();
    let response = use_state(|| None::<FantasyContent>);
    {
        let auth = auth.clone();
        let response = response.clone();
        use_effect_with_deps(
            move |_| {
                wasm_bindgen_futures::spawn_local(async move {
                    let auth_binding = &auth.expect("TODO: add error handling");
                    let oauth2_info = auth_binding
                        .authentication()
                        .expect("TODO: add error handling");
                    let url = get_proxied_url("https://fantasysports.yahooapis.com/fantasy/v2/league/418.l.9097/standings");
                    let request = Request::get(url.as_str()).header(
                        "Authorization",
                        format!("Bearer {}", &oauth2_info.access_token).as_str(),
                    );
                    log::debug!("url:\n{:#?}", &url);
                    let resp: gloo_net::http::Response = request.send().await.unwrap();
                    log::debug!("resp:\n{:?}", &resp);

                    let s = resp.text().await.unwrap();
                    log::debug!("standings_response:\n{:?}", &s);
                    let des = get_standings(&s);
                    log::debug!("fantasy_content:\n{:?}", &des);
                    response.set(Some(des.clone()));
                });
                || ()
            },
            (),
        );
    }

    html!(
        <>
        if let Some(r) = (*response).as_ref() {
            <h3> { format!("{:#?}", r.league.name.clone()) } </h3>
            <h3> { format!("{:#?}", r.league.standings.clone()) } </h3>
        }
        if let Some(auth) = auth {
                <h2> { "Function component example"} </h2>
                <ViewAuthContext {auth} />
            } else {
                { "OAuth2 context not found." }
            }
        </>
    )
}
