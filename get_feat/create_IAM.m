function [IAM] = create_IAM( cleansp, noisysp, feat_para)
%CREATE_IRM Summary of this function goes here
%   Detailed explanation goes here
% ---------------------2017/12/05-----------------------------------

assert(isequal(size(cleansp),size(noisysp)),'The size of the sps are unequal!');

% the original IAM
oIAM = abs(cleansp)./abs(noisysp);

usesigmode=feat_para.usesigmode;

if(usesigmode==1)
	%  truncate into [0,1]
	IAM = max(0,min(1,oIAM));
else
    C = feat_para.C;
    K =feat_para.K;
    % using lin output
    IAM = (1-exp(-C*oIAM))./(1+exp(-C*oIAM));
    IAM = IAM*K;
end

end

