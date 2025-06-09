importScripts("https://www.gstatic.com/firebasejs/10.3.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.3.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyAJHib-ebXVdbVThD3Bshli9mnOEliYIX8",
    authDomain: "balzanewss.firebaseapp.com",
    projectId: "balzanewss",
    storageBucket: "balzanewss.firebasestorage.app",
    messagingSenderId: "975680017471",
    appId: "1:975680017471:web:e16c70fc1116858ba1148a"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(async function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const title = payload.notification.title;
  const options = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png',
    data: {
        dateOfArrival: Date.now()
    },
    // badge: '/icons/badge-icon.png', // Optional: separate badge icon
  };

  // Show the notification
  const notificationPromise = self.registration.showNotification(title, options);

  // Optional: Badge management
  const updateBadge = async () => {
    // Check for active clients (e.g., open tabs)
    const allClients = await self.clients.matchAll({ type: 'window', includeUncontrolled: true });
    const hasVisibleClient = allClients.some(client => client.visibilityState === 'visible');

    if (!hasVisibleClient && 'setAppBadge' in navigator) {
      // Use IndexedDB or global variable to track badge count in SW context
      self.badgeCount = (self.badgeCount || 0) + 1;
      navigator.setAppBadge(self.badgeCount);
    }
  };

  // Chain both
  event.waitUntil(
    Promise.all([notificationPromise, updateBadge()])
  );
});

