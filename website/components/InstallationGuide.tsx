"use client";

import {
  Download,
  ShieldAlert,
  Smartphone,
  CheckCircle2,
  ExternalLink,
  HelpCircle,
  Sparkles,
} from "lucide-react";
import { useGitHubRelease } from "@/hooks/useGitHubRelease";
import { triggerDownloadConfetti } from "@/lib/confetti";

export default function InstallationGuide() {
  const { tagName, apkUrl, apkSizeMb } = useGitHubRelease();

  const steps = [
    {
      num: "01",
      title: "Download the APK File",
      description:
        "Click the 'Download Android APK' button. The official .apk package will be fetched directly from GitHub Releases.",
      tip: "File size is only ~24.6 MB. Look for the download notification in your browser tray.",
      actionText: "Download APK",
      isDownload: true,
    },
    {
      num: "02",
      title: "Allow 'Install Unknown Apps'",
      description:
        "When opening the downloaded APK, Android may show a standard prompt: 'For your security, your phone is not allowed to install unknown apps from this source.'",
      tip: "Tap 'Settings' on the popup and toggle 'Allow from this source' for Chrome or your file manager.",
      actionText: "Standard Android Step",
      isDownload: false,
    },
    {
      num: "03",
      title: "Tap Install & Launch",
      description:
        "Return to the installer screen and tap 'Install'. Once completed, tap 'Open' to launch Wallet Manager and start tracking with complete privacy!",
      tip: "Your database stays preserved even when updating to future versions.",
      actionText: "Ready in 30 Seconds",
      isDownload: false,
    },
  ];

  return (
    <section id="install" className="py-24 bg-[#FAFAFC] dark:bg-[#0B0F17] relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Heading */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-coral-500/10 text-coral-600 dark:text-coral-400 text-xs font-bold uppercase tracking-wider mb-4 border border-coral-500/20">
            <Smartphone className="w-3.5 h-3.5" />
            Quick Setup Walkthrough
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight mb-4">
            How to install the APK on{" "}
            <span className="bg-gradient-to-r from-coral-500 to-warmOrange-500 bg-clip-text text-transparent">
              any Android device.
            </span>
          </h2>
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-400">
            Android allows direct app installations without relying on app stores.
            Follow these 3 easy steps to install Wallet Manager in less than a minute.
          </p>
        </div>

        {/* 3 Step Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
          {steps.map((step) => (
            <div
              key={step.num}
              className="relative p-8 rounded-3xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-sm flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between mb-6">
                  <span className="text-3xl font-black bg-gradient-to-r from-coral-500 to-warmOrange-500 bg-clip-text text-transparent">
                    {step.num}
                  </span>
                  <span className="text-[10px] font-bold px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300">
                    {step.actionText}
                  </span>
                </div>
                <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-3">
                  {step.title}
                </h3>
                <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed mb-6">
                  {step.description}
                </p>
              </div>

              <div className="pt-4 border-t border-slate-100 dark:border-slate-800 text-xs font-medium text-slate-500 dark:text-slate-400 flex items-start gap-2 bg-slate-50/70 dark:bg-slate-800/40 p-3 rounded-2xl">
                <HelpCircle className="w-4 h-4 text-coral-500 flex-shrink-0 mt-0.5" />
                <span>{step.tip}</span>
              </div>
            </div>
          ))}
        </div>

        {/* Action CTA Bar */}
        <div className="text-center">
          <a
            href={apkUrl}
            onClick={() => triggerDownloadConfetti()}
            className="inline-flex items-center gap-3 px-8 py-4 rounded-2xl bg-gradient-to-r from-coral-500 to-warmOrange-500 hover:from-coral-600 hover:to-warmOrange-600 text-white font-extrabold text-base shadow-xl hover:shadow-2xl hover:scale-105 active:scale-98 transition-all duration-200"
          >
            <Download className="w-5 h-5" />
            <span>Download Android APK ({tagName} • {apkSizeMb})</span>
          </a>
        </div>

      </div>
    </section>
  );
}
