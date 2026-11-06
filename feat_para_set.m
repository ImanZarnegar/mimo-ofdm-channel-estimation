function [feat_para]=feat_para_set(START,END,MASK_index,snr_set,feat_fun)

feat_para.start= START;
feat_para.end = END;
feat_para.size =  END-START+1;
feat_para.numchannel= 64;
feat_para.MASK_index=MASK_index;
feat_para.store_enable=1; % enable saving features, resynthesized speech and IBM
feat_para.snr_set=snr_set;
% for win and overlap
feat_para.fs=16000;
feat_para.Tw=20;% ms
feat_para.Lw=round(feat_para.Tw*feat_para.fs/1000);
feat_para.overlap=3/4;
feat_para.offset=(1-feat_para.overlap)*feat_para.Lw;
feat_para.fRange=[50 8000];

feat_para.fun_name=feat_fun;

% compress the label into [0,1]
feat_para.usesigmode=1;

feat_para.isestoi = 1;% 0 is for stoi, 1 is for estoi

end