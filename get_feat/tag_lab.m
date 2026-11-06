function [ features, ideal_mask] = tag_lab( large_mix_sig, c, speech_sig, noise_sig,feat_para) 
%{data,lable}
%feat_para contains NUMBER_CHANNEL,MASK_index, snr_set
% this fucntions is to generate the features and targets
Lw = feat_para.Lw;
numChan=feat_para.numchannel;
MASK_index=feat_para.MASK_index;
snr_set=feat_para.snr_set;
FS = feat_para.fs; % sampling frequency 
OFFSET = feat_para.offset;   % compute acf every 4 ms 
fRange=feat_para.fRange;%[50 8000];

mix_sig = large_mix_sig./c; % small it to fit the clean and noise speech

[n_sample, ~] = size(mix_sig);
n_frame = floor((n_sample-Lw)/OFFSET)+1;

%% get the mask of speech and noise from STFT field
switch MASK_index
    case 5 % STFT-IRM
        ideal_mask= get_stft_IRM(speech_sig, noise_sig, feat_para);
        assert(sum(sum(isnan(ideal_mask)))==0);
    case 6 % IAM
        ideal_mask= get_stft_IAM(speech_sig, noise_sig, feat_para);
        assert(sum(sum(isnan(ideal_mask)))==0);
    case 7 % IAM+IFD
        ideal_mask= get_stft_pIAM(speech_sig, noise_sig, feat_para);
        assert(sum(sum(isnan(ideal_mask)))==0);
    otherwise
        disp('There are only 5: IRM, 6:IAM, 7: IAM+IFD choices, no others!');
        assert(0);
end

%% get the feature of mix_sig
f1 = my_features_AmsRastaplpMfccGf(large_mix_sig,feat_para);

features(:,:) = f1(:,1:n_frame);

% reduce the data size to single
features = single(features);
ideal_mask = single(ideal_mask);
end
