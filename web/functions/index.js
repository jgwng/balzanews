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

exports.removeUserToken = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const { token, alarmTime } = req.body;

      if (!token || !alarmTime || typeof alarmTime !== "string") {
        return res.status(400).send("Missing or invalid parameters");
      }

      const docRef = admin.firestore().collection("alarmSlots").doc(alarmTime);

      await docRef.set(
        {
          tokens: admin.firestore.FieldValue.arrayRemove(token),
        },
        { merge: true }
      );

      return res.status(200).send("✅ Token removed from alarm slot");
    } catch (e) {
      console.error("❌ Error removing token from slot:", e);
      res.status(500).send("Internal Server Error");
    }
  });
});

exports.sendScheduledPush = onSchedule("0,30 0-23 * * *", async (event) => {
  try {
    const now = new Date();
    const options = {
      timeZone: 'Asia/Seoul',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false,
    };
    const formatter = new Intl.DateTimeFormat('en-US', options);
    const parts = formatter.formatToParts(now);
    const hh = parts.find((p) => p.type === 'hour').value;
    const mm = parts.find((p) => p.type === 'minute').value;
    const hhmm = `${hh}:${mm}`;

    console.log(`⏰ Looking for tokens at ${hhmm}`);

    const docRef = db.collection("alarmSlots").doc(hhmm);
    const doc = await docRef.get();

    if (!doc.exists) {
      console.log(`📭 No document for time ${hhmm}`);
      return;
    }

    const tokens = doc.data().tokens || [];

    if (tokens.length === 0) {
      console.log(`⚠️ No tokens found in ${hhmm} doc`);
      return;
    }

    console.log(`📨 Sending notification to ${tokens.length} users`);

    const payload = {
      notification: {
        title: "📰 개발자 뉴스 도착!",
        body: "지금 확인하세요 — 오늘의 뉴스가 도착했어요 🗞️",
      },
    };
    const response = await admin.messaging().sendEachForMulticast({
            tokens: tokens,
            notification: payload.notification,
    });

    console.log(`✅ Notification sent. Response:`, JSON.stringify(response));
  } catch (error) {
    console.error("❌ Scheduled push failed:", error);
  }
});

exports.testPush = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const { token } = req.body;

      if (!token || typeof token !== 'string') {
        return res.status(400).send("❌ Missing or invalid token");
      }

      const tokens = [token];
      const payload = {
        notification: {
          title: "📰 개발자 뉴스 도착!",
          body: "지금 확인하세요 — 오늘의 뉴스가 도착했어요 🗞️",
        },
      };

      console.log(`📨 Sending notification to ${tokens.length} users`);

      const response = await admin.messaging().sendEachForMulticast({
        tokens: tokens,
        notification: payload.notification,
      });

      console.log(`✅ Sent to ${response.successCount} tokens`);

      return res.status(200).send("✅ Push notification sent");
    } catch (e) {
      console.error("❌ Error sending push notification:", e);
      return res.status(500).send("❌ Internal Server Error");
    }
  });
});