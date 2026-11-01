<div align="center">

# MIMO-OFDM Channel Estimation Using Deep Learning & Time-Frequency Masking
### تخمین کانال در سیستم‌های MIMO-OFDM با استفاده از یادگیری عمیق و ماسک‌گذاری زمان-فرکانس

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14032025.svg)](https://doi.org/10.5281/zenodo.14032025)
[![CI](https://github.com/ImanZarnegar/mimo-ofdm-channel-estimation/actions/workflows/ci.yml/badge.svg)](https://github.com/ImanZarnegar/mimo-ofdm-channel-estimation/actions)
[![Thesis Score](https://img.shields.io/badge/M.Sc.%20Thesis%20Score-19.75%2F20-success.svg)](#)

**Official MATLAB implementation for the M.Sc. Research Thesis**  
[📄 Read Thesis Document](#-academic-citation) • [🌐 English](#-english) • [🇮🇷 فارسی](#-فارسی)

</div>

---

# 🌐 English

## 📌 Abstract
Accurate Channel State Information (CSI) estimation in high-mobility **MIMO-OFDM** wireless systems is degraded under non-stationary fading and heavy noise regimes using conventional linear estimators (LS/MMSE). This repository provides a robust deep learning framework combining **LSTM-RNN** architectures and **Generative Adversarial Networks (GAN)** driven by **Time-Frequency (T-F) Masking**, preventing harmonic distortion and achieving superior perceptual/error metrics.

## 🚀 Highlights
* **Mask-Based Optimization:** Predicts optimal continuous T-F modulation masks rather than raw unstable channel matrices.
* **Hybrid Temporal Modeling:** Integrates LSTM gated cells and classical recurrent layers for long-term fading tracking.
* **Adversarial Stabilization:** GAN pipeline optimized with **Adam** (Generator) and **SGD** (Discriminator).
* **High-Fidelity Benchmarking:** Validated on multi-path 32×4 MIMO-OFDM channels under severe acoustic/factory noise profiles.

---

## 🛠️ Installation & Environment Setup

Clone the repository and set up your local MATLAB environment:
```bash
git clone https://github.com/ImanZarnegar/mimo-ofdm-channel-estimation.git
cd mimo-ofdm-channel-estimation
