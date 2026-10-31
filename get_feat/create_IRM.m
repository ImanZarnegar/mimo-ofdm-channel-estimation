function [IRM] = create_IRM( cleansp, noisesp, beta)
%CREATE_IRM Summary of this function goes here
%   Detailed explanation goes here
% xxsp is the spectral of the speech and noise
%   beta is the parameter control the energy ratio: (s^2/(s^2+n^2))^beta
% m is smooth factor along frame axis sum(-m~+m)/(2*m+1)
% ---------------------2017/2/28-----------------------------------

if nargin==3
    m=1;
end

assert(isequal(size(cleansp),size(noisesp)),'The size of the sps are unequal!');
assert(fix(m)==m&&(m>=1),'m should be an interger >=1');

IRM = (abs(cleansp).^2)./(abs(noisesp).^2+abs(cleansp).^2);
IRM= IRM.^beta;


% smooth the feature along the time frame axis
% auto-regressive moving average (ARMA) filter
% IRM_smooth=zeros(size(IRM)); % a nonbinary matrix
% 
% if m>1
%     % number of frame (time)
%     nt=size(IRM,2);
%     for ti=1:nt
%         IRM_smooth(:,ti)=mean(IRM(:,max(1,ti-m):min(nt,ti+m)),2);
%     end
% else
%     IRM_smooth=IRM;
% end

end

