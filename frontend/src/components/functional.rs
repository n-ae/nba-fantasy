use super::view::ViewAuthContext;
use crate::model::video::Video;
use gloo_net::http::Request;
use yew::prelude::*;
use yew_oauth2::prelude::*;

#[function_component(ViewAuthInfoFunctional)]
pub fn view_info() -> Html {
    let auth = use_context::<OAuth2Context>();
    let auth2 = use_context::<OAuth2Context>();

    let videos = use_state(|| vec![]);

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
                let response = request.send().await.unwrap();
                log::debug!("response:\n{:?}", response);

                let response = Request::get("/tutorial/data.json").send().await.unwrap();
                let fetched_videos: Vec<Video> = response.json().await.unwrap();
                videos.set(fetched_videos);
            });
            || ()
        },
        (),
    );

    html!(
        if let Some(auth) = auth {
            <>
                <h2> { "Function component example"} </h2>
                <ViewAuthContext {auth} />
            </>
        } else {
            { "OAuth2 context not found." }
        }
    )
}
