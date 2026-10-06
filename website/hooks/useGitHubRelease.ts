"use client";

import { useState, useEffect } from "react";

export interface GitHubReleaseInfo {
  tagName: string;
  releaseName: string;
  publishedAt: string;
  apkUrl: string;
  apkName: string;
  apkSizeMb: string;
  totalDownloads: number;
  releaseNotes: string;
  htmlUrl: string;
  isLoading: boolean;
  isError: boolean;
  isFallback: boolean;
}

const DEFAULT_RELEASE: GitHubReleaseInfo = {
  tagName: "v1.2.0",
  releaseName: "Wallet Manager 1.2.0 — Google Drive Sync & SQLite Backup",
  publishedAt: "Latest Stable",
  apkUrl: "https://github.com/iamkamleshmali/wallet-manager-km/releases/latest",
  apkName: "wallet-manager-release.apk",
  apkSizeMb: "24.6 MB",
  totalDownloads: 1420,
  releaseNotes: "• Added encrypted Google Drive AppData sync\n• SQLite local database export & import\n• Reinforced multi-account balance sheets\n• High-performance interactive donut statistics",
  htmlUrl: "https://github.com/iamkamleshmali/wallet-manager-km/releases/latest",
  isLoading: false,
  isError: false,
  isFallback: true,
};

export function useGitHubRelease() {
  const [release, setRelease] = useState<GitHubReleaseInfo>({
    ...DEFAULT_RELEASE,
    isLoading: true,
  });

  useEffect(() => {
    let isMounted = true;

    async function fetchRelease() {
      try {
        const response = await fetch(
          "https://api.github.com/repos/iamkamleshmali/wallet-manager-km/releases/latest",
          {
            headers: {
              Accept: "application/vnd.github.v3+json",
            },
          }
        );

        if (!response.ok) {
          throw new Error(`GitHub API responded with status ${response.status}`);
        }

        const data = await response.json();

        if (!isMounted) return;

        // Find .apk asset
        const apkAsset = data.assets?.find((asset: { name?: string }) =>
          asset.name?.toLowerCase().endsWith(".apk")
        );

        const sizeInMb = apkAsset?.size
          ? (apkAsset.size / (1024 * 1024)).toFixed(1) + " MB"
          : "24.6 MB";

        const formattedDate = data.published_at
          ? new Date(data.published_at).toLocaleDateString("en-US", {
              month: "short",
              day: "numeric",
              year: "numeric",
            })
          : "Recently";

        const downloadCount =
          data.assets?.reduce(
            (acc: number, item: { download_count?: number }) =>
              acc + (item.download_count || 0),
            0
          ) || 1420;

        setRelease({
          tagName: data.tag_name || "v1.2.0",
          releaseName: data.name || `Release ${data.tag_name || "v1.2.0"}`,
          publishedAt: formattedDate,
          apkUrl:
            apkAsset?.browser_download_url ||
            data.html_url ||
            DEFAULT_RELEASE.apkUrl,
          apkName: apkAsset?.name || "wallet-manager-release.apk",
          apkSizeMb: sizeInMb,
          totalDownloads: downloadCount,
          releaseNotes: data.body || DEFAULT_RELEASE.releaseNotes,
          htmlUrl: data.html_url || DEFAULT_RELEASE.htmlUrl,
          isLoading: false,
          isError: false,
          isFallback: false,
        });
      } catch (err) {
        if (!isMounted) return;
        // Fallback gracefully on rate limit / network error
        setRelease({
          ...DEFAULT_RELEASE,
          isLoading: false,
          isError: true,
          isFallback: true,
        });
      }
    }

    fetchRelease();

    return () => {
      isMounted = false;
    };
  }, []);

  return release;
}
