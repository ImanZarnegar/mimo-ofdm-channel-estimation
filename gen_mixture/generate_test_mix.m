function generate_test_mix( noise_type, min_cut, snr_set, test_list,  TMP_DIR_PATH)
% This function is used to generate the test noisy files

% warning('off','all');
global mainpath;
% disp(mainpath);

% truncate the first part of the noise_type
tmp_str = strsplit(noise_type,'_');
noise_name = tmp_str{1};

fprintf(1,'\nMix Test Set, noise_name = %s ######\n\n',noise_name);

% get the test_list file
test_filename=textscan(fopen([mainpath filesep test_list]),'%s');
num_test = numel(test_filename{1});
% num_sent = numel(textread(test_list,'%1c%*[^\n]')); 

% initialize the cell for store the test mixture
mix_cell = cell(1,num_test);
noise_cell = cell(1,num_test);
speech_cell = cell(1,num_test);
alpha_mat = zeros(1,num_test);
c_mat = zeros(1,num_test);

%% read the files
constant = 5*10e6; % used for engergy normalization for mixed signal
c = 1;
fs_target=16000; %16kHz

index_sentence = 1;
iteration = 1;

% Read line from file, removing newline characters
% get the test_list file, if we put it up, there may be conflict
fid = fopen([mainpath filesep test_list]);
tline = fgetl(fid);

% tline = tline(2:end); % only for linux female!!!

% tmp noise
[tmp_n,  fs] = audioread([mainpath filesep 'premix_data' filesep 'noise' filesep noise_name '.wav']);   
tmp_n = tmp_n(:,1);
if fs~=fs_target
    tmp_n = resample(tmp_n, fs_target, fs); %resamples to 16000 samples/second
end
% only take the second part of the noise
tmp_n = tmp_n(ceil(length(tmp_n)*min_cut):end-7*16000);

while ischar(tline)
    %IEEE sentence read from test_list: signals
    [s,  s_fs] = audioread([mainpath filesep 'premix_data' filesep 'clean_speech' filesep tline]);
    if s_fs~=fs_target
        s = resample(s, fs_target, s_fs); %resamples to 16000 samples/second
    end
    
    %choosing a point where we start to cut
    start_cut_point = randi(length(tmp_n)-length(s)+1);

    %cut
    n = tmp_n (start_cut_point:start_cut_point+length(s)-1);

    %compute the unprocessed SNR
    snr_f = 20*log10(norm(s)/norm(n));%sum(s.^2)/sum(n.^2));

    alpha = sqrt( db2pow(snr_f)/db2pow(snr_set) );
%     alpha = sqrt(  sum(s.^2)/(sum(n.^2)*10^(snr_set/10)) );

    %check SNR
    snr = 20*log10(norm(s)/norm(alpha*n));%sum(s.^2)/sum((alpha.*n).*(alpha.*n)));
    assert(abs(snr_set-snr)<0.01,'the snr set is not achieved!');
    
    % chang the noise energy with alpha
    mix = s + alpha*n;

    % make the energy of c to be a constant
    c = sqrt(constant * length(mix)/sum(mix.^2));
    mix = mix*c;
%     after_constant = sum(mix.^2)/length(mix); 

    % make the percision to be single
    mix_cell{index_sentence} = single(mix);
    speech_cell{index_sentence} = single(s);
    noise_cell{index_sentence} = single(alpha*n);
    alpha_mat(index_sentence) = alpha;
    c_mat(index_sentence) = c;

    
    fprintf(1,'name=%s before_snr=%f, using db=%d, after_snr=%f, index_sentence=%d\n',...
                    tline, snr_f, snr_set, snr, index_sentence);
    
    iteration = iteration + 1;
    index_sentence =index_sentence +1;
    
    %read next line from list.txt
    tline = fgetl(fid);
end
fclose(fid); 

save_path = [TMP_DIR_PATH filesep 'db' num2str(snr_set)];
if ~exist(save_path,'dir'); mkdir(save_path); end;
save_path = [TMP_DIR_PATH filesep 'db' num2str(snr_set) filesep 'mix'];
if ~exist(save_path,'dir'); mkdir(save_path); end;

save([save_path,filesep,'test_', noise_type, '_mix.mat'],...
    'mix_cell', 'speech_cell', 'noise_cell', 'c_mat', '-v7.3');
% warning('on','all');
end
