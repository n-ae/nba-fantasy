# All Builds

- Access your dev profile at https://developer.yahoo.com/apps/ and choose the related app
- Create the required environment variables with file:

```
cat <<EOT > .env
YAHOO_OAUTH_CLIENT_ID="<from-yahoo-developer-apps-profile>"
YAHOO_OAUTH_TOKEN_URL="<backend-endpoint>"
EOT
```

If env changes run:

```
cargo clean
trunk serve
```

oauth2 requires redirecting back to a https, run:

```
ngrok http 8080
```
