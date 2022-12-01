
#[cfg(debug_assertions)]
pub async fn run() -> std::io::Result<()> {
    use crate::api::token::token;
    use actix_cors::Cors;
    use actix_web::{http, middleware::Logger, web::scope, App, HttpServer};
    use openssl::ssl::{SslAcceptor, SslFiletype, SslMethod};

    std::env::set_var("RUST_LOG", "debug");
    std::env::set_var("RUST_BACKTRACE", "1");
    env_logger::init();

    let mut builder = SslAcceptor::mozilla_intermediate(SslMethod::tls()).unwrap();
    builder
        .set_private_key_file("key.pem", SslFiletype::PEM)
        .unwrap();
    builder.set_certificate_chain_file("cert.pem").unwrap();

    HttpServer::new(move || {
        let logger = Logger::default();

        let cors = Cors::default()
            .allowed_origin(dotenv!("CORS_ALLOWED_ORIGIN"))
            .allowed_methods(vec!["GET", "POST"])
            .allowed_headers(vec![http::header::AUTHORIZATION, http::header::ACCEPT])
            .allowed_header(http::header::CONTENT_TYPE)
            .max_age(3600);

        App::new()
            .wrap(logger)
            .wrap(cors)
            .service(scope("/api").service(token))
    })
    .bind_openssl("0.0.0.0:443", builder)?
    .run()
    .await
}
