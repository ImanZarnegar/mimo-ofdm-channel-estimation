function [ feat_lable ] = get_stft_mask(clean, noise, feat_para )
%GET_STFT_MASK Summary of this function goes here
%   Detailed explanation goes here
Fs = feat_para.fs;
Lw = feat_para.Lw;
nfft = 2^nextpow2(Lw);
overlap = feat_para.overlap;
SNR = feat_para.snr_set;

noverlap  = round(Lw*overlap); % number of overlap
hop=Lw-noverlap; % time shift
win = hamming(Lw);

is_ratio_mask = feat_para.is_wiener_mask;

% % pad the speech at the front due to the offset
% clean = [zeros(noverlap,1);clean];
% noise = [noise(1:noverlap,1);noise];

% get the spectrogram
csp =spectrogram(clean,win,noverlap,nfft,Fs);
nsp=spectrogram(noise,win,noverlap,nfft,Fs);

csp_mag=abs(csp);
csp_phase=angle(csp); % angle with lie between ����.
nsp_mag=abs(nsp);
nsp_phase=angle(nsp);
    
m=2;
if is_ratio_mask >=1
    % IRM
    beta = 0.5; %sqrt( winer filter )
    [IRM, MASK] = create_IRM(csp_mag, nsp_mag, beta, m);
%     MASK(find(isnan(MASK)))=0;
else
    % IBM
    LC=SNR-5;
    %IBM_s= zeros(size(IBM)); % obtain from a binary matrix is better under low SNR
    [IBM, MASK] = create_IBM(csp_mag, nsp_mag, LC, m);
    MASK(find(isnan(MASK)))=0;
end

% modified IF for phase
csp_phase_com=phase_com(csp_phase,hop);
cphase_ucom=unwrap(csp_phase_com,[],2); % compensate along time axis

if(feat_para.use_phase ==1)
    MIF = diff([cphase_ucom(:,1),cphase_ucom],1,2); % modified IF
    % MIF = deltas(cphase_ucom,9,2);
    MIF = MIF./(2*pi)+0.5; % normalized to [1,0] as IRM
    feat_lable = [MASK;MIF];% connect along frequence axis
else
    feat_lable = [MASK];% connect along frequence axis
end

end

