function [ feat_lable ] = get_stft_pIAM(clean, noise, feat_para )
%get_stft_pIAM Summary of this function goes here
%   Detailed explanation goes here
Fs = feat_para.fs;
Lw = feat_para.Lw;
nfft = 2^nextpow2(Lw);
overlap = feat_para.overlap;

noverlap  = round(Lw*overlap); % number of overlap
hop=Lw-noverlap; % time shift
win = hamming(Lw);

noisy = clean+noise;

% get the spectrogram
csp =spectrogram(clean,win,noverlap,nfft,Fs);
nysp=spectrogram(noisy,win,noverlap,nfft,Fs);

csp_mag=abs(csp);
csp_phase=angle(csp); % angle with lie between -pi to pi
nysp_mag=abs(nysp);
nysp_phase=angle(nysp);
    
%% features
% IRM
IAM = create_IAM(csp_mag, nysp_mag, feat_para);
MASK = IAM;

% modified IFD for phase
csp_phase_com=phase_com(csp_phase,hop); % deviation
cphase_ucom=unwrap(csp_phase_com,[],2); % compensate along time axis
IFD = diff([cphase_ucom(:,1),cphase_ucom],1,2); % derivation, the first colum is useless

% MIFD = deltas(cphase_ucom,9,2);
MIFD = IFD./(2*pi)+0.5; % normalized to [1,0] as IRM
feat_lable = [MASK;MIFD];% connect along frequence axis

end

