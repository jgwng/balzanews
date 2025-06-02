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

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png',
  });
});










//
//
//
//
//
//
//// Import the functions you need from the SDKs you need
//import { initializeApp } from "firebase/app";
//// TODO: Add SDKs for Firebase products that you want to use
//// https://firebase.google.com/docs/web/setup#available-libraries
//
//// Your web app's Firebase configuration
//const firebaseConfig = {
//  apiKey: "AIzaSyCtm1Qzd25UVygxRvqWQ3bXjEb_Hao6Pys",
//  authDomain: "check-gas.firebaseapp.com",
//  databaseURL: "https://check-gas-default-rtdb.firebaseio.com",
//  projectId: "check-gas",
//  storageBucket: "check-gas.firebasestorage.app",
//  messagingSenderId: "900025548955",
//  appId: "1:900025548955:web:860e80c3e7167c2138863e"
//};
//
//// Initialize Firebase
//const app = initializeApp(firebaseConfig);





