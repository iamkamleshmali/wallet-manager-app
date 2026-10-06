"use client";

import { Download } from "lucide-react";
import { useGitHubRelease } from "@/hooks/useGitHubRelease";
import { triggerDownloadConfetti } from "@/lib/confetti";

export default function MobileStickyDownload() {
  const { tagName, apkUrl, apkSizeMb } = useGitHubRelease();

  return (
    <div className="fixed bottom-4 left-4 right-4 z-40 sm:hidden">
      <a
        href={apkUrl}
        onClick={() => triggerDownloadConfetti()}
        className="flex items-center justify-between px-5 py-3.5 rounded-2xl bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white font-extrabold text-sm shadow-2xl border border-white/20 active:scale-95 transition-transform"
      >
        <div className="flex items-center gap-2.5">
          <Download className="w-5 h-5 animate-bounce" />
          <div className="text-left">
            <div className="leading-tight">Download APK</div>
            <div className="text-[10px] text-white/80 font-normal">{tagName} • {apkSizeMb}</div>
          </div>
        </div>
        <span className="text-[11px] bg-white text-coral-600 font-extrabold px-2.5 py-1 rounded-xl shadow-xs">
          Direct
        </span>
      </a>
    </div>
  );
}
