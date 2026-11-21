// The camera QR scanner of the web export (spec 05, D8). The game calls
// `hackStarQr.start(callback)` through JavaScriptBridge; the callback gets ("scanned", text) or
// ("failed", reason) with reason "denied", "no_camera", "needs_https" or "cancelled".
// A full-screen <video> lies over the game canvas, so camera frames never go into the engine.
(function () {
  "use strict";

  var overlay = null;
  var stream = null;
  var frame = 0;
  var report = null;

  function reasonOf(error) {
    var name = error && error.name ? error.name : "";
    if (name === "NotAllowedError" || name === "SecurityError") return "denied";
    return "no_camera";
  }

  function stop() {
    if (frame) cancelAnimationFrame(frame);
    frame = 0;
    if (stream) stream.getTracks().forEach(function (track) { track.stop(); });
    stream = null;
    if (overlay) overlay.remove();
    overlay = null;
  }

  function finish(kind, value) {
    var callback = report;
    report = null;
    stop();
    if (callback) callback(kind, value);
  }

  function buildOverlay() {
    var root = document.createElement("div");
    root.id = "hack-star-qr";
    root.style.cssText =
      "position:fixed;inset:0;z-index:1000;background:#05070f;display:flex;" +
      "flex-direction:column;align-items:center;justify-content:center;gap:16px;" +
      "font:700 20px sans-serif;color:#f0f2ff;";
    var video = document.createElement("video");
    video.setAttribute("playsinline", "");
    video.muted = true;
    video.style.cssText = "max-width:100%;max-height:70vh;border:4px solid #ffd94d;border-radius:16px;";
    var hint = document.createElement("p");
    hint.textContent = "Point the camera at a hack QR code";
    hint.style.margin = "0";
    var cancel = document.createElement("button");
    cancel.id = "hack-star-qr-cancel";
    cancel.textContent = "Cancel";
    cancel.style.cssText =
      "min-width:200px;min-height:64px;font:700 24px sans-serif;border-radius:12px;" +
      "border:none;background:#ffd94d;color:#05070f;";
    cancel.addEventListener("click", function () { finish("failed", "cancelled"); });
    root.appendChild(video);
    root.appendChild(hint);
    root.appendChild(cancel);
    document.body.appendChild(root);
    return { root: root, video: video };
  }

  function scanFrames(video) {
    var canvas = document.createElement("canvas");
    var context = canvas.getContext("2d", { willReadFrequently: true });
    function scan() {
      frame = 0;
      if (!report) return;
      if (video.readyState >= video.HAVE_ENOUGH_DATA && video.videoWidth > 0) {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        context.drawImage(video, 0, 0);
        var image = context.getImageData(0, 0, canvas.width, canvas.height);
        var found = window.jsQR(image.data, image.width, image.height, {
          inversionAttempts: "dontInvert",
        });
        if (found && found.data) {
          finish("scanned", found.data);
          return;
        }
      }
      frame = requestAnimationFrame(scan);
    }
    frame = requestAnimationFrame(scan);
  }

  function start(callback) {
    stop();
    report = callback;
    // Browsers allow the camera only on https:// or localhost.
    if (!window.isSecureContext || !navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      finish("failed", "needs_https");
      return;
    }
    if (typeof window.jsQR !== "function") {
      finish("failed", "no_camera");
      return;
    }
    var parts = buildOverlay();
    overlay = parts.root;
    navigator.mediaDevices
      .getUserMedia({ video: { facingMode: "environment" }, audio: false })
      .then(function (opened) {
        if (!report) {
          opened.getTracks().forEach(function (track) { track.stop(); });
          return;
        }
        stream = opened;
        parts.video.srcObject = opened;
        return parts.video.play().then(function () { scanFrames(parts.video); });
      })
      .catch(function (error) {
        if (report) finish("failed", reasonOf(error));
      });
  }

  // Closes the camera without a report, when the hack screen goes away.
  function cancel() {
    report = null;
    stop();
  }

  window.hackStarQr = { start: start, cancel: cancel };
})();
