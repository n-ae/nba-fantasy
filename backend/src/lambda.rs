use crate::api::token::{token_func_async, TokenBody};
use lambda_http::{service_fn, Error, Request, RequestExt};
use serde_json::{json, Value};

pub async fn run() -> Result<(), Error> {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::INFO)
        .with_target(false)
        .without_time()
        .init();
    lambda_http::run(service_fn(function_handler)).await
}

async fn function_handler(event: Request) -> Result<Value, Error> {
    let token_body = event
        .payload::<TokenBody>()
        .expect("Unable to parse Form to Option")
        .expect("Unable to parse Form to Option");
    println!("{:?}", token_body);
    let result = token_func_async(token_body).await;

    Ok(json!(result))
}
