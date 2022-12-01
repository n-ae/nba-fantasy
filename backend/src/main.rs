#[macro_use]
extern crate dotenv_codegen;

mod api;

#[cfg(not(debug_assertions))]
mod lambda;
#[cfg(not(debug_assertions))]
#[tokio::main]
async fn main() -> Result<(), lambda_runtime::Error> {
    lambda::run().await
}

#[cfg(debug_assertions)]
mod mvc;
#[cfg(debug_assertions)]
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    mvc::run().await
}
