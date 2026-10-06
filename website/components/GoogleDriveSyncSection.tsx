"use client";

import {
  Cloud,
  Lock,
  Database,
  ArrowRight,
  ShieldCheck,
  CheckCircle2,
  HardDrive,
  FileKey,
  Smartphone,
  FolderGit2,
  ServerOff,
} from "lucide-react";

export default function GoogleDriveSyncSection() {
  return (
    <section id="sync" className="py-24 bg-[#FAFAFC] dark:bg-[#0B0F17] relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Heading */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-sky-500/10 text-sky-600 dark:text-sky-400 text-xs font-bold uppercase tracking-wider mb-4 border border-sky-500/20">
            <Cloud className="w-3.5 h-3.5" />
            WhatsApp-Style Private Backup
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight mb-4">
            Encrypted Google Drive Sync.{" "}
            <span className="text-sky-500">Zero Middleman Servers.</span>
          </h2>
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-400">
            Most finance apps store your bank details on their corporate cloud servers.
            Wallet Manager connects directly to your personal Google Drive using the
            isolated <code className="font-mono text-xs bg-slate-200 dark:bg-slate-800 px-1.5 py-0.5 rounded">drive.appdata</code> sandbox.
          </p>
        </div>

        {/* 3 Step Visual Architecture Diagram */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          
          {/* Node 1 */}
          <div className="p-8 rounded-3xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 shadow-sm relative">
            <div className="w-12 h-12 rounded-2xl bg-coral-500/10 text-coral-600 dark:text-coral-400 flex items-center justify-center mb-6">
              <Database className="w-6 h-6" />
            </div>
            <div className="text-xs font-bold uppercase tracking-wider text-coral-600 mb-1">
              Step 01 • Local Device
            </div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-2">
              High-Speed SQLite Database
            </h3>
            <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed mb-4">
              All transactions, categories, and accounts are written instantly to an
              offline SQLite database stored securely inside your phone&apos;s sandboxed app directory.
            </p>
            <div className="text-xs font-semibold text-slate-500 dark:text-slate-400 flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4 text-emerald-500" />
              <span>100% Offline read/write latency</span>
            </div>
          </div>

          {/* Node 2 */}
          <div className="p-8 rounded-3xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 shadow-sm relative">
            <div className="w-12 h-12 rounded-2xl bg-amber-500/10 text-amber-600 dark:text-amber-400 flex items-center justify-center mb-6">
              <FileKey className="w-6 h-6" />
            </div>
            <div className="text-xs font-bold uppercase tracking-wider text-amber-600 mb-1">
              Step 02 • Client Encryption
            </div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-2">
              Encrypted Backup Packaging
            </h3>
            <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed mb-4">
              When syncing or scheduling auto-backups, your SQLite database and receipt photos
              are packaged and encrypted before transmission.
            </p>
            <div className="text-xs font-semibold text-slate-500 dark:text-slate-400 flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4 text-emerald-500" />
              <span>Zero cleartext data over the wire</span>
            </div>
          </div>

          {/* Node 3 */}
          <div className="p-8 rounded-3xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 shadow-sm relative">
            <div className="w-12 h-12 rounded-2xl bg-sky-500/10 text-sky-600 dark:text-sky-400 flex items-center justify-center mb-6">
              <Cloud className="w-6 h-6" />
            </div>
            <div className="text-xs font-bold uppercase tracking-wider text-sky-600 mb-1">
              Step 03 • Private Cloud
            </div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-2">
              Google Drive AppData Folder
            </h3>
            <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed mb-4">
              Uploaded directly into your personal Google Drive&apos;s hidden app-specific folder.
              Other apps, files, or third-party servers cannot read or touch it.
            </p>
            <div className="text-xs font-semibold text-slate-500 dark:text-slate-400 flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4 text-emerald-500" />
              <span>1-tap restore on any new phone</span>
            </div>
          </div>

        </div>

        {/* Feature Comparison Box: Traditional Cloud vs Wallet Manager */}
        <div className="rounded-3xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-8 sm:p-10 shadow-sm">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
            <div>
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 text-xs font-bold mb-4">
                <ServerOff className="w-3.5 h-3.5" />
                Zero Company Servers
              </div>
              <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mb-4">
                Why does this matter for your privacy?
              </h3>
              <p className="text-slate-600 dark:text-slate-400 text-sm sm:text-base leading-relaxed mb-6">
                Commercial finance apps monetize by harvesting your transaction history,
                reading bank OTP SMS messages, and selling anonymized spending patterns
                to loan brokers. Wallet Manager runs 100% locally on your phone.
              </p>
              <div className="space-y-3">
                <div className="flex items-center gap-3 text-sm font-semibold text-slate-800 dark:text-slate-200">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 dark:bg-emerald-950 text-emerald-600 flex items-center justify-center text-xs">
                    ✓
                  </span>
                  <span>No account creation required — start in 3 seconds</span>
                </div>
                <div className="flex items-center gap-3 text-sm font-semibold text-slate-800 dark:text-slate-200">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 dark:bg-emerald-950 text-emerald-600 flex items-center justify-center text-xs">
                    ✓
                  </span>
                  <span>No bank credentials or SMS permissions ever requested</span>
                </div>
                <div className="flex items-center gap-3 text-sm font-semibold text-slate-800 dark:text-slate-200">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 dark:bg-emerald-950 text-emerald-600 flex items-center justify-center text-xs">
                    ✓
                  </span>
                  <span>Full database export to standard CSV & JSON anytime</span>
                </div>
              </div>
            </div>

            {/* Visual Box */}
            <div className="p-6 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200/80 dark:border-slate-700/80">
              <div className="text-xs font-extrabold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-4">
                Live Data Security Flow
              </div>
              <div className="space-y-4">
                <div className="flex items-center justify-between p-3.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                  <div className="flex items-center gap-3">
                    <Smartphone className="w-5 h-5 text-coral-500" />
                    <div>
                      <div className="text-xs font-bold text-slate-900 dark:text-white">Local Device</div>
                      <div className="text-[10px] text-slate-400">Offline SQLite DB</div>
                    </div>
                  </div>
                  <span className="text-[11px] font-bold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 px-2 py-0.5 rounded-md">
                    Direct
                  </span>
                </div>

                <div className="flex justify-center text-slate-400">
                  <ArrowRight className="w-4 h-4 rotate-90" />
                </div>

                <div className="flex items-center justify-between p-3.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                  <div className="flex items-center gap-3">
                    <Cloud className="w-5 h-5 text-sky-500" />
                    <div>
                      <div className="text-xs font-bold text-slate-900 dark:text-white">Your Personal Google Drive</div>
                      <div className="text-[10px] text-slate-400">Isolated AppData Folder</div>
                    </div>
                  </div>
                  <span className="text-[11px] font-bold text-sky-600 dark:text-sky-400 bg-sky-50 dark:bg-sky-950/40 px-2 py-0.5 rounded-md">
                    Encrypted
                  </span>
                </div>
              </div>
            </div>

          </div>
        </div>

      </div>
    </section>
  );
}
