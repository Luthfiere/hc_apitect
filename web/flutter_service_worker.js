'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "3c389e981b68670e785ae86571256a1f",
"version.json": "df41a6c5d3d84ae8b3d34eefdf47da0b",
"index.html": "2a04c56fe05acd646829c0cd47f01a75",
"/": "2a04c56fe05acd646829c0cd47f01a75",
"main.dart.js": "21f80230eab75d6c2c439746bd709e43",
"web/flutter_bootstrap.js": "3c389e981b68670e785ae86571256a1f",
"web/version.json": "df41a6c5d3d84ae8b3d34eefdf47da0b",
"web/index.html": "2a04c56fe05acd646829c0cd47f01a75",
"web/main.dart.js": "21f80230eab75d6c2c439746bd709e43",
"web/flutter.js": "18587c590e5c7a76f5c8fc8822445e17",
"web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"web/icons/logoappptap.png": "ec2158cfd921293c314fedf821812591",
"web/manifest.json": "44a8351048109f39859bd9f372472ec7",
"web/assets/AssetManifest.json": "dea520a86940fb85504578a50cc3f9a9",
"web/assets/NOTICES": "8ca26e83a40be7abb6e9e9f37b67678a",
"web/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"web/assets/AssetManifest.bin.json": "808a59162a24b40e4756fadbc23b6cfb",
"web/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"web/assets/shaders/ink_sparkle.frag": "9bb2aaa0f9a9213b623947fa682efa76",
"web/assets/AssetManifest.bin": "2cc123c08dd715051aa8c9e4d87eb913",
"web/assets/fonts/MaterialIcons-Regular.otf": "ab77efc7cac8a56e999574e3160f897b",
"web/assets/assets/threepeople.png": "2b38dbc21a615bdf738e3ebb2c2d1923",
"web/assets/assets/logolengkapptap.png": "2c5975804a7394af128c2cbd80370c14",
"web/assets/assets/logoappptap.png": "ec2158cfd921293c314fedf821812591",
"web/assets/assets/brainstorming.png": "21223ae60b5633d26a47030b4042b5e2",
"web/assets/assets/deadline.png": "5cd33960d918cfb1eb6126be83ca84a7",
"web/assets/assets/certificates/fullchain.pem": "264e51e2a0473853ac802b2462f39b21",
"web/assets/assets/puzzletim.png": "90e89a58df6933d76139daaca642fda0",
"web/assets/assets/logoptap.png": "5fd7d319bf8d7f8b3d01c4019e9efddd",
"web/canvaskit/skwasm_st.js": "9eeb36850f248a8e946442a13aaaa009",
"web/canvaskit/skwasm.js": "8cc11b1079ca8735f29263baafbf330a",
"web/canvaskit/skwasm.js.symbols": "2a35929fae90775f43ce38f8bab1697a",
"web/canvaskit/canvaskit.js.symbols": "310951580eb657840fae86f76f653452",
"web/canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"web/canvaskit/chromium/canvaskit.js.symbols": "2bf18b9213f9fc9fb554c3890691f57c",
"web/canvaskit/chromium/canvaskit.js": "c7f8d21c08aba6f1bcf2a867a3a6218d",
"web/canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"web/canvaskit/skwasm_st.js.symbols": "ca49a44a388ecfe66ba43dd851d2b76d",
"web/canvaskit/canvaskit.js": "677902074133e9e70e65c3e357859f79",
"web/canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"web/canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"web/canvaskit/skwasm.worker.js": "b31cd002f2ed6e6d27aed1fa7658efae",
"flutter.js": "18587c590e5c7a76f5c8fc8822445e17",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/logoappptap.png": "ec2158cfd921293c314fedf821812591",
"manifest.json": "44a8351048109f39859bd9f372472ec7",
"assets/AssetManifest.json": "dea520a86940fb85504578a50cc3f9a9",
"assets/NOTICES": "8ca26e83a40be7abb6e9e9f37b67678a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "808a59162a24b40e4756fadbc23b6cfb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "9bb2aaa0f9a9213b623947fa682efa76",
"assets/AssetManifest.bin": "2cc123c08dd715051aa8c9e4d87eb913",
"assets/fonts/MaterialIcons-Regular.otf": "ab77efc7cac8a56e999574e3160f897b",
"assets/assets/threepeople.png": "2b38dbc21a615bdf738e3ebb2c2d1923",
"assets/assets/logolengkapptap.png": "2c5975804a7394af128c2cbd80370c14",
"assets/assets/logoappptap.png": "ec2158cfd921293c314fedf821812591",
"assets/assets/brainstorming.png": "21223ae60b5633d26a47030b4042b5e2",
"assets/assets/deadline.png": "5cd33960d918cfb1eb6126be83ca84a7",
"assets/assets/certificates/fullchain.pem": "264e51e2a0473853ac802b2462f39b21",
"assets/assets/puzzletim.png": "90e89a58df6933d76139daaca642fda0",
"assets/assets/logoptap.png": "5fd7d319bf8d7f8b3d01c4019e9efddd",
"canvaskit/skwasm_st.js": "9eeb36850f248a8e946442a13aaaa009",
"canvaskit/skwasm.js": "8cc11b1079ca8735f29263baafbf330a",
"canvaskit/skwasm.js.symbols": "2a35929fae90775f43ce38f8bab1697a",
"canvaskit/canvaskit.js.symbols": "310951580eb657840fae86f76f653452",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "2bf18b9213f9fc9fb554c3890691f57c",
"canvaskit/chromium/canvaskit.js": "c7f8d21c08aba6f1bcf2a867a3a6218d",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "ca49a44a388ecfe66ba43dd851d2b76d",
"canvaskit/canvaskit.js": "677902074133e9e70e65c3e357859f79",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm.worker.js": "b31cd002f2ed6e6d27aed1fa7658efae"};
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
