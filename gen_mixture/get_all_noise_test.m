function get_all_noise_test(noise_type, noisecut, snr_set, test_list,  TMP_DIR_PATH)
% This function is used to generate the test noisy files
% Input: (noise_type, noise_cut, mix_db, test_file_list, TMP_DIR_PATH)

% addpath(genpath('utility'));??
% global min_cut; %seem not need to be global

fprintf(1,'noise cut ratio=%f\n',noisecut);

fprintf(1,'using %s noise\n',noise_type);
generate_test_mix(noise_type, noisecut, snr_set, test_list, TMP_DIR_PATH);

fprintf(1,'The %s noise have been finished.\n', noise_type);
end
