function [opts]=dnn_para_set(db)

% --setting net params--
opts.cv_interval = 1; % check cv perf. every this many epochs
opts.isPretrain = 0; % pre-training using RBM?
opts.rbm_max_epoch = 20; 
opts.rbm_batch_size = 1024; % batch size for pretraining
opts.rbm_learn_rate_binary = 0.01;
opts.rbm_learn_rate_real = 0.004;

opts.learner = 'ada_sgd'; % 'ada_sgd' or 'sgd'
opts.sgd_max_epoch = 1; % maximum number of training epochs
opts.sgd_batch_size = 1024; % batch size for SGD
opts.ada_sgd_scale = 0.0015; % scaling factor for ada_grad
opts.sgd_learn_rate = linspace(0.08, 0.001, opts.sgd_max_epoch); % linearly decreasing lrate for plain sgd
%  (0.08, 0.001,opts.sgd_max_epoch);
opts.initial_momentum = 0.5;
opts.final_momentum = 0.9;
opts.change_momentum_point = 5;

opts.cost_function = 'mse';
opts.unit_type_output = 'sigm';%sigm or relu or lin

opts.hid_struct = [1024 1024 1024]; % num of hid layers and units


opts.unit_type_hidden = 'relu'; 
if strcmp(opts.unit_type_output,'softmax'); opts.cost_function = 'softmax_xentropy'; end;

opts.isDropout =1; % need dropout regularization
opts.isDropoutInput = 0; % dropout inputs
opts.drop_ratio = 0.2; % ratio of units to drop
opts.train_neighbour = 2; % average along frame axis   -2~+2
opts.label_neighbour = 0; % the output along frame axis   -1~+1

gcount = -1; %detect if gpu is available, if so, enable it
try
   gpuDevice;
   gcount = 1;
catch err
   disp('no gpu available, use cpu instead');
   gcount = 0;
end
if gcount > 0
   gpuobj = gpuDevice;
   gpuDevice(gpuobj.Index);
   opts.isGPU = 1; % use GPU?
else
   opts.isGPU = 0;
   disp('GPU is not available, using CPU.')
end

opts.eval_on_gpu = 1; 
opts.save_on_fly = 0; % save the current best model along the way
opts.db = db;


end
