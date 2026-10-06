"use client";

import {
  ShieldAlert,
  Fingerprint,
  KeyRound,
  EyeOff,
  Radio,
  FileCheck,
  CheckCircle2,
  Lock,
} from "lucide-react";

export default function SecuritySection() {
  const securityPillars = [
    {
      icon: Fingerprint,
      title: "Biometric & 4-Digit Passcode",
      description:
        "Protect your financial logs from prying eyes. Enable instant Fingerprint, Face Unlock, or a 4-digit security PIN whenever the app opens.",
      badge: "Instant Authentication",
      color: "from-coral-500 to-warmOrange-500",
    },
    {
      icon: EyeOff,
      title: "Zero Bank SMS Scraping",
      description:
        "We never request SMS or Contact permissions. Your bank alerts, OTPs, and personal communications stay completely private on your device.",
      badge: "Zero Intrusive Permissions",
      color: "from-amber-500 to-orange-500",
    },
    {
      icon: Radio,
      title: "Zero Ads & Zero Telemetry",
      description:
        "No ad SDKs, no behavioral trackers, and no background analytics pinging third-party data brokers. Clean, fast, battery-efficient operation.",
      badge: "No Google / Meta Pixel",
      color: "from-blue-500 to-indigo-500",
    },
    {
      icon: FileCheck,
      title: "Open-Source & Verifiable",
      description:
        "Every single line of Flutter and Dart code is published open-source on GitHub. Audit the source code yourself with complete transparency.",
      badge: "MIT / Open-Source",
      color: "from-emerald-500 to-teal-500",
    },
  ];

  return (
    <section id="security" className="py-24 bg-white dark:bg-[#070A0F] relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Heading */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 text-xs font-bold uppercase tracking-wider mb-4 border border-emerald-500/20">
            <Lock className="w-3.5 h-3.5" />
            Security & Privacy by Design
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight mb-4">
            Your personal wealth is{" "}
            <span className="bg-gradient-to-r from-emerald-500 to-teal-500 bg-clip-text text-transparent">
              nobody else&apos;s business.
            </span>
          </h2>
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-400">
            Unlike venture-backed apps that monetize your transaction data, Wallet Manager
            is built on the core principle that financial data must remain strictly confidential.
          </p>
        </div>

        {/* 4 Security Pillars Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-16">
          {securityPillars.map((pillar) => {
            const Icon = pillar.icon;
            return (
              <div
                key={pillar.title}
                className="p-8 rounded-3xl bg-[#FAFAFC] dark:bg-slate-900/60 border border-slate-200/80 dark:border-slate-800 shadow-sm hover:shadow-md transition-shadow"
              >
                <div className="flex items-center justify-between mb-6">
                  <div
                    className={`w-12 h-12 rounded-2xl bg-gradient-to-tr ${pillar.color} flex items-center justify-center text-white shadow-sm`}
                  >
                    <Icon className="w-6 h-6" />
                  </div>
                  <span className="text-[11px] font-bold px-3 py-1 rounded-full bg-slate-200/80 dark:bg-slate-800 text-slate-700 dark:text-slate-300">
                    {pillar.badge}
                  </span>
                </div>
                <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-2">
                  {pillar.title}
                </h3>
                <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed">
                  {pillar.description}
                </p>
              </div>
            );
          })}
        </div>

      </div>
    </section>
  );
}
