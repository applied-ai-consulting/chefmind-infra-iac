# LiteLLM deployment

This compose stack runs LiteLLM with persistence backed by the shared ChefMind RDS Postgres instance.

## Files

- `docker-compose.yml` — LiteLLM service definition
- `litellm.config.yaml` — proxy configuration
- `.env.example` — required environment variables

## Notes

- The database is intentionally externalized to RDS, so LiteLLM data survives container replacement.
- The published port is bound to `127.0.0.1` by default; expose it through the existing reverse proxy/API layer instead of making it public.
- Generate application-scoped LiteLLM virtual keys from the master key after the proxy is up.

## Startup

```bash
cd deploy
cp .env.example .env
# fill in real values first

docker compose up -d
```
