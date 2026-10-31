% بارگذاری سیگنال صوتی
[x, fs] = audioread('filename.wav');

% تنظیم پارامترها
winLength = 256; % طول پنجره
overlap = 128;  % همپوشانی
nFFT = 512;     % تعداد نقاط FFT
numCoeffs = 13; % تعداد ضریب های MFCC

% محاسبه MFCC
coeffs = mfcc(x, fs, 'WindowLength', winLength, 'OverlapLength', overlap, ...
              'NumCoeffs', numCoeffs, 'FFTLength', nFFT);

% نمایش MFCC
figure;
imagesc(coeffs');
axis xy;
colormap jet;
xlabel('Frame Index');
ylabel('MFCC Coefficients');
title('MFCC Coefficients');
colorbar;