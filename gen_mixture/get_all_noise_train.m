function get_all_noise_train(noise_type, cut, dB, repeat_time, train_list, TMP_STORE)
% This function is used to generate the train noisy files with repeat_time

% addpath(genpath('utility'));
fprintf(1,'noise cut ratio=%f\n',cut);

fprintf(1,'using %s noise\n',noise_type);
generate_train_mix(noise_type, dB, cut, repeat_time, train_list, TMP_STORE);

fprintf(1,'The %s noise have been finished.\n',noise_type);
end
