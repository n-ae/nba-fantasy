For frontend run:

```
export YAHOO_OAUTH_CLIENT_ID="<client_id>" ;\
    export YAHOO_OAUTH_TOKEN_URL="https://localhost/api/token" ;\
    cd frontend ;\
    trunk serve
```

oauth2 requires redirecting back to a https, run:

```
ngrok http 8080
```

and then for backend run:

```
export YAHOO_OAUTH_CLIENT_ID="<client_id>" ;\
    export YAHOO_OAUTH_CLIENT_SECRET="<client_secret>" ;\
    export CORS_ALLOWED_ORIGIN="<fe_https_endpoint>" ;\
    cd backend ;\
    cargo run
```

If CORS errors optionally run below in the helper repo as proxy:

```
cors everywhere -> git checkout main -> heroku create -> git push heroku main

```
