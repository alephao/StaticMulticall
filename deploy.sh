set -u
# import .env
set -o allexport
source .env
set +o allexport

forge create StaticMulticall \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  --optimize \
  --force