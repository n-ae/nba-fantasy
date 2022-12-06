# Production Deployment

- Build & Deploy backend ([see](backend/README.md))
- Set YAHOO_OAUTH_TOKEN_URL env var to backend endpoint
- Serve frontend with https ([see](frontend/README.md))
- Add the served endpoint to Redirect URI(s) in https://developer.yahoo.com/apps
- Add the served endpoint to CORS Allow Origin items in AWS Lambda CORS for the served backend
