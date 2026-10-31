function generate_train_mix( noise_type, snr_set, min_cut, repeat_time, train_list, TMP_STORE)
% This function is used to generate the train noisy files

global mainpath;
tmp_str = strsplit(noise_type,'_');
noise_name = tmp_str{1};

fprintf(1,'\nMix Training Set, noise_name = %s repeat_time = %d ######\n',noise_name, repeat_time);

% get the train_list file
train_filename=textscan(fopen(train_list),'%s');
num_clean = numel(train_filename{1});

% initialize the cell for store the train mixture
mix_cell = cell(1,num_clean*repeat_time);
noise_cell = cell(1,num_clean*repeat_time);
speech_cell = cell(1,num_clean*repeat_time);
alpha_mat = zeros(1,num_clean*repeat_time);
c_mat = zeros(1,num_clean*repeat_time);

%% read the files
constant = 5*10e6; % used for engergy normalization for mixed signal
c = 1;
fs_target=16000;

index_sentence = 1;
fid = fopen(train_list);
tline = fgetl(fid);   

% tline = tline(2:end); % only for linux and female!!!!

% tmp noise
[tmp_n,  fs] = audioread([mainpath filesep 'premix_data' filesep 'noise' filesep noise_name '.wav']);   
tmp_n = tmp_n(:,1); 
if fs~=fs_target
    tmp_n = resample(tmp_n, fs_target, fs);
end
% only take the first half of the noise
tmp_n = tmp_n(1:floor(length(tmp_n)*min_cut));
double_n_tmp = [tmp_n; tmp_n]; %wrap around

while ischar(tline)
    [s,  s_fs] = audioread([mainpath filesep 'premix_data' filesep 'clean_speech' filesep tline]);
    if s_fs~=fs_target
        s = resample(s, fs_target, s_fs); %resamples to 16000 samples/second
    end

    for var_ind = 1:repeat_time
        %choosing a point where we start to cut
        start_cut_point = randi(length(tmp_n));

        %cut
        n = double_n_tmp (start_cut_point:start_cut_point+length(s)-1);

        %compute the unprocessed SNR
        snr_f = 20*log10(norm(s)/norm(n));%sum(s.^2)/sum(n.^2));
        alpha = sqrt( db2pow(snr_f)/db2pow(snr_set) );
        
        %check SNR
        snr = 20*log10(norm(s)/norm(alpha*n));
        assert(abs(snr_set-snr)<0.01,'the snr set is not achieved!');

        % chang the noise energy with alpha
        mix = s + alpha*n;
        
        % make the energy of c to be a constant
        c = sqrt(constant * length(mix)/sum(mix.^2));
        mix = mix*c;
%         after_constant = sum(mix.^2)/length(mix);

        store_index = (index_sentence-1)*repeat_time + var_ind;

        mix_cell{store_index} = single(mix);
        speech_cell{store_index} = single(s);
        noise_cell{store_index} = single(alpha*n);
        alpha_mat(store_index) = alpha;
        c_mat(store_index) = c;

        fprintf(1,'name=%s before_snr=%f, using db=%d, after_snr=%f, index_sentence=%d var_ind=%d store_ind=%d\n',...
            tline, snr_f, snr_set, snr, index_sentence, var_ind, store_index);

    end    
        tline = fgetl(fid);
        index_sentence =index_sentence +1;
end

fclose(fid);

save_path = [TMP_STORE filesep 'db' num2str(snr_set)];
if ~exist(save_path,'dir'); mkdir(save_path); end;
save_path = [TMP_STORE filesep 'db' num2str(snr_set) filesep 'mix'];
if ~exist(save_path,'dir'); mkdir(save_path); end;

save([save_path,filesep, 'train_', noise_type, '_mix.mat'],...
    'mix_cell', 'speech_cell', 'noise_cell', 'c_mat', '-v7.3');
end