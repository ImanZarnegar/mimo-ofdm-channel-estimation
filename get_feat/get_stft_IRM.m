function [ feat_lable ] = get_stft_IRM(clean, noise, feat_para )
%GET_STFT_MASK Summary of this function goes here
%   Detailed explanation goes here
Fs = feat_para.fs;
Lw = feat_para.Lw;
nfft = 2^nextpow2(Lw);
overlap = feat_para.overlap;

noverlap  = round(Lw*overlap); % number of overlap
hop=Lw-noverlap; % time shift
win = hamming(Lw);

% get the spectrogram
csp =spectrogram(clean,win,noverlap,nfft,Fs);
nsp=spectrogram(noise,win,noverlap,nfft,Fs);

csp_mag=abs(csp);
nsp_mag=abs(nsp);
    

% IRM
beta = 0.5; %sqrt( winer filter )
IRM = create_IRM(csp_mag, nsp_mag, beta);
MASK = IRM;

%     % IBM
%     LC=SNR-5;
%     %IBM_s= zeros(size(IBM)); % obtain from a binary matrix is better under low SNR
%     IBM = create_IBM(csp_mag, nsp_mag, LC);
%     MASK = IBM;


feat_lable = MASK;% connect along frequence axis


end

