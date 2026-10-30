<div align="center">
  <img src="rdx_yt_logo.png" alt="RDX-YT logo" width="180" />

# RDX-YT

### Ad-Free Custom YouTube Client • Developed by Abdullah Naeem Rao

[![Download RDX GmsCore](https://img.shields.io/badge/1._Install-RDX_GmsCore-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://github.com/AbdullahRaoDev/RDX-YT/releases/latest/download/RDX-GmsCore.apk)
[![Download RDX-YT](https://img.shields.io/badge/2._Install-RDX--YT-ff0033?style=for-the-badge&logo=youtube&logoColor=white)](https://github.com/AbdullahRaoDev/RDX-YT/releases/latest/download/RDX-YT.apk)

![Android](https://img.shields.io/badge/Android-111111?style=flat-square&logo=android&logoColor=3DDC84)
![ReVanced](https://img.shields.io/badge/ReVanced-111111?style=flat-square)
![Automated Build](https://img.shields.io/badge/Build-GitHub_Actions-111111?style=flat-square&logo=githubactions&logoColor=white)
</div>

RDX-YT is an automated ReVanced build factory. GitHub Actions obtains a compatible stock YouTube APK, applies the official ReVanced patch bundle, brands the application as **RDX-YT**, signs it with an ephemeral build key, and publishes the result as a GitHub Release.

## Branding

- Application name: `RDX-YT`
- Package name: `com.rdx.yt`
- Custom launcher resources: `brand-res/`
- Developer: Abdullah Naeem Rao

## Build

Open **Actions → Build RDX-YT → Run workflow**. A successful run publishes the official ReVanced GmsCore companion and the patched `RDX-YT.apk` together as a GitHub release.

The workflow resolves the recommended YouTube version from the current official patch bundle and downloads it through the open-source [EFF apkeep](https://github.com/EFForg/apkeep) tool using its APKPure backend. Stock APKs, downloaded build tools, temporary signing keys, and intermediate artifacts are never committed.

## Installation — required order

RDX-YT is a non-root, custom-package build. Android cannot let a custom-signed YouTube package authenticate as Google's official YouTube app, so the GmsCore companion is required.

1. Uninstall any earlier RDX-YT build. The factory currently uses a temporary signing key, so Android cannot install a new build over an old one.
2. Download and install [`RDX-GmsCore.apk`](https://github.com/AbdullahRaoDev/RDX-YT/releases/latest/download/RDX-GmsCore.apk).
3. Download and install [`RDX-YT.apk`](https://github.com/AbdullahRaoDev/RDX-YT/releases/latest/download/RDX-YT.apk).
4. Open RDX-YT and sign in if desired.

Do not open RDX-YT before installing RDX-GmsCore. The workflow downloads GmsCore directly from the official ReVanced GitHub release, validates its Android package, and publishes it unchanged.

## Disclaimer

This is an independent, unofficial project and is not affiliated with or endorsed by Google, YouTube, or the ReVanced project. YouTube is a trademark of Google LLC. Review the applicable terms and local laws before building or distributing patched applications.
