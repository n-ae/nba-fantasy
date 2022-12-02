#[macro_use]
extern crate dotenv_codegen;

mod components;
mod model;

fn main() {
    wasm_logger::init(wasm_logger::Config::default());
    log::debug!("Main started...");
    yew::start_app::<components::app::App>();
}
