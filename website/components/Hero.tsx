"use client";

import { useState } from "react";
import {
  Download,
  ShieldCheck,
  Cloud,
  Sparkles,
  ArrowRight,
  CheckCircle2,
  Lock,
  Smartphone,
  Calendar,
  Camera,
  Layers,
  PieChart,
  CreditCard,
  Sliders,
  Plus,
  RefreshCw,
  ExternalLink,
} from "lucide-react";
import { GithubIcon } from "@/components/icons/GithubIcon";
import { useGitHubRelease } from "@/hooks/useGitHubRelease";
import { triggerDownloadConfetti } from "@/lib/confetti";

export default function Hero() {
  const { tagName, apkUrl, apkSizeMb, totalDownloads, publishedAt, isFallback } =
    useGitHubRelease();
  const [copied, setCopied] = useState(false);

  const handleDownload = () => {
    triggerDownloadConfetti();
  };

  return (
    <section className="relative overflow-hidden pt-28 pb-20 lg:pt-36 lg:pb-32 bg-gradient-to-br from-[#FF5E57] via-[#FF6D48] to-[#FF7A45] text-white">
      {/* Background Decorative Mesh & Glows */}
      <div className="absolute inset-0 pointer-events-none opacity-20">
        <div className="absolute -top-40 -left-40 w-96 h-96 rounded-full bg-white blur-3xl" />
        <div className="absolute top-1/2 -right-40 w-96 h-96 rounded-full bg-amber-300 blur-3xl" />
        <div
          className="absolute inset-0"
          style={{
            backgroundImage:
              "radial-gradient(circle at 1px 1px, rgba(255,255,255,0.15) 1px, transparent 0)",
            backgroundSize: "32px 32px",
          }}
        />
      </div>

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
          
          {/* Left Column: Headlines & High-Converting CTAs */}
          <div className="lg:col-span-7 flex flex-col items-center lg:items-start text-center lg:text-left">
            
            {/* Version & Release Tag Pill */}
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/15 backdrop-blur-md border border-white/25 text-xs font-semibold text-white mb-6 shadow-sm">
              <span className="flex h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
              <span>Latest Android Release:</span>
              <span className="bg-white text-coral-600 font-bold px-2 py-0.5 rounded-full text-[11px]">
                {tagName}
              </span>
              <span className="text-white/80 hidden sm:inline">• {apkSizeMb}</span>
            </div>

            {/* Main Headline */}
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight leading-[1.12] mb-6 text-white">
              The easiest way to manage{" "}
              <span className="text-amber-200 underline decoration-white/40 underline-offset-8">
                personal finances.
              </span>
            </h1>

            {/* Subheadline */}
            <p className="text-lg sm:text-xl text-white/95 leading-relaxed max-w-2xl mb-8 font-normal">
              Double-entry bookkeeping, visual charts, receipt photo storage, and
              encrypted Google Drive auto-sync. Completely offline-first and 100%
              private — built for total peace of mind.
            </p>

            {/* Trust Badges Trio */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 w-full max-w-xl mb-9">
              <div className="flex items-center gap-2.5 px-3 py-2.5 rounded-xl bg-white/10 backdrop-blur-sm border border-white/15 text-left">
                <ShieldCheck className="w-5 h-5 text-emerald-300 flex-shrink-0" />
                <div className="text-xs">
                  <div className="font-bold text-white">100% Private</div>
                  <div className="text-white/80 text-[11px]">No Ads • No SMS Reading</div>
                </div>
              </div>

              <div className="flex items-center gap-2.5 px-3 py-2.5 rounded-xl bg-white/10 backdrop-blur-sm border border-white/15 text-left">
                <Cloud className="w-5 h-5 text-sky-300 flex-shrink-0" />
                <div className="text-xs">
                  <div className="font-bold text-white">Google Drive Sync</div>
                  <div className="text-white/80 text-[11px]">Encrypted Hidden Folder</div>
                </div>
              </div>

              <div className="flex items-center gap-2.5 px-3 py-2.5 rounded-xl bg-white/10 backdrop-blur-sm border border-white/15 text-left">
                <RefreshCw className="w-5 h-5 text-amber-300 flex-shrink-0" />
                <div className="text-xs">
                  <div className="font-bold text-white">Instant OTA Updates</div>
                  <div className="text-white/80 text-[11px]">Never Lose Local Data</div>
                </div>
              </div>
            </div>

            {/* Primary Action Buttons */}
            <div className="flex flex-col sm:flex-row items-center gap-4 w-full sm:w-auto mb-6">
              {/* Direct APK Download CTA */}
              <a
                href={apkUrl}
                onClick={handleDownload}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-3 px-8 py-4 rounded-2xl bg-white text-coral-600 font-extrabold text-base shadow-xl hover:shadow-2xl hover:scale-105 active:scale-98 transition-all duration-200 group"
                id="hero-download-btn"
              >
                <div className="w-8 h-8 rounded-xl bg-coral-50 flex items-center justify-center text-coral-500 group-hover:scale-110 transition-transform">
                  <Download className="w-5 h-5" />
                </div>
                <div className="text-left">
                  <div className="flex items-center gap-1.5 leading-tight">
                    <span>Download Android APK</span>
                    <span className="text-[10px] bg-coral-500 text-white font-bold px-1.5 py-0.5 rounded">
                      DIRECT
                    </span>
                  </div>
                  <div className="text-[11px] text-slate-500 font-medium">
                    {tagName} • {apkSizeMb} • Android 7.0+
                  </div>
                </div>
              </a>

              {/* GitHub Button */}
              <a
                href="https://github.com/iamkamleshmali/wallet-manager-km"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2.5 px-6 py-4 rounded-2xl bg-black/20 hover:bg-black/30 backdrop-blur-sm border border-white/20 text-white font-bold text-sm transition-all hover:scale-102"
              >
                <GithubIcon className="w-5 h-5" />
                <span>View on GitHub</span>
              </a>

              {/* Play Store (Coming Soon) */}
              <div className="hidden sm:inline-flex items-center gap-2 px-4 py-3 rounded-2xl bg-white/10 border border-white/15 text-xs text-white/90">
                <span className="text-[14px]">📱</span>
                <div className="text-left leading-tight">
                  <div className="font-semibold">Google Play</div>
                  <span className="text-[10px] text-amber-200 uppercase tracking-wider font-bold">
                    Coming Soon
                  </span>
                </div>
              </div>
            </div>

            {/* Live Counter & Release Note Snippet */}
            <div className="flex flex-wrap items-center justify-center lg:justify-start gap-4 text-xs text-white/80">
              <span className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-300" />
                Over {totalDownloads.toLocaleString()}+ verified downloads
              </span>
              <span className="hidden sm:inline">•</span>
              <span>Updated: {publishedAt}</span>
              <span className="hidden sm:inline">•</span>
              <a
                href="#install"
                className="underline hover:text-white transition-colors flex items-center gap-1"
              >
                APK Install Guide <ArrowRight className="w-3 h-3" />
              </a>
            </div>

          </div>

          {/* Right Column: Realistic 3D Mobile Showcase Mockup */}
          <div className="lg:col-span-5 flex justify-center relative">
            
            {/* Ambient Background Glow behind phone */}
            <div className="absolute inset-0 bg-coral-400/40 rounded-full blur-3xl transform scale-90" />

            {/* Floating Trust Pill 1: Top Left */}
            <div className="absolute -top-4 -left-6 z-20 hidden sm:flex items-center gap-2 px-3.5 py-2 rounded-xl bg-white dark:bg-slate-900 text-slate-800 dark:text-slate-100 shadow-xl border border-slate-100 dark:border-slate-800 text-xs font-bold animate-float-slow">
              <div className="w-6 h-6 rounded-full bg-emerald-500/20 text-emerald-600 flex items-center justify-center">
                ✓
              </div>
              <div>
                <div>Encrypted Drive Sync</div>
                <div className="text-[10px] text-slate-400 font-normal">Isolated AppData scope</div>
              </div>
            </div>

            {/* Floating Trust Pill 2: Bottom Right */}
            <div className="absolute -bottom-6 -right-6 z-20 hidden sm:flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl bg-white dark:bg-slate-900 text-slate-800 dark:text-slate-100 shadow-xl border border-slate-100 dark:border-slate-800 text-xs font-bold animate-float-reverse">
              <div className="w-7 h-7 rounded-lg bg-coral-500 text-white flex items-center justify-center text-xs">
                ₹
              </div>
              <div>
                <div className="text-slate-900 dark:text-white font-extrabold">Net Worth: ₹2,71,150</div>
                <div className="text-[10px] text-emerald-600 dark:text-emerald-400 font-semibold">+18.4% this month</div>
              </div>
            </div>

            {/* Smartphone Chassis Frame */}
            <div className="relative z-10 w-[300px] sm:w-[325px] rounded-[44px] p-3.5 bg-slate-950 shadow-phone border-4 border-slate-800">
              
              {/* Dynamic Island / Speaker Punch */}
              <div className="absolute top-6 left-1/2 -translate-x-1/2 w-24 h-4 bg-slate-900 rounded-full z-30 flex items-center justify-center">
                <div className="w-2.5 h-2.5 rounded-full bg-slate-950 mr-2" />
                <div className="w-1.5 h-1.5 rounded-full bg-slate-800" />
              </div>

              {/* Inner Smartphone Screen Display */}
              <div className="relative rounded-[36px] overflow-hidden bg-[#FAFAFC] dark:bg-[#0F172A] text-slate-900 dark:text-white shadow-inner flex flex-col h-[600px] select-none">
                
                {/* Status Bar */}
                <div className="h-9 px-6 pt-2 flex items-center justify-between text-[11px] font-bold text-slate-600 dark:text-slate-300 z-20">
                  <span>9:41</span>
                  <div className="flex items-center gap-1.5 text-[10px]">
                    <span>5G</span>
                    <div className="w-4 h-2.5 border border-current rounded-sm p-0.5 flex items-center">
                      <div className="w-full h-full bg-current rounded-xs" />
                    </div>
                  </div>
                </div>

                {/* Money Manager Top Header Bar */}
                <div className="bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white px-4 pt-3 pb-3 shadow-md">
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-1.5">
                      <Calendar className="w-4 h-4 text-white/90" />
                      <span className="font-extrabold text-sm">October 2026</span>
                    </div>
                    <span className="text-[11px] font-semibold bg-white/20 px-2 py-0.5 rounded-full">
                      Ledger
                    </span>
                  </div>

                  {/* Summary 3 Columns: Income | Expense | Balance */}
                  <div className="grid grid-cols-3 gap-2 pt-2 border-t border-white/20 text-center">
                    <div>
                      <div className="text-[10px] text-white/80 font-medium">Income</div>
                      <div className="text-xs font-bold text-emerald-200">+₹85,400</div>
                    </div>
                    <div>
                      <div className="text-[10px] text-white/80 font-medium">Expenses</div>
                      <div className="text-xs font-bold text-white">-₹28,650</div>
                    </div>
                    <div>
                      <div className="text-[10px] text-white/80 font-medium">Balance</div>
                      <div className="text-xs font-bold text-amber-200">₹56,750</div>
                    </div>
                  </div>
                </div>

                {/* Subnav Tabs: Daily | Calendar | Weekly | Monthly */}
                <div className="flex items-center justify-around bg-white dark:bg-slate-900 border-b border-slate-100 dark:border-slate-800 text-[11px] font-bold py-2 px-2 text-slate-500 dark:text-slate-400">
                  <span className="text-coral-500 border-b-2 border-coral-500 pb-1">Daily</span>
                  <span>Calendar</span>
                  <span>Weekly</span>
                  <span>Monthly</span>
                  <span>Total</span>
                </div>

                {/* Transaction Feed (Daily View) */}
                <div className="flex-1 overflow-y-auto p-3 space-y-3">
                  
                  {/* Date Header: Today */}
                  <div className="flex items-center justify-between text-[11px] font-bold text-slate-500 dark:text-slate-400 px-1">
                    <span>02 Friday</span>
                    <div className="flex gap-2">
                      <span className="text-emerald-600 dark:text-emerald-400">+₹75,000</span>
                      <span className="text-coral-500">-₹4,189</span>
                    </div>
                  </div>

                  {/* Transaction 1: Tech Salary */}
                  <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 shadow-sm border border-slate-100 dark:border-slate-800/80">
                    <div className="flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-lg bg-emerald-50 dark:bg-emerald-950/40 text-emerald-600 flex items-center justify-center text-xs font-bold">
                        💼
                      </div>
                      <div>
                        <div className="text-xs font-bold text-slate-900 dark:text-white">Tech Salary</div>
                        <div className="text-[10px] text-slate-400">HDFC Bank UPI • Monthly Salary</div>
                      </div>
                    </div>
                    <span className="text-xs font-extrabold text-emerald-600 dark:text-emerald-400">
                      +₹75,000
                    </span>
                  </div>

                  {/* Transaction 2: Starbucks Coffee */}
                  <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 shadow-sm border border-slate-100 dark:border-slate-800/80">
                    <div className="flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-lg bg-coral-50 dark:bg-coral-950/40 text-coral-500 flex items-center justify-center text-xs font-bold">
                        ☕
                      </div>
                      <div>
                        <div className="text-xs font-bold text-slate-900 dark:text-white">Starbucks Brew</div>
                        <div className="text-[10px] text-slate-400">Cash in Hand • Food & Drinks</div>
                      </div>
                    </div>
                    <span className="text-xs font-extrabold text-coral-500">
                      -₹350
                    </span>
                  </div>

                  {/* Transaction 3: Supermarket Grocery (with photo badge) */}
                  <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 shadow-sm border border-slate-100 dark:border-slate-800/80">
                    <div className="flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-lg bg-amber-50 dark:bg-amber-950/40 text-amber-500 flex items-center justify-center text-xs font-bold">
                        🛒
                      </div>
                      <div>
                        <div className="flex items-center gap-1.5">
                          <span className="text-xs font-bold text-slate-900 dark:text-white">Groceries</span>
                          <span className="flex items-center text-[9px] bg-slate-100 dark:bg-slate-800 text-slate-500 px-1 rounded">
                            <Camera className="w-2.5 h-2.5 mr-0.5" /> Receipt
                          </span>
                        </div>
                        <div className="text-[10px] text-slate-400">ICICI Credit Card • Provisions</div>
                      </div>
                    </div>
                    <span className="text-xs font-extrabold text-coral-500">
                      -₹2,840
                    </span>
                  </div>

                  {/* Transaction 4: WiFi Broadband */}
                  <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 shadow-sm border border-slate-100 dark:border-slate-800/80">
                    <div className="flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-lg bg-sky-50 dark:bg-sky-950/40 text-sky-500 flex items-center justify-center text-xs font-bold">
                        📡
                      </div>
                      <div>
                        <div className="text-xs font-bold text-slate-900 dark:text-white">Fiber Broadband</div>
                        <div className="text-[10px] text-slate-400">Bank UPI • Utilities</div>
                      </div>
                    </div>
                    <span className="text-xs font-extrabold text-coral-500">
                      -₹999
                    </span>
                  </div>

                </div>

                {/* Floating Add Expense Button */}
                <div className="absolute bottom-16 right-5">
                  <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-coral-500 to-warmOrange-500 text-white flex items-center justify-center shadow-lg shadow-coral-500/40 cursor-pointer hover:scale-105 transition-transform">
                    <Plus className="w-6 h-6 stroke-[2.5]" />
                  </div>
                </div>

                {/* Bottom App Navigation Bar */}
                <div className="h-14 bg-white dark:bg-slate-900 border-t border-slate-100 dark:border-slate-800 flex items-center justify-around px-2 text-[10px] font-semibold text-slate-400">
                  <div className="flex flex-col items-center text-coral-500">
                    <Layers className="w-4 h-4 mb-0.5" />
                    <span>Trans</span>
                  </div>
                  <div className="flex flex-col items-center hover:text-slate-600 dark:hover:text-slate-200">
                    <PieChart className="w-4 h-4 mb-0.5" />
                    <span>Stats</span>
                  </div>
                  <div className="flex flex-col items-center hover:text-slate-600 dark:hover:text-slate-200">
                    <CreditCard className="w-4 h-4 mb-0.5" />
                    <span>Accounts</span>
                  </div>
                  <div className="flex flex-col items-center hover:text-slate-600 dark:hover:text-slate-200">
                    <Sliders className="w-4 h-4 mb-0.5" />
                    <span>Settings</span>
                  </div>
                </div>

              </div>
            </div>

          </div>

        </div>
      </div>
    </section>
  );
}
