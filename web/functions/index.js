const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });

admin.initializeApp();
const db = admin.firestore();

exports.saveUserTokenViaHttp = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    const { userId, fcmToken } = req.body;

    if (!userId || !fcmToken) {
      return res.status(400).send("Missing userId or fcmToken");
    }

    try {
      await admin.firestore().collection("userTokens").doc(userId).set({
        fcmToken,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return res.status(200).send("Token saved successfully");
    } catch (error) {
      console.error("🔥 Error saving token:", error);
      return res.status(500).send("Failed to save token");
    }
  });
});