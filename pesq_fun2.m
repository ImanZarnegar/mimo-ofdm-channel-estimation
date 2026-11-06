function [pesq_perf]=pesq_fun2(mix_s,clean_s,ideal_r,est_r, fs,WAV_path) 
num_test_sents = length(mix_s);
est_pesq = zeros(num_test_sents,1);
ideal_pesq = zeros(num_test_sents,1);
unproc_pesq =zeros(num_test_sents,1);

pesq_perf.est_pesq = est_pesq;
pesq_perf.ideal_pesq = ideal_pesq;
pesq_perf.unproc_pesq = unproc_pesq;

disp('finish waves');

end