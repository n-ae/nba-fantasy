use gloo_net::http::Request;
use yew::{function_component, html, use_effect_with_deps, use_state, Callback};

use crate::components::video_details::VideoDetails;
use crate::components::videos_list::VideosList;
use crate::components::login::Login;
use crate::model::video::Video;

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

    html! {
        <>
            <h1>{ "RustConf Explorer" }</h1>
            <div>
                <h3>{"Videos to watch"}</h3>
                <Login/>
                <VideosList videos={(*videos).clone()} on_click={on_video_select.clone()} />
            </div>
            { for details }
        </>
    }
}
