import { initializeApp } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-app.js";
import { getMessaging, getToken, onMessage } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-messaging.js";

const firebaseConfig = {
      apiKey: "AIzaSyAJHib-ebXVdbVThD3Bshli9mnOEliYIX8",
      authDomain: "balzanewss.firebaseapp.com",
      projectId: "balzanewss",
      storageBucket: "balzanewss.firebasestorage.app",
      messagingSenderId: "975680017471",
      appId: "1:975680017471:web:e16c70fc1116858ba1148a"
};
  
const app = initializeApp(firebaseConfig);

onMessage(messaging, (payload) => {
  console.log("📩 Foreground push received:", payload);

  // Optionally show a notification
  if (Notification.permission === "granted" && payload?.notification) {
    new Notification(payload.notification.title, {
      body: payload.notification.body,
      icon: '/icons/Icon-192.png',
    });
  }
});

async function generateFcmToken() {
  try {
    const messaging = getMessaging(app);
    const token = await getToken(messaging, {
      vapidKey: 'BLWmQrqAEQY8mCXQMhL9g18T2eiLnODTstn3fZte3TwGzwMiqEnlGdzn_cjXSU7d-RuIxQjJkxZoEuQ-PT8lTlU'
    });

    if (token) {
      console.log("✅ FCM Token:", token);
      localStorage.setItem("PWA_PUSH_TOKEN", token); // ✅ Save token to localStorage
      return token;
    } else {
      console.warn("⚠️ No token available. Ask for permission first.");
      return null;
    }
  } catch (err) {
    console.error("❌ Error retrieving token:", err);
    return null;
  }
}
function saveUserToken(time) {
  const token = localStorage.getItem("PWA_PUSH_TOKEN");
  if (!token) {
    console.warn("⚠️ No push token found in localStorage.");
    return;
  }

  fetch("https://asia-northeast3-balzanewss.cloudfunctions.net/saveUserToken", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      token: token,
      alarmTime: time,
    }),
  })
    .then(response => response.text())
    .then(data => console.log("✅ Response:", data))
    .catch(error => console.error("❌ Error:", error));
}

function removeUserToken(time) {
  const token = localStorage.getItem("PWA_PUSH_TOKEN");
  if (!token) {
    console.warn("⚠️ No push token found in localStorage.");
    return;
  }

  fetch("https://asia-northeast3-balzanewss.cloudfunctions.net/removeUserToken", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      token: token,
      alarmTime: time,
    }),
  })
    .then(response => response.text())
    .then(data => console.log("✅ Response:", data))
    .catch(error => console.error("❌ Error:", error));
}


window.generateFcmToken = generateFcmToken;
window.saveUserToken = saveUserToken;
window.removeUserToken = removeUserToken;