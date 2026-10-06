"use client";

import { useState } from "react";
import {
  Layers,
  PieChart,
  CreditCard,
  Sliders,
  Sun,
  Moon,
  Camera,
  Calendar,
  Plus,
  ArrowDownRight,
  ArrowUpRight,
  CheckCircle2,
  Filter,
  Search,
  Wallet,
  Building,
  Landmark,
  PiggyBank,
  Check,
  Calculator,
  ChevronRight,
} from "lucide-react";

export default function InteractiveShowcase() {
  const [activeTab, setActiveTab] = useState<"trans" | "stats" | "accounts" | "calc">("trans");
  const [mockupDarkMode, setMockupDarkMode] = useState(false);

  const tabs = [
    { id: "trans", name: "Daily Ledger", icon: Layers, label: "Trans" },
    { id: "stats", name: "Pie Chart Stats", icon: PieChart, label: "Stats" },
    { id: "accounts", name: "Accounts Balance Sheet", icon: CreditCard, label: "Accounts" },
    { id: "calc", name: "Settings & CalcBox", icon: Sliders, label: "CalcBox" },
  ];

  return (
    <section id="screenshots" className="py-24 bg-white dark:bg-[#070A0F] relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Heading */}
        <div className="text-center max-w-3xl mx-auto mb-12">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-warmOrange-500/10 text-warmOrange-600 dark:text-warmOrange-400 text-xs font-bold uppercase tracking-wider mb-4 border border-warmOrange-500/20">
            Interactive App Showcase
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight mb-4">
            Built for speed, clarity, and{" "}
            <span className="bg-gradient-to-r from-coral-500 to-warmOrange-500 bg-clip-text text-transparent">
              deep financial insight.
            </span>
          </h2>
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-400">
            Explore the four core app screens below. You can also switch the phone preview between Light and Dark mode to see how crisp it looks at night.
          </p>
        </div>

        {/* Tab Buttons & Theme Toggle Row */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 mb-10 max-w-4xl mx-auto">
          {/* 4 Tabs */}
          <div className="flex flex-wrap items-center justify-center p-1.5 rounded-2xl bg-slate-100 dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id as any)}
                  className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all ${
                    isActive
                      ? "bg-white dark:bg-slate-800 text-coral-600 dark:text-coral-400 shadow-sm"
                      : "text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white"
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  <span>{tab.name}</span>
                </button>
              );
            })}
          </div>

          {/* In-Mockup Theme Toggle Switcher */}
          <button
            onClick={() => setMockupDarkMode(!mockupDarkMode)}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-900 text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors shadow-sm"
          >
            {mockupDarkMode ? (
              <>
                <Sun className="w-4 h-4 text-amber-400" />
                <span>Phone: Dark Mode</span>
              </>
            ) : (
              <>
                <Moon className="w-4 h-4 text-slate-600 dark:text-slate-400" />
                <span>Phone: Light Mode</span>
              </>
            )}
          </button>
        </div>

        {/* Interactive Phone Frame & Explanation Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center max-w-6xl mx-auto">
          
          {/* Left Column: Context Details about Active Tab */}
          <div className="lg:col-span-6 space-y-6 order-2 lg:order-1">
            {activeTab === "trans" && (
              <div className="space-y-4 animate-in fade-in duration-300">
                <span className="text-xs font-bold px-3 py-1 rounded-full bg-coral-50 text-coral-600 border border-coral-200">
                  Core View 01 • Daily Ledger
                </span>
                <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
                  Realtime Daily Ledger with Balance Breakdown
                </h3>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed text-sm sm:text-base">
                  Every entry tracks payment method (Cash, HDFC UPI, Credit Card),
                  photo receipt proof, sub-category tags, and timestamp. The top
                  summary instantly recalculates Income, Expense, and remaining Cash Flow for the month.
                </p>
                <div className="space-y-2.5 pt-2">
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-coral-500" />
                    <span>Quick Month / Date navigation bar</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-coral-500" />
                    <span>Attached receipt photo thumbnail indicator</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-coral-500" />
                    <span>Color-coded green (Income) and coral (Expense)</span>
                  </div>
                </div>
              </div>
            )}

            {activeTab === "stats" && (
              <div className="space-y-4 animate-in fade-in duration-300">
                <span className="text-xs font-bold px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 border border-emerald-200">
                  Core View 02 • Statistics & Analytics
                </span>
                <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
                  Fluid Donut Pie Charts & Category Rankings
                </h3>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed text-sm sm:text-base">
                  See exactly where your money leaks. Wallet Manager categorizes your
                  expenditures into percentage shares and ranks categories by total spend,
                  making it effortless to trim excess expenses.
                </p>
                <div className="space-y-2.5 pt-2">
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                    <span>Interactive slice selection with exact totals</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                    <span>Visual percentage progress bars per category</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                    <span>6-month rolling net worth trend graphs</span>
                  </div>
                </div>
              </div>
            )}

            {activeTab === "accounts" && (
              <div className="space-y-4 animate-in fade-in duration-300">
                <span className="text-xs font-bold px-3 py-1 rounded-full bg-blue-50 text-blue-600 border border-blue-200">
                  Core View 03 • Accounts & Balance Sheet
                </span>
                <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
                  Assets vs Liabilities Double-Entry Tracking
                </h3>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed text-sm sm:text-base">
                  Manage multiple bank accounts, UPI handles, wallets, and credit cards
                  under a single roof. Transfers between accounts don&apos;t skew your expenses,
                  and your true Net Worth is calculated accurately in real time.
                </p>
                <div className="space-y-2.5 pt-2">
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-blue-500" />
                    <span>Separate Asset accounts from Liability credit cards</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-blue-500" />
                    <span>Seamless account transfers with 1-tap logging</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-blue-500" />
                    <span>Live net asset calculation (Assets minus Debts)</span>
                  </div>
                </div>
              </div>
            )}

            {activeTab === "calc" && (
              <div className="space-y-4 animate-in fade-in duration-300">
                <span className="text-xs font-bold px-3 py-1 rounded-full bg-purple-50 text-purple-600 border border-purple-200">
                  Core View 04 • CalcBox & Fast Entry
                </span>
                <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
                  Built-in Numeric CalcBox for Instant Logging
                </h3>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed text-sm sm:text-base">
                  No need to open a separate calculator app when splitting a dining bill or
                  calculating discounts. CalcBox provides arithmetic operators directly
                  inside the expense input keyboard with instant evaluation.
                </p>
                <div className="space-y-2.5 pt-2">
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-purple-500" />
                    <span>Full in-field math (+, -, *, /) calculations</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-purple-500" />
                    <span>Quick category chips with custom icon pickers</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300">
                    <CheckCircle2 className="w-4 h-4 text-purple-500" />
                    <span>1-tap camera shutter to attach receipt photos</span>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Right Column: Smartphone Chassis with Live View Switch */}
          <div className="lg:col-span-6 flex justify-center order-1 lg:order-2">
            <div className="relative w-[310px] sm:w-[335px] rounded-[48px] p-3.5 bg-slate-950 shadow-2xl border-4 border-slate-800">
              
              {/* Dynamic Island */}
              <div className="absolute top-6 left-1/2 -translate-x-1/2 w-24 h-4 bg-slate-900 rounded-full z-30 flex items-center justify-center">
                <div className="w-2.5 h-2.5 rounded-full bg-slate-950 mr-2" />
                <div className="w-1.5 h-1.5 rounded-full bg-slate-800" />
              </div>

              {/* Screen Content Wrapper */}
              <div
                className={`relative rounded-[38px] overflow-hidden shadow-inner flex flex-col h-[610px] select-none transition-colors duration-300 ${
                  mockupDarkMode ? "bg-[#0E131F] text-slate-100" : "bg-[#FAFAFC] text-slate-900"
                }`}
              >
                {/* Status Bar */}
                <div className="h-9 px-6 pt-2 flex items-center justify-between text-[11px] font-bold text-slate-500 z-20">
                  <span>9:41</span>
                  <div className="flex items-center gap-1.5 text-[10px]">
                    <span>5G</span>
                    <div className="w-4 h-2.5 border border-current rounded-sm p-0.5 flex items-center">
                      <div className="w-full h-full bg-current rounded-xs" />
                    </div>
                  </div>
                </div>

                {/* TAB 1: DAILY LEDGER */}
                {activeTab === "trans" && (
                  <div className="flex flex-col flex-1 overflow-hidden">
                    {/* Header */}
                    <div className="bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white px-4 pt-3 pb-3">
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-extrabold text-sm flex items-center gap-1.5">
                          <Calendar className="w-4 h-4" /> Oct 2026
                        </span>
                        <span className="text-[10px] bg-white/20 px-2 py-0.5 rounded-full font-bold">
                          Daily
                        </span>
                      </div>
                      <div className="grid grid-cols-3 text-center pt-2 border-t border-white/20">
                        <div>
                          <div className="text-[9px] text-white/80">Income</div>
                          <div className="text-xs font-bold text-emerald-200">+₹85,400</div>
                        </div>
                        <div>
                          <div className="text-[9px] text-white/80">Expenses</div>
                          <div className="text-xs font-bold text-white">-₹28,650</div>
                        </div>
                        <div>
                          <div className="text-[9px] text-white/80">Balance</div>
                          <div className="text-xs font-bold text-amber-200">₹56,750</div>
                        </div>
                      </div>
                    </div>

                    {/* Filter chips */}
                    <div className="flex gap-1.5 px-3 py-2 border-b text-[10px] font-bold border-slate-100 dark:border-slate-800">
                      <span className="px-2 py-0.5 rounded-full bg-coral-500 text-white">All</span>
                      <span className="px-2 py-0.5 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500">Cash</span>
                      <span className="px-2 py-0.5 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500">Bank UPI</span>
                      <span className="px-2 py-0.5 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500">Card</span>
                    </div>

                    {/* Entries */}
                    <div className="flex-1 overflow-y-auto p-3 space-y-2.5">
                      <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800/80 shadow-xs">
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-lg bg-emerald-100 dark:bg-emerald-950 text-emerald-600 flex items-center justify-center text-xs">
                            💼
                          </div>
                          <div>
                            <div className="text-xs font-bold">Tech Consultancy</div>
                            <div className="text-[9px] text-slate-400">HDFC UPI • Income</div>
                          </div>
                        </div>
                        <span className="text-xs font-bold text-emerald-600">+₹75,000</span>
                      </div>

                      <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800/80 shadow-xs">
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-lg bg-coral-100 dark:bg-coral-950 text-coral-600 flex items-center justify-center text-xs">
                            🍜
                          </div>
                          <div>
                            <div className="text-xs font-bold">Ramen Dinner</div>
                            <div className="text-[9px] text-slate-400">ICICI Card • Food & Dining</div>
                          </div>
                        </div>
                        <span className="text-xs font-bold text-coral-500">-₹1,420</span>
                      </div>

                      <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800/80 shadow-xs">
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-lg bg-amber-100 dark:bg-amber-950 text-amber-600 flex items-center justify-center text-xs">
                            🛒
                          </div>
                          <div>
                            <div className="flex items-center gap-1">
                              <span className="text-xs font-bold">Weekend Grocery</span>
                              <Camera className="w-2.5 h-2.5 text-slate-400" />
                            </div>
                            <div className="text-[9px] text-slate-400">Cash in Hand • Provisions</div>
                          </div>
                        </div>
                        <span className="text-xs font-bold text-coral-500">-₹2,350</span>
                      </div>

                      <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800/80 shadow-xs">
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-lg bg-purple-100 dark:bg-purple-950 text-purple-600 flex items-center justify-center text-xs">
                            ⛽
                          </div>
                          <div>
                            <div className="text-xs font-bold">Fuel Station</div>
                            <div className="text-[9px] text-slate-400">HDFC UPI • Transport</div>
                          </div>
                        </div>
                        <span className="text-xs font-bold text-coral-500">-₹1,800</span>
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 2: PIE CHART STATS */}
                {activeTab === "stats" && (
                  <div className="flex flex-col flex-1 overflow-hidden">
                    <div className="bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white px-4 pt-3 pb-3">
                      <div className="flex items-center justify-between">
                        <span className="font-extrabold text-sm">October Expenses</span>
                        <span className="text-xs font-bold bg-white/20 px-2 py-0.5 rounded-full">
                          ₹28,650
                        </span>
                      </div>
                    </div>

                    <div className="flex-1 overflow-y-auto p-4 space-y-4">
                      {/* Donut Chart Visual SVG */}
                      <div className="flex items-center justify-center py-2 relative">
                        <svg className="w-36 h-36 transform -rotate-90" viewBox="0 0 100 100">
                          {/* Segment 1: Food 38% - Coral */}
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#FF5E57"
                            strokeWidth="14"
                            strokeDasharray="90 150"
                            strokeDashoffset="0"
                          />
                          {/* Segment 2: Housing 24% - Blue */}
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#3B82F6"
                            strokeWidth="14"
                            strokeDasharray="57 183"
                            strokeDashoffset="-90"
                          />
                          {/* Segment 3: Transport 16% - Amber */}
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#F59E0B"
                            strokeWidth="14"
                            strokeDasharray="38 202"
                            strokeDashoffset="-147"
                          />
                          {/* Segment 4: Shopping 12% - Purple */}
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#8B5CF6"
                            strokeWidth="14"
                            strokeDasharray="28 212"
                            strokeDashoffset="-185"
                          />
                          {/* Segment 5: Other 10% - Emerald */}
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#10B981"
                            strokeWidth="14"
                            strokeDasharray="24 216"
                            strokeDashoffset="-213"
                          />
                        </svg>
                        <div className="absolute inset-0 flex flex-col items-center justify-center text-center">
                          <span className="text-[10px] text-slate-400 font-semibold">Total</span>
                          <span className="text-sm font-extrabold">₹28,650</span>
                        </div>
                      </div>

                      {/* Category Breakdown Progress Bars */}
                      <div className="space-y-2 text-xs">
                        <div className="p-2 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                          <div className="flex justify-between font-bold mb-1">
                            <span className="flex items-center gap-1.5 text-coral-500">
                              <span className="w-2 h-2 rounded-full bg-coral-500" /> Food & Dining
                            </span>
                            <span>₹10,887 (38%)</span>
                          </div>
                          <div className="w-full h-1.5 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                            <div className="h-full bg-coral-500 rounded-full w-[38%]" />
                          </div>
                        </div>

                        <div className="p-2 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                          <div className="flex justify-between font-bold mb-1">
                            <span className="flex items-center gap-1.5 text-blue-500">
                              <span className="w-2 h-2 rounded-full bg-blue-500" /> Utilities & Bills
                            </span>
                            <span>₹6,876 (24%)</span>
                          </div>
                          <div className="w-full h-1.5 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                            <div className="h-full bg-blue-500 rounded-full w-[24%]" />
                          </div>
                        </div>

                        <div className="p-2 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                          <div className="flex justify-between font-bold mb-1">
                            <span className="flex items-center gap-1.5 text-amber-500">
                              <span className="w-2 h-2 rounded-full bg-amber-500" /> Transportation
                            </span>
                            <span>₹4,584 (16%)</span>
                          </div>
                          <div className="w-full h-1.5 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                            <div className="h-full bg-amber-500 rounded-full w-[16%]" />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 3: ACCOUNTS BALANCE SHEET */}
                {activeTab === "accounts" && (
                  <div className="flex flex-col flex-1 overflow-hidden">
                    <div className="bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white px-4 pt-3 pb-3">
                      <div className="text-[10px] text-white/80 font-semibold">Total Net Worth</div>
                      <div className="text-lg font-black tracking-tight">₹2,71,150</div>
                      <div className="text-[10px] text-emerald-200 font-bold mt-0.5">
                        Assets ₹2,85,650 • Liabilities -₹14,500
                      </div>
                    </div>

                    <div className="flex-1 overflow-y-auto p-3 space-y-3">
                      <div>
                        <div className="text-[10px] font-extrabold uppercase tracking-wider text-slate-400 mb-1.5 px-1">
                          Liquid Assets
                        </div>
                        <div className="space-y-1.5">
                          <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                            <div className="flex items-center gap-2">
                              <Landmark className="w-4 h-4 text-blue-500" />
                              <div>
                                <div className="text-xs font-bold">HDFC Bank UPI</div>
                                <div className="text-[9px] text-slate-400">Primary Savings</div>
                              </div>
                            </div>
                            <span className="text-xs font-bold text-slate-900 dark:text-white">₹85,200</span>
                          </div>

                          <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                            <div className="flex items-center gap-2">
                              <Building className="w-4 h-4 text-emerald-500" />
                              <div>
                                <div className="text-xs font-bold">ICICI Savings Account</div>
                                <div className="text-[9px] text-slate-400">Emergency Fund</div>
                              </div>
                            </div>
                            <span className="text-xs font-bold text-slate-900 dark:text-white">₹42,000</span>
                          </div>

                          <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                            <div className="flex items-center gap-2">
                              <Wallet className="w-4 h-4 text-amber-500" />
                              <div>
                                <div className="text-xs font-bold">Cash in Hand</div>
                                <div className="text-[9px] text-slate-400">Physical Pocket Cash</div>
                              </div>
                            </div>
                            <span className="text-xs font-bold text-slate-900 dark:text-white">₹8,450</span>
                          </div>

                          <div className="flex items-center justify-between p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                            <div className="flex items-center gap-2">
                              <PiggyBank className="w-4 h-4 text-purple-500" />
                              <div>
                                <div className="text-xs font-bold">Mutual Funds & FD</div>
                                <div className="text-[9px] text-slate-400">Long-term Investments</div>
                              </div>
                            </div>
                            <span className="text-xs font-bold text-slate-900 dark:text-white">₹1,50,000</span>
                          </div>
                        </div>
                      </div>

                      <div>
                        <div className="text-[10px] font-extrabold uppercase tracking-wider text-rose-500 mb-1.5 px-1">
                          Liabilities (Debts)
                        </div>
                        <div className="p-2.5 rounded-xl bg-white dark:bg-slate-900 border border-rose-100 dark:border-rose-950/40 flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            <CreditCard className="w-4 h-4 text-rose-500" />
                            <div>
                              <div className="text-xs font-bold text-rose-600 dark:text-rose-400">ICICI Coral Credit Card</div>
                              <div className="text-[9px] text-slate-400">Due in 18 days</div>
                            </div>
                          </div>
                          <span className="text-xs font-bold text-rose-500">-₹14,500</span>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 4: CALCBOX & INPUT */}
                {activeTab === "calc" && (
                  <div className="flex flex-col flex-1 overflow-hidden">
                    <div className="bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white px-4 pt-3 pb-3">
                      <div className="flex items-center justify-between text-xs font-bold mb-1">
                        <span>New Expense Entry</span>
                        <span className="bg-white/20 px-2 py-0.5 rounded text-[10px]">CalcBox</span>
                      </div>
                      <div className="text-xl font-black text-white flex items-center justify-end">
                        ₹ <span className="ml-1 tracking-tight">1,250 + 450 = 1,700</span>
                      </div>
                    </div>

                    <div className="flex-1 p-3 flex flex-col justify-between">
                      {/* Category Quick Chips */}
                      <div className="grid grid-cols-4 gap-2 mb-2 text-center text-[10px] font-bold">
                        <div className="p-1.5 rounded-xl bg-coral-500 text-white flex flex-col items-center">
                          <span>🍜</span>
                          <span className="mt-0.5">Food</span>
                        </div>
                        <div className="p-1.5 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 flex flex-col items-center">
                          <span>🚕</span>
                          <span className="mt-0.5">Transit</span>
                        </div>
                        <div className="p-1.5 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 flex flex-col items-center">
                          <span>🛍️</span>
                          <span className="mt-0.5">Shopping</span>
                        </div>
                        <div className="p-1.5 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 flex flex-col items-center">
                          <span>💡</span>
                          <span className="mt-0.5">Bills</span>
                        </div>
                      </div>

                      {/* Calc Keypad Grid */}
                      <div className="grid grid-cols-4 gap-1.5 text-xs font-bold text-slate-800 dark:text-slate-100">
                        {["7", "8", "9", "÷", "4", "5", "6", "×", "1", "2", "3", "-", "C", "0", "=", "+"].map((key) => {
                          const isOperator = ["÷", "×", "-", "+", "="].includes(key);
                          return (
                            <button
                              key={key}
                              className={`h-11 rounded-xl flex items-center justify-center transition-all ${
                                key === "="
                                  ? "bg-coral-500 text-white font-extrabold shadow-sm"
                                  : isOperator
                                  ? "bg-slate-200 dark:bg-slate-800 text-coral-600 dark:text-coral-400 font-extrabold"
                                  : "bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800"
                              }`}
                            >
                              {key}
                            </button>
                          );
                        })}
                      </div>

                      {/* Photo Receipt & Save Bar */}
                      <div className="pt-2 flex items-center gap-2">
                        <button className="p-2.5 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-700">
                          <Camera className="w-4 h-4" />
                        </button>
                        <button className="flex-1 py-2.5 rounded-xl bg-coral-500 text-white font-bold text-xs shadow-md">
                          Save Transaction
                        </button>
                      </div>
                    </div>
                  </div>
                )}

                {/* Bottom App Bar */}
                <div className="h-14 bg-white dark:bg-slate-900 border-t border-slate-100 dark:border-slate-800 flex items-center justify-around px-2 text-[10px] font-semibold text-slate-400">
                  <div
                    onClick={() => setActiveTab("trans")}
                    className={`flex flex-col items-center cursor-pointer ${
                      activeTab === "trans" ? "text-coral-500" : ""
                    }`}
                  >
                    <Layers className="w-4 h-4 mb-0.5" />
                    <span>Trans</span>
                  </div>
                  <div
                    onClick={() => setActiveTab("stats")}
                    className={`flex flex-col items-center cursor-pointer ${
                      activeTab === "stats" ? "text-coral-500" : ""
                    }`}
                  >
                    <PieChart className="w-4 h-4 mb-0.5" />
                    <span>Stats</span>
                  </div>
                  <div
                    onClick={() => setActiveTab("accounts")}
                    className={`flex flex-col items-center cursor-pointer ${
                      activeTab === "accounts" ? "text-coral-500" : ""
                    }`}
                  >
                    <CreditCard className="w-4 h-4 mb-0.5" />
                    <span>Accounts</span>
                  </div>
                  <div
                    onClick={() => setActiveTab("calc")}
                    className={`flex flex-col items-center cursor-pointer ${
                      activeTab === "calc" ? "text-coral-500" : ""
                    }`}
                  >
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
