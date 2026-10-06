"use client";

import {
  CalendarDays,
  Camera,
  Search,
  PieChart,
  Scale,
  RefreshCw,
  ArrowUpRight,
  Receipt,
  FileSpreadsheet,
  Check,
  TrendingUp,
  CreditCard,
  Sparkles,
} from "lucide-react";

export default function FeatureGrid() {
  const features = [
    {
      id: "easy-access",
      icon: CalendarDays,
      badge: "Fast Navigation",
      title: "Easy Content Access",
      description:
        "Switch seamlessly between Daily, Calendar, Weekly, Monthly, and Total balance summaries. See instant net income versus expenditure at a glance.",
      highlight: "Calendar date-picker with day-by-day expense totals",
      color: "from-coral-500 to-warmOrange-500",
      accent: "coral",
      metric: "5 Flexible Views",
    },
    {
      id: "photo-save",
      icon: Camera,
      badge: "Receipt Archive",
      title: "Photo Save & Receipts",
      description:
        "Snap photos of purchase receipts, bills, and tax invoices directly when logging expenses. Preserved with offline on-device image compression.",
      highlight: "High-resolution local storage with zero cloud leaks",
      color: "from-amber-500 to-orange-500",
      accent: "amber",
      metric: "0 Quality Loss",
    },
    {
      id: "filter-search",
      icon: Search,
      badge: "Smart Filter",
      title: "Reinforced Filter & Search",
      description:
        "Instantly filter transactions by account (Cash in Hand, Bank UPI, Credit Cards) or custom categories. Find any past transaction in milliseconds.",
      highlight: "Multi-parameter filter with tag & note substring search",
      color: "from-blue-500 to-indigo-500",
      accent: "blue",
      metric: "<10ms Query Speed",
    },
    {
      id: "improved-charts",
      icon: PieChart,
      badge: "Visual Analytics",
      title: "Aesthetically Improved Charts",
      description:
        "Visualize your financial habits with fluid interactive donut charts, category percentage rankings, and 6-month net worth growth trajectories.",
      highlight: "Dynamic category breakdown with drill-down exploration",
      color: "from-emerald-500 to-teal-500",
      accent: "emerald",
      metric: "Donut & Trend Graphs",
    },
    {
      id: "double-entry",
      icon: Scale,
      badge: "Accurate Accounting",
      title: "Double-Entry Bookkeeping",
      description:
        "Professional double-entry ledger that tracks true assets, liabilities, and transfers. Debit your bank account when paying off credit cards without false expenses.",
      highlight: "Authentic Assets vs Liabilities balancing",
      color: "from-purple-500 to-indigo-500",
      accent: "purple",
      metric: "100% Ledger Balance",
    },
    {
      id: "auto-update",
      icon: RefreshCw,
      badge: "OTA Convenience",
      title: "In-App Auto-Update",
      description:
        "Never worry about manually hunting for new APKs. Wallet Manager automatically detects GitHub releases and downloads updates while keeping your SQLite database intact.",
      highlight: "Non-destructive in-place APK upgrade engine",
      color: "from-rose-500 to-coral-500",
      accent: "rose",
      metric: "1-Tap In-App Update",
    },
  ];

  return (
    <section id="features" className="py-24 bg-[#FAFAFC] dark:bg-[#0B0F17] relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-coral-500/10 text-coral-600 dark:text-coral-400 text-xs font-bold uppercase tracking-wider mb-4 border border-coral-500/20">
            <Sparkles className="w-3.5 h-3.5" />
            Designed for Real Daily Life
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight mb-4">
            Everything you need for{" "}
            <span className="bg-gradient-to-r from-coral-500 to-warmOrange-500 bg-clip-text text-transparent">
              complete financial control.
            </span>
          </h2>
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-400">
            Inspired by the clean simplicity of classic bookkeeping apps,
            re-engineered for modern Android with zero ads and zero surveillance.
          </p>
        </div>

        {/* 6 Feature Grid Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
          {features.map((feature) => {
            const Icon = feature.icon;
            return (
              <div
                key={feature.id}
                className="group relative rounded-3xl p-7 bg-white dark:bg-slate-900/80 border border-slate-200/80 dark:border-slate-800 hover:border-coral-500/40 dark:hover:border-coral-500/40 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between"
              >
                <div>
                  {/* Top Bar with Icon & Badge */}
                  <div className="flex items-center justify-between mb-5">
                    <div
                      className={`w-12 h-12 rounded-2xl bg-gradient-to-tr ${feature.color} flex items-center justify-center text-white shadow-md group-hover:scale-110 transition-transform duration-200`}
                    >
                      <Icon className="w-6 h-6" />
                    </div>
                    <span className="text-[11px] font-bold px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300">
                      {feature.badge}
                    </span>
                  </div>

                  {/* Title & Description */}
                  <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-2 group-hover:text-coral-500 transition-colors">
                    {feature.title}
                  </h3>
                  <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed mb-6">
                    {feature.description}
                  </p>
                </div>

                {/* Bottom Highlight Strip */}
                <div className="pt-4 border-t border-slate-100 dark:border-slate-800/80 flex items-center justify-between text-xs">
                  <span className="flex items-center gap-1.5 font-medium text-slate-500 dark:text-slate-400">
                    <Check className="w-3.5 h-3.5 text-coral-500" />
                    {feature.highlight}
                  </span>
                  <span className="font-extrabold text-coral-600 dark:text-coral-400">
                    {feature.metric}
                  </span>
                </div>
              </div>
            );
          })}
        </div>

        {/* Bottom Callout Banner */}
        <div className="mt-14 p-6 sm:p-8 rounded-3xl bg-gradient-to-r from-coral-500/10 via-warmOrange-500/10 to-amber-500/10 border border-coral-500/20 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-coral-500 to-warmOrange-500 text-white flex items-center justify-center font-bold text-xl flex-shrink-0 shadow-glow-coral">
              ₹
            </div>
            <div>
              <div className="font-extrabold text-slate-900 dark:text-white text-lg">
                Excel & CSV Export / Import Supported
              </div>
              <div className="text-xs text-slate-600 dark:text-slate-400">
                Generate clean financial statements, tax reports, and local backup dumps anytime.
              </div>
            </div>
          </div>
          <a
            href="#screenshots"
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-coral-500 hover:bg-coral-600 text-white font-bold text-xs shadow-md transition-all flex-shrink-0"
          >
            <span>See App Screenshots</span>
            <ArrowUpRight className="w-4 h-4" />
          </a>
        </div>

      </div>
    </section>
  );
}
