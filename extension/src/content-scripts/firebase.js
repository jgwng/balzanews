import { initializeApp } from "firebase/app";
import { getFirestore, doc, setDoc, updateDoc, increment, getDoc } from "firebase/firestore";

let app;
let db;

function initializeFirebase() {
  app = initializeApp(firebaseConfig);
  db = getFirestore(app);
}

const firebaseConfig = {
    apiKey: "AIzaSyCExQ2ZjW7Px-AP7zq5518MoEEXcX5G3nI",
    authDomain: "balzanews.firebaseapp.com",
    projectId: "balzanews",
    storageBucket: "balzanews.firebasestorage.app",
    messagingSenderId: "218913319956",
    appId: "1:218913319956:web:3b79b2da25d46514590b01"
};

export async function incrementBlogView(techCorp) {
    if (!app || !db) {
        initializeFirebase();
    }
    try {
        const docRef = doc(db, "techNews", techCorp.title);
        const docSnap = await getDoc(docRef);

        if (docSnap.exists()) {
            await updateDoc(docRef, { views: increment(1) });
            console.log(`✅ View count incremented for ${techCorp.title}`);
        } else {
            await setDoc(docRef, { views: 1, ...techCorp }, { merge: true });
            console.log(`✅ Document created and view count set to 1 for ${techCorp.title}`);
        }
    } catch (error) {
        console.error("❌ Error incrementing view count:", error);
    }
}
