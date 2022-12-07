#[macro_use]
extern crate dotenv_codegen;

mod api;

#[cfg(not(feature = "debug"))]
mod lambda;
#[cfg(not(feature = "debug"))]
#[tokio::main]
async fn main() -> Result<(), lambda_http::Error> {
    lambda::run().await
}

#[cfg(feature = "debug")]
mod debug;
#[cfg(feature = "debug")]
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    debug::mvc::run().await
}
