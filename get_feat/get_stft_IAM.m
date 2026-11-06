function [ feat_lable ] = get_stft_IAM(clean, noise, feat_para )
%get_stft_pIAM Summary of this function goes here
%   Detailed explanation goes here
Fs = feat_para.fs;
Lw = feat_para.Lw;
nfft = 2^nextpow2(Lw);
overlap = feat_para.overlap;
SNR = feat_para.snr_set;

noverlap  = round(Lw*overlap); % number of overlap
hop=Lw-noverlap; % time shift
win = hamming(Lw);

noisy = clean+noise;

% get the spectrogram
csp =spectrogram(clean,win,noverlap,nfft,Fs);
nysp=spectrogram(noisy,win,noverlap,nfft,Fs);

csp_mag=abs(csp);
nysp_mag=abs(nysp);
    
% IAM
IAM = create_IAM(csp_mag, nysp_mag, feat_para);

feat_lable = IAM;

end

