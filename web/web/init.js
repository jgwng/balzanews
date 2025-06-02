window.addEventListener('scroll', () => {
  if (previousY > 100 && window.scrollY === 0) {
    console.log('🔝 Probably scrolled to top via status bar tap');
  }
  previousY = window.scrollY;
});

function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

document.addEventListener('DOMContentLoaded', () => {
    const isLightMode = localStorage.getItem('IS_LIGHT_MODE') ?? 'true';
    const themeColor = isLightMode === 'true' ? '#F8F8FF' : '#1C1C20';
    setThemeColor(themeColor);
});

function updateViewportAttributes(attributesMap) {
    var viewportMetaTag = document.querySelector('meta[name="viewport"]');
    if (viewportMetaTag) {
        var content = viewportMetaTag.getAttribute('content');
        var contentObject = content.split(',').reduce((acc, curr) => {
            var [key, val] = curr.trim().split('=');
            acc[key] = val;
            return acc;
        }, {});

        // Update or remove attributes based on the attributesMap
        Object.keys(attributesMap).forEach(key => {
            if (attributesMap[key] === null || attributesMap[key] === undefined) {
                // Remove attribute if value is null or undefined
                delete contentObject[key];
            } else {
                // Update attribute normally
                contentObject[key] = attributesMap[key];
            }
        });

        var newContent = Object.entries(contentObject).map(([key, val]) => `${key}=${val}`).join(', ');
        viewportMetaTag.setAttribute('content', newContent);
    } else {
        console.error('Viewport meta tag not found');
    }
}

function bottomInset() {
   var bottomPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sab"));
   return bottomPadding;
}

function topInset() {
   var topPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sat"));
   return topPadding;
}

function leftInset() {
   var leftPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sal"));
   return leftPadding;
}

function rightInset() {
   var rightPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sar"));
   return rightPadding;
}

function setThemeColor(color) {
  let metaTag = document.querySelector('meta[name="theme-color"]');
  if (!metaTag) {
    metaTag = document.createElement('meta');
    metaTag.setAttribute('name', 'theme-color');
    document.head.appendChild(metaTag);
  }
  metaTag.setAttribute('content', color);
}

function setThemeData(theme) {
  document.documentElement.setAttribute('data-theme', theme);
}

function saveUserToken(token,time){
    fetch("https://asia-northeast3-balzanewss.cloudfunctions.net/saveUserToken", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        token: token,
        alarmTime: time, // array of time slots
      }),
    })
      .then(response => response.text())
      .then(data => console.log("✅ Response:", data))
      .catch(error => console.error("❌ Error:", error));
}

function removeUserToken(token,time){
    fetch("https://asia-northeast3-balzanewss.cloudfunctions.net/removeUserToken", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        token: token,
        alarmTime: time, // array of time slots
      }),
    })
      .then(response => response.text())
      .then(data => console.log("✅ Response:", data))
      .catch(error => console.error("❌ Error:", error));
}

async function sendTestPush(token) {
  try {
    const response = await fetch("https://testpush-wq2lg5j6kq-du.a.run.app", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ token: token }),
    });

    const result = await response.text(); // or .json() if you return JSON
    console.log("✅ Response from server:", result);
  } catch (err) {
    console.error("❌ Error sending push:", err);
  }
}
function showNotification(pushTitle,pushBody,pushImage) {
    const title = pushTitle;
    const options = {
        body: pushBody,
        icon: '/icons/Icon-192.png',
        image: pushImage,
//        data: {
//            "url": "https://andreinwald.github.io/webpush-ios-example/?page=success",
//            "message_id": "your_internal_unique_message_id_for_tracking"
//        },
    };
    navigator.serviceWorker.ready.then(async function (serviceWorker) {
        await serviceWorker.showNotification(title, options);
    });
}