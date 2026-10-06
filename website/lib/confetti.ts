"use client";

import confetti from "canvas-confetti";

export function triggerDownloadConfetti() {
  try {
    const end = Date.now() + 1.2 * 1000;
    const colors = ["#FF5E57", "#FF7A45", "#10B981", "#3B82F6", "#F59E0B"];

    (function frame() {
      confetti({
        particleCount: 3,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: colors,
      });
      confetti({
        particleCount: 3,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: colors,
      });

      if (Date.now() < end) {
        requestAnimationFrame(frame);
      }
    })();
  } catch (e) {
    // Graceful fallback if canvas is not supported
  }
}
