# All Builds

- Access your dev profile at https://developer.yahoo.com/apps/ and choose the related app
- Create the required environment variables with file:

```
cat <<EOT > .env
CORS_ALLOWED_ORIGIN="<https-endpoint-frontend-is-served-at>"
YAHOO_OAUTH_CLIENT_ID="<from-yahoo-developer-apps-profile>"
YAHOO_OAUTH_CLIENT_SECRET="<from-yahoo-developer-apps-profile>"
EOT
```

## Local Development Only

When debugging, toggle debug dependencies _back_ on in Cargo.toml.
Run for local development:

```
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem
```

## AWS Only

### Build

Install the tool with:

```
brew tap cargo-lambda/cargo-lambda
brew install cargo-lambda
```

build:

```
cargo lambda build --release
```

### Deployment

```
cargo lambda deploy --enable-function-url --profile username
```
