"use client";

import { useState } from "react";
import { ChevronDown, HelpCircle, Sparkles } from "lucide-react";

export default function FaqSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  const faqs = [
    {
      question: "How do I install the APK on my Android phone?",
      answer:
        "Tap the 'Download Android APK' button on this page. Once the download finishes, tap the notification or open your Downloads folder. If Android displays a prompt saying 'Install unknown apps', tap 'Settings' on the popup, toggle on 'Allow from this source', and then tap 'Install'. It takes under 30 seconds!",
    },
    {
      question: "Will my old data or transactions be lost when updating to a new APK version?",
      answer:
        "No, absolutely not! Android installs APK updates on top of existing applications without touching the internal SQLite database or stored receipt images. Furthermore, the in-app auto-update feature automatically installs official updates safely while keeping your full transaction ledger intact.",
    },
    {
      question: "How does Google Drive backup & restore work?",
      answer:
        "Wallet Manager uses Google's official 'drive.appdata' sandbox scope. When you tap 'Sync Now' or enable auto-sync, your SQLite database and compressed receipt photos are encrypted and uploaded into your personal Google Drive account. When switching to a new phone, simply sign in with the same Google account and tap 'Restore from Drive' to regain all your data.",
    },
    {
      question: "Why is Wallet Manager 100% free with zero ads?",
      answer:
        "Wallet Manager was created by Kamlesh Mali as an offline-first, privacy-respecting alternative to commercial finance apps that bombard users with loan advertisements and harvest bank statements. It is fully open-source on GitHub, built with passion for the developer and privacy communities.",
    },
    {
      question: "Does Wallet Manager read my SMS messages or bank OTPs?",
      answer:
        "Never. Wallet Manager does not request READ_SMS, RECEIVE_SMS, or READ_CONTACTS permissions. You have 100% manual control over what you record. No third party or algorithm can ever scrape your account balances.",
    },
    {
      question: "Can I export my transactions to Excel or CSV for taxes?",
      answer:
        "Yes! Under Settings > Backup & Export, you can export your entire financial history to clean Excel-compatible CSV files, JSON database dumps, or PDF monthly reports at any time.",
    },
  ];

  const toggleFaq = (index: number) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <section id="faq" className="py-24 bg-white dark:bg-[#070A0F] relative">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Heading */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-coral-500/10 text-coral-600 dark:text-coral-400 text-xs font-bold uppercase tracking-wider mb-4 border border-coral-500/20">
            <HelpCircle className="w-3.5 h-3.5" />
            Frequently Asked Questions
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight mb-4">
            Everything you need to know.
          </h2>
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-400">
            Got questions about installation, updates, or privacy? Here are the answers.
          </p>
        </div>

        {/* Accordion FAQ Items */}
        <div className="space-y-4">
          {faqs.map((faq, index) => {
            const isOpen = openIndex === index;
            return (
              <div
                key={faq.question}
                className="rounded-2xl border border-slate-200/80 dark:border-slate-800 bg-[#FAFAFC] dark:bg-slate-900/60 overflow-hidden transition-colors"
              >
                <button
                  onClick={() => toggleFaq(index)}
                  className="w-full px-6 py-5 text-left flex items-center justify-between gap-4 focus:outline-none cursor-pointer"
                  aria-expanded={isOpen}
                >
                  <span className="font-bold text-base sm:text-lg text-slate-900 dark:text-white">
                    {faq.question}
                  </span>
                  <div
                    className={`w-7 h-7 rounded-full bg-slate-200/60 dark:bg-slate-800 flex items-center justify-center flex-shrink-0 transition-transform duration-200 ${
                      isOpen ? "rotate-180 bg-coral-500 text-white dark:bg-coral-500" : "text-slate-600 dark:text-slate-300"
                    }`}
                  >
                    <ChevronDown className="w-4 h-4" />
                  </div>
                </button>

                {isOpen && (
                  <div className="px-6 pb-5 pt-1 text-sm sm:text-base text-slate-600 dark:text-slate-400 leading-relaxed border-t border-slate-100 dark:border-slate-800/80 animate-in fade-in duration-200">
                    {faq.answer}
                  </div>
                )}
              </div>
            );
          })}
        </div>

      </div>
    </section>
  );
}
