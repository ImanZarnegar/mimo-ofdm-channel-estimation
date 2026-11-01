function combine = my_features_AmsRastaplpMfccGf(sig,feat_para)
% for different overlapping factors, there may need to pad zero at the
% beginning of the following features, 
% here we use 20ms for window frame and 5 ms for frame shift

    Fs = feat_para.fs;
    Lw = feat_para.Lw;
    nfft = 2^nextpow2(Lw);
    overlap = feat_para.overlap;
    hopf = 1-overlap;
    OFFSET = feat_para.offset;  
    SNR = feat_para.snr_set;
    
    sig = double(sig);
    n_sample = length(sig);
    nframe =  floor((n_sample-Lw)/OFFSET)+1;
    nc = 64;
    
    padnum = round(1/hopf);
    
    feat_stack = [];
    %fprintf('AMS...')
    ams_feat = get_amsfeature_chan_fast(sig,nc);
    ams_feat = ams_feat(:,padnum:end);
    %fprintf('RASTAPLP2D...')
    
    rastaplp_feat = rastaplp(sig, Fs, 1, 12);
%     rastaplp_feat = [zeros(size(rastaplp_feat,1),padnum), rastaplp_feat];
    
    %fprintf('MODMFCC...\n')
    mfcc_feat = melfcc(sig, Fs,'numcep',31,'nbands',nc,'wintime', 0.020, 'hoptime', 0.020*hopf, 'maxfreq', 8000);
%     mfcc_feat = [zeros(size(mfcc_feat,1),padnum), mfcc_feat];
     
    feat = cochleagram(gammatone(sig, nc, [50, 8000], Fs));
    feat = feat(:,padnum:end);
    
    %feat = feat(:,1:nFrame);
    gf_feat = single(feat.^(1/15));
    
    combine = [ams_feat; rastaplp_feat; mfcc_feat; gf_feat];  
    
    % add delta features
    combine = [combine; deltas(combine)];
end

