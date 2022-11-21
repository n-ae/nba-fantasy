use lambda_runtime::{service_fn, Error, LambdaEvent};
use serde_json::{json, Value};

pub async fn run() -> Result<(), Error> {
    let func = service_fn(func);
    lambda_runtime::run(func).await?;

    Ok(())
}

async fn func(event: LambdaEvent<Value>) -> Result<Value, Error> {
    let (event, _context) = event.into_parts();
    let token_body = serde_json::from_value::<crate::api::token::TokenBody>(event).unwrap();
    let result = crate::api::token::token_func_async(token_body).await;

    Ok(json!(result))
}
