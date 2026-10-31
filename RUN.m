mix_dB = -3;
MASK_index = 7;
isseq = [1,1,1]; % control the three stages: [mix, get featrue, train and test DNN]
noise_type = 'factory1';
disp(datetime('now'));
format compact
% warning off;
%g = gpuDevice(1);
%reset(g);

%% load configurations 
% load_config;
% feat_type = 'AmsRastaplpMfccGf' %#ok<NOPTS> % feature tpye
feat_type = 'Comp_feat'; % Complete feature

% number of times that each clean utterance is mixed with noise for training.
repeat_time = 2; 

% whehter select female speech
isfemale = 1;
if isfemale ==1
    train_list =['config' filesep 'ftrain_slist.txt']; %100
    test_list = ['config' filesep 'ftest_slist.txt']; %20
elseif isfemale==-1
    train_list = ['config' filesep 'mtrain_list.txt'];%1360
    test_list = ['config' filesep 'mtest_list.txt'];%560
else
%both genders
    train_list = ['config' filesep 'btr_list.txt'];
    test_list = ['config' filesep 'bte_list.txt'];
end

% cut noise into two parts, the first part is for training and the second part is for test
noise_cut = 0.5;

% isseq is a vector contains the following binaries
% 1. generate mixtures or not. 0: no, 1: yes.
is_gen_mix = isseq(1);
% 2. generate features/masks or not. 0: no, 1: yes.
is_gen_feat = isseq(2);
% 3. perform dnn training/test or not. 0: no, 1: yes.
is_dnn = isseq(3);

%% create folders for feature, label and demo
global mainpath; % set the mainpath as a global variable
mainpath= pwd; %'Z:\DNN_male';
cd(mainpath); %avoid to create DATA director everywhere

tmp_path = ['DATA', filesep]; %DATA\
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
tmp_path = ['DATA', filesep, noise_type]; %DATA\factory
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
tmp_path = ['DATA' filesep noise_type filesep 'dnn']; %DATA\factory\dnn
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
tmp_path = ['DATA' filesep noise_type filesep 'tmpdir'];%DATA\factory\tmpdir
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;

% E:\myMatlab\SENN\DNN_toolbox\DATA\factory\tmpdir
TMP_DIR_PATH = [pwd filesep 'DATA' filesep noise_type filesep 'tmpdir'];

% copy config from mainpath to DATApath ('source','destination')
copyfile('config',['DATA' filesep noise_type filesep 'config']);

% get the file_ID of  'DATA\factory\dnn\feat_list', frecord the featuretype
% and noise type
% 'w', --Open or create new file for writing. Discard existing contents, if any.
fid = fopen(['DATA', filesep, noise_type, filesep, 'dnn', filesep, 'feat_list'],'w');
tmp_str = ['d_' noise_type '_'  feat_type '.mat'];
fprintf(fid,'%s\n', tmp_str);
fclose(fid);

% print config
fprintf(1,'\n train_list=%s \ntest_list=%s \nnoise_cut=%f \n',train_list, test_list, noise_cut);
fprintf(1,'dB: '); disp(mix_dB);
fprintf(1,'feat_type:%s, noise_type:%s\n', feat_type, noise_type);

% get # of test/train mixtures 
% number of the mixtured test files
test_filename=textscan(fopen(test_list),'%s');
num_test = numel(test_filename{1});

% number of the clean train files
train_filename=textscan(fopen(train_list),'%s');
num_clean = numel(train_filename{1});
% number of the mixtured train files, can generated from same clean file
num_train = num_clean * repeat_time;

%% start DNN based speech separation
% 1. generate training/test mixtures 
if is_gen_mix == 1  
    addpath(genpath([mainpath filesep 'gen_mixture']));
    fprintf(1, '\n\n##########################################\n');
    fprintf('Start to generate training/test mixtures \n\n\n');
	addpath(genpath([mainpath, filesep, 'gen_mixture']));
    % test mixtures
	get_all_noise_test(noise_type, noise_cut, mix_dB, test_list, TMP_DIR_PATH);
    % training mixtures
	get_all_noise_train(noise_type, noise_cut, mix_dB, repeat_time, train_list, TMP_DIR_PATH);
end

% 2. generate features and ideal masks
if is_gen_feat == 1
    addpath(genpath([mainpath filesep 'get_feat']));
    fprintf(1, '\n\n##########################################\n');
    fprintf(1, 'Start to generate features and ideal masks \n\n\n');
	addpath(genpath([mainpath filesep 'get_feat']));   
    START = 1;
	% test features istrain = -1 
    run_every(feat_type, noise_type, -1, START, num_test, mix_dB, MASK_index,TMP_DIR_PATH);
	% training features istrain = 1 
    run_every(feat_type, noise_type, 1, START, num_train, mix_dB, MASK_index,TMP_DIR_PATH);
end

% 3. dnn training/test
if is_dnn == 1
    addpath(genpath([mainpath filesep 'dnn']));
    % mean variance normalization
    mov_order =0; % 0 degenerates to no ARMA
	
   
end
draw;
cd(mainpath);
diary off;
disp(datetime('now'));