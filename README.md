<div align="center">

# MIMO-OFDM Channel Estimation Using Deep Learning & Time-Frequency Masking
### تخمین کانال در سیستم‌های MIMO-OFDM با استفاده از یادگیری عمیق و ماسک‌گذاری زمان-فرکانس

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2018b%2B-orange.svg)](https://www.mathworks.com)
[![Thesis Score](https://img.shields.io/badge/M.Sc.%20Thesis%20Score-19.75%2F20-success.svg)](#)

[English](#-english) • [فارسی](#-فارسی-چکیده-و-شناسنامه-پایاننامه)

</div>

---

# 🌐 English

## 📌 Project Identity
* **Title:** Channel Estimation in Multiple Input Multiple Output Systems Based on Orthogonal Frequency Division Multiplexing Using Artificial Intelligence Techniques
* **Author:** Iman Zarangarpanah Esfandabadi ([@ImanZarnegar](https://github.com/ImanZarnegar))
* **Degree:** M.Sc. in Telecommunication Networks Engineering
* **University:** Islamic Azad University, Karaj Branch — Faculty of Engineering
* **Advisor:** Dr. Hamidreza Rabiee | **Consultant:** Dr. Simin Khazrayi
* **Defense Date:** January 13, 2025 (23/10/1403) — **Score: 19.75 / 20**

---

## 🔬 Abstract & Innovations
Accurate channel state estimation is essential for high-throughput, reliable wireless transmission in dynamic MIMO-OFDM scenarios. Conventional statistical/linear algorithms (such as **LS** and **MMSE**) exhibit severe performance drops and prohibitive computational complexity under fast-fading and low SNR regimes.

This research presents a robust **Deep Learning framework integrating LSTM, RNN, and GAN architectures coupled with Time-Frequency (T-F) Masking**:
* **Mask-based Learning:** Rather than estimating raw signals directly (which often degrades high-frequency harmonics), the networks predict optimal T-F masks.
* **LSTM-RNN Temporal Modeling:** Exploits sequential correlations across subcarriers and time slots while reducing complexity via weight-sharing.
* **GAN-based Enhancement:** Generator optimized with **Adam** and Discriminator with **SGD** for stable adversarial training.
* **Unbounded Output Layer:** Removal of non-linear activation functions at the final stage to allow full dynamic range for the estimated mask.

---

## 📊 Quantitative Benchmarks

Experimental results comparing the proposed architecture with literature benchmarks under noisy fading conditions:

| Metric | Benchmark [2] | Benchmark [4] | Benchmark [6] | **Proposed Method** |
| :--- | :---: | :---: | :---: | :---: |
| **PESQ** (Perceptual Quality) | 2.15 | 2.16 | 1.12 | **2.34** |
| **COVL** (Overall Quality) | 2.42 | 2.80 | 1.31 | **2.90** |
| **CSIG** (Signal Distortion) | 2.81 | 3.48 | 1.64 | **3.50** |
| **STOI** (Intelligibility) | 0.88 | 0.93 | 0.62 | **0.91** |

---

## 📂 Repository Structure
```text
├── config/             # Network topology & simulation configurations
├── gen_mixture/        # Dynamic signal/noise synthesis pipeline
├── get_feat/           # Time-frequency feature extraction routines
├── pic/                # Visualization assets for plotting
├── RUN.m               # End-to-end execution pipeline
├── feat_para_set.m     # Feature extraction settings
├── dnn_para_set.m      # Hyperparameter definitions
├── load_config.m       # Dynamic configuration parser
├── lin2sig.m           # Domain transformation helper
├── pesq_fun2.m         # PESQ evaluation wrapper
├── draw.p              # Graphical figure rendering engine
└── .gitignore          # Repository hygiene and exclusion rules
