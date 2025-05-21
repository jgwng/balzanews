from flask import Flask, send_from_directory, request, Response
import os
import requests
import re
from urllib.parse import urlparse
from flask_cors import CORS

app = Flask(__name__, static_folder='static', static_url_path='')
CORS(app)  # ✅ Allow cross-origin calls from Flutter Web

# ✅ Serve Flutter Web frontend
@app.route('/')
def index():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory(app.static_folder, path)

# ✅ API proxy endpoint
@app.route('/proxy')
def proxy():
    target_url = request.args.get('url')
    if not target_url:
        return {"error": "Missing ?url="}, 400

    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
                          '(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
            'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7'
        }

        resp = requests.get(target_url, headers=headers)

        # ✅ Ensure encoding is respected
        if not resp.encoding or resp.encoding.lower() == 'iso-8859-1':
            resp.encoding = resp.apparent_encoding

        html = resp.text

        # ✅ Fix base href
        base_href = f"{urlparse(target_url).scheme}://{urlparse(target_url).netloc}/"
        if '<base' not in html.lower():
            html = re.sub(r'<head>', f'<head><base href="{base_href}">', html, flags=re.IGNORECASE)

        # ✅ Rewrite relative paths
        html = re.sub(r'(src|href)=["\']\/([^"\']+)["\']', f'\\1="{base_href}\\2"', html)

        # ✅ Optional: forcibly change <meta charset> to utf-8
        html = re.sub(
            r'<meta[^>]*charset=[^>]+>',
            '<meta charset="UTF-8">',
            html,
            flags=re.IGNORECASE
        )

        return Response(html, content_type='text/html; charset=utf-8',
                        headers={'Access-Control-Allow-Origin': '*'})

    except Exception as e:
        print("Proxy error:", e)
        return {"error": f"Proxy error: {str(e)}"}, 500

# 🔸 Run the app
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
