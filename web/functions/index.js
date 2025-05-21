const functions = require("firebase-functions");
const express = require("express");
const axios = require("axios");
const cors = require("cors");

const app = express();
app.use(cors({ origin: true }));

app.get("/proxy", async (req, res) => {
  const targetUrl = req.query.url;

    if (!targetUrl) {
      return res.status(400).send('Missing ?url=');
    }

    try {
      const response = await axios.get(targetUrl);
      let html = response.data;

      const baseHref = new URL(targetUrl).origin + "/";

      // ✅ Inject <base href> only if missing
      if (!/<base\s+href=/i.test(html)) {
        html = html.replace(/<head>/i, `<head><base href="${baseHref}">`);
      }

      // ✅ Rewrite relative asset paths (images, scripts, styles)
      html = html.replace(/(src|href)=["']\/([^"']+)["']/g, `$1="${baseHref}$2"`);

      // ✅ Set correct content type for iframes
      res.set('Content-Type', 'text/html');
      res.set('Access-Control-Allow-Origin', '*');

      res.send(html);
    } catch (error) {
      console.error('Proxy error:', error.message);
      res.status(500).send(`Failed to fetch: ${error.message}`);
    }
});

exports.proxy = functions.https.onRequest(app);
