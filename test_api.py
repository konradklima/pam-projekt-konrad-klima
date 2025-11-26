import urllib.request
import json

url = "https://the-one-api.dev/v2/character?limit=5"
headers = {
    "Authorization": "Bearer -JX2ZK6GrdBpPfKGBTbv"
}

try:
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        print(json.dumps(data, indent=2))
except Exception as e:
    print(f"Error: {e}")
