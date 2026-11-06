function [ feat_data ] = get_stft_data(noisy_speech, feat_para )
%GET_STFT_DATA Summary of this function goes here
%   Detailed explanation goes here
% feat_data contians the mag and its delt data in one column
Fs = feat_para.fs;
Lw = feat_para.Lw;
nfft = 2^nextpow2(Lw);
overlap = feat_para.overlap;
noverlap  = round(Lw*overlap); % number of overlap

win = hamming(Lw);

% get the spectrogram of the noisy speech
nysp=spectrogram(noisy_speech,win,noverlap,nfft,Fs);

nysp_mag=abs(nysp);
nysp_phase=angle(nysp);% angle with lie between ¡Àpi.

nysp_mag_dB = 10*log10(nysp_mag);
nysp_mag_delt_f = diff(nysp_mag_dB,1,1); % the frequency bin minus 1
% nysp_mag_delt_f = deltas(nysp_mag_dB,3,1);% alonge frequence axis

% cat these two matirces
feat_data=[nysp_mag_dB;nysp_mag_delt_f]; % connect along frequence axis

end

