'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "3cd85f7d636822536b15de814c6d7639",
"blog.webp": "0fa75b1ef838ba58aafd73ce4a0037d2",
"version.json": "5a12fa61850aced73dda7d9aa483057e",
"splash/icon_2436x1125.png": "bcdece4bac345221727d815bab44f026",
"splash/icon_1668x2388.png": "843998177c68c048eba075ac38616f2f",
"splash/icon_2048x1536.png": "79c7ac8518d5cf4dacce7bcbb090aaa1",
"splash/icon_2224x1668.png": "1c83d101ed2d2ec1bfe881152b58ba23",
"splash/icon_1136x640.png": "61558399b2d589bcd67c11b99beee70a",
"splash/icon_1125x2436.png": "bf6c75d36c1f586a8a2fdb6a97f81f84",
"splash/icon_2732x2048.png": "ff874abfe6cdea8cb2a3de278c3e0541",
"splash/icon_1242x2688.png": "81e946b9c974709f9a0248e6b1f216df",
"splash/icon_750x1334.png": "3868b830f44902568b8d2eda41600319",
"splash/icon_1536x2048.png": "7f5e4e9e35f48b8e63a030de6ab521e2",
"splash/icon_2688x1242.png": "7542791be857ba7717b1c0b36ee8df4d",
"splash/icon_2388x1668.png": "21c15502485210cad4459f2e0176aa86",
"splash/icon_640x1136.png": "f1f9cd742a9ac87a66559183ab99bfca",
"splash/icon_2048x2732.png": "1a2d7809f2f11e47bd71d5f88b62b1f7",
"splash/icon_828x1792.png": "a9aca3c7fb092fe0395deb2e6633b598",
"splash/icon_1792x828.png": "4a43def63e7bfaf87712db7899a83dcf",
"splash/icon_1242x2208.png": "ee2a0dc422c9e00681e9d986a7c15254",
"splash/icon_1334x750.png": "e18dd90e708c7bda1ab68602b7f9e0f0",
"splash/icon_2208x1242.png": "c6f95c121e73a72252fbf93341ce51fb",
"splash/icon_1668x2224.png": "2dba07bd59e8d70cafa5d2e707b5e7db",
"screenshots/3.webp": "d0b0fe5e2cc96ad5788f919cb37325df",
"screenshots/2.webp": "e1625eb10f04c07283a4ea950c4b669f",
"screenshots/1.webp": "174b1774a7809f842dd5b6c34f0754cd",
"index.html": "da37809ce07dec8be0dba5aeb5aaa551",
"/": "da37809ce07dec8be0dba5aeb5aaa551",
"styles.css": "a2b7708d806823119291c8de4bff1998",
"ogimage.png": "5cb8a7a827e8d88f57a7521c4c4881aa",
"firebase-messaging-sw.js": "28e81ea9e62b01f54fafed5fb3c6cf47",
"main.dart.js": "6595bae4ded90cb40361b017a5a28517",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"init.js": "e3a4bc02dc30692fc016d1a56280e2c0",
"favicon.png": "2671bf8f031c6f4872a356f2963c60ff",
"icons/favicon-16x16.png": "2671bf8f031c6f4872a356f2963c60ff",
"icons/Icon-192.png": "4af23cc77fd4b52a40f6e5b7f9486895",
"icons/Icon-maskable-192.png": "4af23cc77fd4b52a40f6e5b7f9486895",
"icons/Icon-maskable-512.png": "8c3096ad9af5bb46a39e6cca6d309130",
"icons/Icon-512.png": "8c3096ad9af5bb46a39e6cca6d309130",
"icons/favicon-32x32.png": "aaccfaaf7fff8868635b5183ebde0d5a",
"manifest.json": "97da4b029ca7061b8df604ee7e2a513e",
"ios_swipe_touch.js": "29062f888d4818dc96ada170a3ef9c4e",
"assets/AssetManifest.json": "91b8e30114ac485da7b895b851e1627b",
"assets/NOTICES": "a91f8080a4eb59d8dde923dcdd7e6912",
"assets/FontManifest.json": "b0c2960d2127b8d9bb97d675dc34db88",
"assets/AssetManifest.bin.json": "0ca3745acf74f8524e6a07c0a3172879",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "7bb986ddfe230e871cb048f4fddb3261",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ba82710e084881f29fac83424cf6c08c",
"assets/fonts/MaterialIcons-Regular.otf": "1bcb43ac7c91f097ce6616ced39f5067",
"assets/assets/fonts/Noto%2520Emoji.ttf": "2d3165fe3ce287e06e86bffa63317a72",
"assets/assets/fonts/Roboto.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/assets/fonts/KOHINanumOTF_Bold.otf": "c2f6c0e28d267f45261b6336b98c7988",
"assets/assets/fonts/KOHINanumOTF_Light.otf": "0347816b4a2c2d42cd0563dbc066a0fd",
"firebase.js": "deeda15dfc5d927b5499dc663cd61459",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
