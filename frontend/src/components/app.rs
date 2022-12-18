use gloo_net::http::Request;
use yew::{function_component, html, use_effect_with_deps, use_state, Callback};

use crate::components::video_details::VideoDetails;
use crate::components::videos_list::VideosList;
use crate::model::video::Video;

use crate::components::functional::ViewAuthInfoFunctional;
use yew::prelude::*;
use yew_oauth2::prelude::*;

use yew_oauth2::oauth2::{Client, Config, LocationRedirect, OAuth2};
use yew_router::prelude::{Router, RouterAnchor, Switch};

#[derive(Switch, Debug, Clone, PartialEq, Eq)]
pub enum AppRoute {
    #[to = "/function"]
    Function,
    #[to = "/"]
    Index,
}

#[function_component(App)]
pub fn app() -> Html {
    log::debug!("App Component entered...");

    let videos = use_state(|| vec![]);
    {
        let videos = videos.clone();
        use_effect_with_deps(
            move |_| {
                let videos = videos.clone();
                wasm_bindgen_futures::spawn_local(async move {
                    let response = Request::get("/tutorial/data.json").send().await.unwrap();
                    log::debug!("response:\n{:?}", response);
                    let fetched_videos: Vec<Video> = response.json().await.unwrap();
                    log::debug!("fetched_videos:\n{:?}", fetched_videos);
                    videos.set(fetched_videos);
                });
                || ()
            },
            (),
        );
    }

    let selected_video = use_state(|| None);
    let on_video_select = {
        let selected_video = selected_video.clone();
        Callback::from(move |video: Video| selected_video.set(Some(video)))
    };

    let details = selected_video.as_ref().map(|video| {
        html! {
            <VideoDetails video={video.clone()} />
        }
    });

    let login = |_: MouseEvent| {
        OAuth2Dispatcher::<Client>::new().start_login();
    };
    let logout = |_: MouseEvent| {
        OAuth2Dispatcher::<Client>::new().logout();
    };

    let config = Config {
        client_id: dotenv!("YAHOO_OAUTH_CLIENT_ID").to_string(),
        auth_url: "https://api.login.yahoo.com/oauth2/request_auth".into(),
        token_url: dotenv!("YAHOO_OAUTH_TOKEN_URL").to_string(),
    };

    html! {
        <>
        <OAuth2
            {config}
            >
            <Failure>
                <ul>
                    <li><FailureMessage/></li>
                </ul>
            </Failure>
            <Authenticated>
                <p>
                    <button onclick={logout}>{ "Logout" }</button>
                </p>
                <ul>
                    <li><RouterAnchor<AppRoute> route={AppRoute::Index}> { "Index" } </RouterAnchor<AppRoute>></li>
                    <li><RouterAnchor<AppRoute> route={AppRoute::Function}> { "Function" } </RouterAnchor<AppRoute>></li>
                </ul>
                <Router<AppRoute>
                    render = { Router::render(|switch: AppRoute| {
                        match switch {
                            AppRoute::Index => html!(<p> { "You are logged in"} </p>),
                            AppRoute::Function => html!(<ViewAuthInfoFunctional />),
                        }
                    })}
                />
            </Authenticated>
            <NotAuthenticated>
                <Router<AppRoute>
                    render = { Router::render(move |switch: AppRoute| {
                        match switch {
                            AppRoute::Index => html!(
                                <>
                                    <p>
                                        { "You need to log in" }
                                    </p>
                                    <p>
                                        <button onclick={login.clone()}>{ "Login" }</button>
                                    </p>
                                </>
                            ),
                            _ => html!(<LocationRedirect logout_href="/" />),
                        }
                    })}
                />
            </NotAuthenticated>
        </OAuth2>
        <VideosList videos={(*videos).clone()} on_click={on_video_select.clone()} />
        { for details }
        </>
    }
}
