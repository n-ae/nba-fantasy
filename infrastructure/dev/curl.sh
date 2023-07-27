# # curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'
# eval "$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'"

# jq -n --arg foobaz "$FOOBAZ" '{"foobaz":$foobaz}'



eval "$(jq -r '@sh "FOO=dsa BAZ=ass"')"

# Placeholder for whatever data-fetching logic your script implements
result=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg result "$result" '{"result":$result}'
