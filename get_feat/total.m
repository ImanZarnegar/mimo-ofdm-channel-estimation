function  total(feat, noise, istrian, START, END, snr_set, MASK_index, TMP_STORE)
% this function print the information of the noise and the features
% (feat_type, noise_type, -1, 1, num_test, mix_db, MASK_index, TMP_DIR_PATH)
% part is for distinguish test and train

    tic;
    fprintf(1,'start noise:%s  feat:%s\n',noise, feat);
    run_every(feat, noise, istrian, START, END, snr_set, MASK_index,TMP_STORE);
    fprintf(1,'finish noise:%s  feat:%s\n',noise, feat);
    seconds = toc;
    fprintf(1,'%f seconds spent on the noise:%s feat:%s\n', seconds, noise, feat);
end
