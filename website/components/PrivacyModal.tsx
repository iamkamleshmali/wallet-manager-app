"use client";

import { X, ShieldCheck, Lock, Database } from "lucide-react";

interface PrivacyModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function PrivacyModal({ isOpen, onClose }: PrivacyModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="relative w-full max-w-2xl max-h-[85vh] overflow-y-auto rounded-3xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-6 sm:p-8 shadow-2xl text-slate-800 dark:text-slate-100">
        
        {/* Header */}
        <div className="flex items-center justify-between pb-4 border-b border-slate-200 dark:border-slate-800 mb-6">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center">
              <ShieldCheck className="w-5 h-5" />
            </div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white">
              Privacy Policy
            </h3>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content */}
        <div className="space-y-4 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          <p className="font-semibold text-slate-900 dark:text-white">
            Last Updated: October 2026
          </p>

          <h4 className="text-base font-bold text-slate-900 dark:text-white pt-2">
            1. Zero Collection of Personal Financial Data
          </h4>
          <p>
            Wallet Manager does not collect, transmit, sell, or analyze your transaction
            records, bank balances, or receipt photographs. Everything is stored locally
            in a private SQLite database on your device.
          </p>

          <h4 className="text-base font-bold text-slate-900 dark:text-white pt-2">
            2. Google Drive AppData Synchronization
          </h4>
          <p>
            If you enable Google Drive sync, the app interacts directly with your Google account
            using the official <code className="font-mono text-xs bg-slate-100 dark:bg-slate-800 px-1 py-0.5 rounded">https://www.googleapis.com/auth/drive.appdata</code> scope.
            Backups are stored in your hidden Google Drive application folder and cannot be accessed by any third party.
          </p>

          <h4 className="text-base font-bold text-slate-900 dark:text-white pt-2">
            3. Permissions Usage
          </h4>
          <p>
            • <strong>Storage / Media:</strong> Used solely to allow you to attach receipt photos from your camera or gallery to expense logs.
            <br />
            • <strong>Biometrics:</strong> Used exclusively via Android BiometricPrompt to unlock the app locally.
            <br />
            • <strong>No SMS Permissions:</strong> We never request access to your SMS inbox or bank text alerts.
          </p>

          <h4 className="text-base font-bold text-slate-900 dark:text-white pt-2">
            4. Open-Source Transparency
          </h4>
          <p>
            The complete source code is public on GitHub under the repository <code className="font-mono text-xs bg-slate-100 dark:bg-slate-800 px-1 py-0.5 rounded">iamkamleshmali/wallet-manager-km</code> for community audit.
          </p>
        </div>

        {/* Footer */}
        <div className="mt-8 pt-4 border-t border-slate-200 dark:border-slate-800 flex justify-end">
          <button
            onClick={onClose}
            className="px-6 py-2.5 rounded-xl bg-coral-500 hover:bg-coral-600 text-white font-bold text-xs transition-colors"
          >
            I Understand
          </button>
        </div>

      </div>
    </div>
  );
}
