const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { setGlobalOptions } = require("firebase-functions/v2");

admin.initializeApp();
const db = admin.firestore();
setGlobalOptions({ region: "asia-northeast3" });

exports.saveUserToken = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const { token, alarmTime } = req.body;

      if (!token || !alarmTime || typeof alarmTime !== "string") {
        return res.status(400).send("Missing or invalid parameters");
      }

      const docRef = admin.firestore().collection("alarmSlots").doc(alarmTime);

      await docRef.set(
        {
          tokens: admin.firestore.FieldValue.arrayUnion(token),
        },
        { merge: true }
      );

      return res.status(200).send("✅ Token registered in alarm slot");
    } catch (e) {
      console.error("❌ Error saving token to slot:", e);
      res.status(500).send("Internal Server Error");
    }
  });
});
exports.sendScheduledPush = onSchedule("0,30 0-23 * * *", async (event) => {
  const now = new Date();
  const hhmm = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;

  const doc = await db.collection("alarmSlots").doc(hhmm).get();
  if (!doc.exists) {
    console.log(`⏰ No tokens for ${hhmm}`);
    return;
  }

  const tokens = doc.data().tokens || [];
  if (tokens.length === 0) {
    console.log(`⚠️ Empty token list for ${hhmm}`);
    return;
  }

  const payload = {
    notification: {
      title: "📰 개발자 뉴스 도착!",
      body: "지금 확인하세요 — 오늘의 뉴스가 도착했어요 🗞️",
    },
  };

  await admin.messaging().sendToDevice(tokens, payload);
  console.log(`✅ Sent push to ${tokens.length} users at ${hhmm}`);
});
