"use client";

import { useState } from "react";
import {
  Wallet,
  Download,
  Heart,
  ShieldCheck,
  ExternalLink,
  Sparkles,
} from "lucide-react";
import { GithubIcon } from "@/components/icons/GithubIcon";
import { useGitHubRelease } from "@/hooks/useGitHubRelease";
import { triggerDownloadConfetti } from "@/lib/confetti";
import PrivacyModal from "@/components/PrivacyModal";

export default function Footer() {
  const [privacyOpen, setPrivacyOpen] = useState(false);
  const { tagName, apkUrl, apkSizeMb } = useGitHubRelease();

  return (
    <>
      <footer className="bg-slate-900 text-slate-300 pt-16 pb-12 border-t border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 pb-12 border-b border-slate-800">
            
            {/* Col 1 & 2: Brand & Mission */}
            <div className="lg:col-span-2 space-y-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-coral-500 to-warmOrange-500 flex items-center justify-center text-white shadow-glow-coral">
                  <Wallet className="w-5 h-5" />
                </div>
                <div>
                  <span className="font-extrabold text-xl text-white tracking-tight">
                    Wallet Manager
                  </span>
                  <span className="block text-[11px] text-slate-400 font-medium">
                    Personal Finance & Expense Tracker
                  </span>
                </div>
              </div>
              <p className="text-sm text-slate-400 leading-relaxed max-w-sm">
                A clean, offline-first double-entry Money Manager application for Android.
                Complete privacy, receipt photo storage, and Google Drive auto-sync with zero ads.
              </p>
              <div className="flex items-center gap-2 pt-2">
                <span className="inline-flex items-center gap-1.5 text-xs font-semibold px-2.5 py-1 rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                  <ShieldCheck className="w-3.5 h-3.5" />
                  100% Free & Open-Source
                </span>
              </div>
            </div>

            {/* Col 3: Navigation */}
            <div>
              <h4 className="text-xs font-extrabold uppercase tracking-wider text-white mb-4">
                Explore App
              </h4>
              <ul className="space-y-2.5 text-sm">
                <li>
                  <a href="#features" className="hover:text-white transition-colors">
                    Core Features
                  </a>
                </li>
                <li>
                  <a href="#screenshots" className="hover:text-white transition-colors">
                    App Screens & Tabs
                  </a>
                </li>
                <li>
                  <a href="#sync" className="hover:text-white transition-colors">
                    Google Drive Backup
                  </a>
                </li>
                <li>
                  <a href="#security" className="hover:text-white transition-colors">
                    Security & Biometrics
                  </a>
                </li>
                <li>
                  <a href="#install" className="hover:text-white transition-colors">
                    APK Installation Guide
                  </a>
                </li>
              </ul>
            </div>

            {/* Col 4: Community & GitHub */}
            <div>
              <h4 className="text-xs font-extrabold uppercase tracking-wider text-white mb-4">
                Open Source
              </h4>
              <ul className="space-y-2.5 text-sm">
                <li>
                  <a
                    href="https://github.com/iamkamleshmali/wallet-manager-km"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="hover:text-white transition-colors flex items-center gap-1.5"
                  >
                    <GithubIcon className="w-4 h-4" />
                    <span>GitHub Repository</span>
                  </a>
                </li>
                <li>
                  <a
                    href="https://github.com/iamkamleshmali/wallet-manager-km/releases"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="hover:text-white transition-colors flex items-center gap-1.5"
                  >
                    <Download className="w-4 h-4" />
                    <span>All GitHub Releases</span>
                  </a>
                </li>
                <li>
                  <a
                    href="https://github.com/iamkamleshmali/wallet-manager-km/issues"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="hover:text-white transition-colors"
                  >
                    Report an Issue
                  </a>
                </li>
                <li>
                  <button
                    onClick={() => setPrivacyOpen(true)}
                    className="hover:text-white transition-colors text-left"
                  >
                    Privacy Policy
                  </button>
                </li>
              </ul>
            </div>

            {/* Col 5: Direct Download Callout */}
            <div className="space-y-3">
              <h4 className="text-xs font-extrabold uppercase tracking-wider text-white mb-4">
                Latest Release
              </h4>
              <div className="p-4 rounded-2xl bg-slate-800/80 border border-slate-700/80">
                <div className="text-xs text-slate-400 mb-1">Android Package</div>
                <div className="font-bold text-white text-sm flex items-center justify-between">
                  <span>{tagName}</span>
                  <span className="text-[10px] text-coral-400 font-semibold">{apkSizeMb}</span>
                </div>
                <a
                  href={apkUrl}
                  download="app-release.apk"
                  rel="noopener noreferrer"
                  onClick={() => triggerDownloadConfetti()}
                  className="mt-3 w-full flex items-center justify-center gap-2 py-2 rounded-xl bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white font-bold text-xs shadow-md hover:scale-102 transition-all"
                >
                  <Download className="w-3.5 h-3.5" />
                  <span>Download APK</span>
                </a>
              </div>
            </div>

          </div>

          {/* Bottom Bar: Copyright & Credits */}
          <div className="pt-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-500">
            <div>
              © 2026 Wallet Manager. Built by{" "}
              <a
                href="https://github.com/iamkamleshmali"
                target="_blank"
                rel="noopener noreferrer"
                className="text-coral-400 hover:underline font-semibold"
              >
                Kamlesh Mali
              </a>
              . Open-source under MIT.
            </div>

            <div className="flex items-center gap-6">
              <button
                onClick={() => setPrivacyOpen(true)}
                className="hover:text-slate-300 transition-colors"
              >
                Privacy
              </button>
              <a
                href="https://github.com/iamkamleshmali/wallet-manager-km"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-slate-300 transition-colors"
              >
                GitHub
              </a>
              <span className="flex items-center gap-1 text-slate-400">
                Crafted with <Heart className="w-3.5 h-3.5 text-coral-500 fill-coral-500" /> for Android
              </span>
            </div>
          </div>
        </div>
      </footer>

      {/* Privacy Policy Modal */}
      <PrivacyModal isOpen={privacyOpen} onClose={() => setPrivacyOpen(false)} />
    </>
  );
}
