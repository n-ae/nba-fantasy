use crate::model::video::Video;

use super::view::ViewAuthContext;
use gloo_net::http::Request;
use yew::prelude::*;
use yew_oauth2::prelude::*;

#[function_component(ViewAuthInfoFunctional)]
pub fn view_info() -> Html {
    let auth = use_context::<OAuth2Context>();
    let auth2 = use_context::<OAuth2Context>();

    let videos = use_state(|| vec![]);
    {
        let videos = videos.clone();
        use_effect_with_deps(
            move |_| {
                let videos = videos.clone();
                wasm_bindgen_futures::spawn_local(async move {
                    let auth3 = auth2.expect("TODO: add error handling");
                    let asd2 = auth3.authentication().expect("TODO: add error handling");
                    let standings_url = "https://fantasysports.yahooapis.com/fantasy/v2/league/418.l.9097/standings?format=json";
                    let url = format!("{}/{}", dotenv!("CORS_REVERSE_PROXY_ENDPOINT"), standings_url);
                    // let request = Request::get("https://cors-anywhere.herokuapp.com/https://fantasysports.yahooapis.com/fantasy/v2/league/418.l.9097/standings?format=json")
                    let request = Request::get(url.as_str())
                        .header("Authorization", format!("Bearer {}", &asd2.access_token).as_str())
                        // .header("Access-Control-Allow-Origin", "https://43c5-46-1-240-92.eu.ngrok.io")
                        // .header("Access-Control-Allow-Methods", "GET")
                        // .header("Access-Control-Allow-Headers", "Content-Type, Authorization")
                        ;
                    let response = request.send().await.unwrap();
                    log::debug!("response:\n{:?}", response);
                    let response = Request::get("/tutorial/data.json").send().await.unwrap();
                    // log::debug!("response:\n{:?}", response);
                    let fetched_videos: Vec<Video> = response.json().await.unwrap();
                    // log::debug!("fetched_videos:\n{:?}", fetched_videos);
                    videos.set(fetched_videos);
                });
                || ()
            },
            (),
        );
    }

    html!(
        if let Some(auth) = auth {
            <h2> { "Function component example"} </h2>
            <ViewAuthContext {auth} />
        } else {
            { "OAuth2 context not found." }
        }
    )
}
