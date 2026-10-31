function run_every(feat_type, noise_type, istrain, START, END, snr_set, MASK_index, TMP_STORE)
% extract the feature, the most of the parameter are set in feat_para;
%-------------2017/3/17-----------------------------------------

fprintf(1,'\t%s\t%s\n',feat_type,noise_type);

SPEECH_DATA_PATH = [ TMP_STORE filesep 'db' num2str(snr_set) filesep 'mix'] %#ok<NOPRT>
if istrain == 1
    MIXDATA_PATH = [ SPEECH_DATA_PATH, filesep, 'train_', noise_type, '_mix.mat'];
    disp(['training data=' MIXDATA_PATH]);
    save_prefix = 'train';
else
    MIXDATA_PATH = [ SPEECH_DATA_PATH filesep 'test_' noise_type '_mix.mat'];
    disp(['test data =' MIXDATA_PATH]);
    save_prefix = 'test';
end

%% set the parameter of fearture extraction 
% structure for feature parameters, if global is neccerssary
global feat_para;
feat_fun = feat_type;%feature function
[feat_para]=feat_para_set(START,END,MASK_index,snr_set,feat_fun);

fprintf(1,'----part:%d istrain: [ %d ~ %d ] , size=%d\n',...
    istrain, START, END, feat_para.size);
fprintf(1,'----store=%d NUMBER_CHANNEL=%d MASK_index=%d.\n',...
    feat_para.store_enable, feat_para.numchannel, feat_para.MASK_index);

disp('####### extracting features ######');
% run_get_features;  change the script to the function
[feat_data,feat_label,DFI]=run_get_features(feat_para, MIXDATA_PATH, istrain); %#ok<ASGLU>

% name by feat and mask
f_name =[feat_type,'_',num2str(MASK_index)];

%% store the features
% the store path for feature
STORE_PATH = [TMP_STORE, filesep, 'db', num2str(snr_set), filesep, 'feat'];
disp(['--STORE_PATH: ', STORE_PATH]);

if feat_para.store_enable
    if ~exist(STORE_PATH,'dir'); mkdir(STORE_PATH); end;
    if istrain ==1 % for train	    
        train_feat_path = [STORE_PATH, filesep,save_prefix, '_', noise_type,'_', f_name,'.mat' ];
        save(train_feat_path,'feat_data','START', 'END','istrain','feat_para','-v7.3');
        clear feat_data;
        disp('save feat_data is ok, now for label...');
        save(train_feat_path,'feat_label','-append')
%         clear feat_data feat_label START END;% feat_set_size feat_start feat_end PART
    else % for test
        test_feat_path = [STORE_PATH, filesep,save_prefix, '_', noise_type,'_', f_name,'.mat' ];
        save(test_feat_path,'feat_data','START', 'END','istrain','feat_para','DFI','-v7.3'); % add an DFI
        clear feat_data;
        disp('save feat_data is ok, now for label...');
        save(test_feat_path,'feat_label','-append')
%         clear feat_data feat_label START END;% feat_set_size feat_start feat_end part DFI
    end
end
fprintf(1,'----finish saving %s\n',f_name);
fprintf(1,'%s have been finished.\n',noise_type);
end
