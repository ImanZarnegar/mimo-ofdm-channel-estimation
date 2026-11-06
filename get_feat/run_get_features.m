function [feat_data,feat_label,DFI]=run_get_features(feat_para, MIXDATA_PATH,istrain)
% this funciton is to set the parameters for feature extraction
% istrain is to distinguish the test and trains

% the input
feat_start=feat_para.start;
feat_end=feat_para.end;
feat_set_size=feat_para.size;
offset=feat_para.offset;

rng default;

% Load the mixed data: speech noise and noisy
MAT = matfile(MIXDATA_PATH,'Writable',false); %read only
speech_cell =  MAT.speech_cell(1,feat_start:feat_end);
noise_cell =  MAT.noise_cell(1,feat_start:feat_end);
mix_cell =  MAT.mix_cell(1,feat_start:feat_end);
c_mat = MAT.c_mat(1,feat_start:feat_end); % the constant scale value

%% obtain the features
if( strcmp(feat_para.fun_name,'Comp_feat' ))
    % labels mean the targets
    feat_data_set = cell(1, feat_set_size);
    feat_label_set = cell(1, feat_set_size); % labels mean the targets
    
    % use the parallel toolbox
    parfor i=1:feat_set_size
        % nframe*(feature size = 246), recover the normal energy of mix
        [feat_data_set{i}, feat_label_set{i}] = tag_lab(mix_cell{i}, c_mat(i), speech_cell{i}, noise_cell{i},feat_para);     
        fprintf(1,'index = %d\n',i);
    end
    
    % save the memory
    clear mix_cell speech_cell noise_cell;
    
    % for trainning data, they dont care where to start and end (continuity) 
    DFI = zeros(feat_set_size,2); % double frame index
    start_pointer =1;
    stop_pointer = 0;
    
    % concate the set matrices into one matrix and get the DFI of the test
    disp('Start combination--------------');
    feat_data = cell2mat(feat_data_set);  %[feat_data,feat_data_set{i}]; conncet the time axis
    clear feat_data_set;    
    for i =1:feat_set_size
        stop_pointer = stop_pointer + size(feat_label_set{i},2); %the OFFSET 
        DFI(i,:) = [start_pointer, stop_pointer];
        start_pointer = start_pointer + size(feat_label_set{i},2); %the OFFSET
    end
    feat_label = cell2mat(feat_label_set); %[feat_label,feat_label_set{i}];
    
    clear feat_label_set;
    % transpose the matrix
    feat_data=feat_data.';
    feat_label=feat_label.';
    disp('Finish combination--------------');
    disp(datetime('now'));
    
    if istrain == 1    
        DFI = [];%empty for training data
    end
    
else % no other choices
    fprintf('The feat_para.fun_name is not "Comp_feat"!\n ');
    assert(0);
end

