"use client";

import { useState, useEffect } from "react";
import {
  Wallet,
  Download,
  Menu,
  X,
  Sun,
  Moon,
  ShieldCheck,
  Sparkles,
} from "lucide-react";
import { GithubIcon } from "@/components/icons/GithubIcon";
import { useGitHubRelease } from "@/hooks/useGitHubRelease";
import { triggerDownloadConfetti } from "@/lib/confetti";

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [isDarkMode, setIsDarkMode] = useState(false);
  const { tagName, apkUrl, apkSizeMb } = useGitHubRelease();

  // Dark mode initialization & sync
  useEffect(() => {
    const savedTheme = localStorage.getItem("theme");
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    if (savedTheme === "dark" || (!savedTheme && prefersDark)) {
      document.documentElement.classList.add("dark");
      setIsDarkMode(true);
    } else {
      document.documentElement.classList.remove("dark");
      setIsDarkMode(false);
    }

    const handleScroll = () => {
      setIsScrolled(window.scrollY > 20);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const toggleDarkMode = () => {
    if (isDarkMode) {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("theme", "light");
      setIsDarkMode(false);
    } else {
      document.documentElement.classList.add("dark");
      localStorage.setItem("theme", "dark");
      setIsDarkMode(true);
    }
  };

  const navLinks = [
    { name: "Features", href: "#features" },
    { name: "App Views", href: "#screenshots" },
    { name: "Drive Backup", href: "#sync" },
    { name: "Privacy", href: "#security" },
    { name: "Install Guide", href: "#install" },
    { name: "FAQ", href: "#faq" },
  ];

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled
          ? "bg-white/90 dark:bg-[#0B0F17]/90 backdrop-blur-md shadow-sm border-b border-slate-200/60 dark:border-slate-800/80 py-3"
          : "bg-transparent py-5"
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          {/* Logo & Brand */}
          <a
            href="#"
            className="flex items-center gap-3 group focus:outline-none"
            aria-label="Wallet Manager Home"
          >
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-coral-500 to-warmOrange-500 flex items-center justify-center shadow-glow-coral group-hover:scale-105 transition-transform duration-200">
              <Wallet className="w-5 h-5 text-white" />
            </div>
            <div className="flex flex-col">
              <div className="flex items-center gap-2">
                <span className={`font-bold text-lg tracking-tight ${isScrolled ? "text-slate-900 dark:text-white" : "text-white"}`}>
                  Wallet Manager
                </span>
                <span className="hidden sm:inline-flex items-center gap-1 text-[10px] font-semibold tracking-wider uppercase px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
                  <ShieldCheck className="w-3 h-3 text-emerald-400" />
                  100% Offline
                </span>
              </div>
              <span className={`text-[11px] font-medium leading-none ${isScrolled ? "text-slate-500 dark:text-slate-400" : "text-white/80"}`}>
                Double-Entry Money Manager
              </span>
            </div>
          </a>

          {/* Desktop Navigation Links */}
          <nav className="hidden lg:flex items-center gap-7">
            {navLinks.map((link) => (
              <a
                key={link.name}
                href={link.href}
                className={`text-sm font-medium transition-colors hover:text-coral-500 ${
                  isScrolled
                    ? "text-slate-600 dark:text-slate-300"
                    : "text-white/90 hover:text-white"
                }`}
              >
                {link.name}
              </a>
            ))}
          </nav>

          {/* Action CTAs & Controls */}
          <div className="hidden sm:flex items-center gap-3">
            {/* Theme Toggle Button */}
            <button
              onClick={toggleDarkMode}
              className={`p-2.5 rounded-xl border transition-colors ${
                isScrolled
                  ? "border-slate-200 dark:border-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
                  : "border-white/20 text-white hover:bg-white/10"
              }`}
              title={isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"}
              aria-label="Toggle theme"
            >
              {isDarkMode ? (
                <Sun className="w-4 h-4 text-amber-400" />
              ) : (
                <Moon className="w-4 h-4 text-white" />
              )}
            </button>

            {/* GitHub Stars Link */}
            <a
              href="https://github.com/iamkamleshmali/wallet-manager-km"
              target="_blank"
              rel="noopener noreferrer"
              className={`flex items-center gap-1.5 px-3 py-2 text-xs font-semibold rounded-xl border transition-all ${
                isScrolled
                  ? "border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800"
                  : "border-white/25 text-white hover:bg-white/15"
              }`}
              title="View on GitHub"
            >
              <GithubIcon className="w-4 h-4" />
              <span>GitHub</span>
            </a>

            {/* Direct APK Download Button */}
            <a
              href={apkUrl}
              download="app-release.apk"
              rel="noopener noreferrer"
              onClick={() => triggerDownloadConfetti()}
              className="relative group flex items-center gap-2 px-4 py-2.5 rounded-xl bg-white text-coral-600 dark:bg-white dark:text-coral-600 font-bold text-xs shadow-md hover:shadow-xl hover:scale-102 active:scale-98 transition-all duration-200"
            >
              <Download className="w-4 h-4 text-coral-500 animate-bounce" />
              <span>Download APK</span>
              <span className="text-[10px] bg-coral-50 text-coral-700 font-bold px-1.5 py-0.5 rounded-md border border-coral-200">
                {tagName}
              </span>
            </a>
          </div>

          {/* Mobile menu button */}
          <div className="flex items-center gap-2 sm:hidden">
            <button
              onClick={toggleDarkMode}
              className={`p-2 rounded-lg border ${
                isScrolled
                  ? "border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-200"
                  : "border-white/20 text-white"
              }`}
              aria-label="Toggle dark mode"
            >
              {isDarkMode ? (
                <Sun className="w-4 h-4 text-amber-400" />
              ) : (
                <Moon className="w-4 h-4" />
              )}
            </button>
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className={`p-2 rounded-lg border ${
                isScrolled
                  ? "border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-200"
                  : "border-white/20 text-white"
              }`}
              aria-label="Toggle menu"
            >
              {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
            </button>
          </div>
        </div>

        {/* Mobile Navigation Drawer */}
        {mobileMenuOpen && (
          <div className="sm:hidden mt-4 p-4 rounded-2xl bg-white dark:bg-[#111827] shadow-2xl border border-slate-200 dark:border-slate-800 animate-in fade-in slide-in-from-top-4 duration-200">
            <div className="flex flex-col gap-3">
              {navLinks.map((link) => (
                <a
                  key={link.name}
                  href={link.href}
                  onClick={() => setMobileMenuOpen(false)}
                  className="px-3 py-2 text-sm font-semibold text-slate-700 dark:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
                >
                  {link.name}
                </a>
              ))}
              <div className="pt-3 border-t border-slate-100 dark:border-slate-800 flex flex-col gap-2">
                <a
                  href={apkUrl}
                  download="app-release.apk"
                  rel="noopener noreferrer"
                  onClick={() => {
                    triggerDownloadConfetti();
                    setMobileMenuOpen(false);
                  }}
                  className="w-full flex items-center justify-center gap-2 py-3 rounded-xl bg-gradient-to-r from-coral-500 to-warmOrange-500 text-white font-bold text-sm shadow-md"
                >
                  <Download className="w-4 h-4" />
                  <span>Download APK ({tagName} • {apkSizeMb})</span>
                </a>
                <a
                  href="https://github.com/iamkamleshmali/wallet-manager-km"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full flex items-center justify-center gap-2 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300 font-semibold text-xs"
                >
                  <GithubIcon className="w-4 h-4" />
                  <span>View Source on GitHub</span>
                </a>
              </div>
            </div>
          </div>
        )}
      </div>
    </header>
  );
}
