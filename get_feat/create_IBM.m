function  [IBM] = create_IBM( cleansp, noisesp, LC)
%CREATE_MASK Summary of this function goes here
%   Detailed explanation goes here
% xxsp is the spectral of the speech and noise
% LC is the threshold with dB form
% m is smooth factor along frame axis sum(-m~+m)/(2*m+1)
% ---------------------2017/2/28-----------------------------------

if nargin==3
    m=1;
end

assert(isequal(size(cleansp),size(noisesp)),'The size of the sps are unequal!');
assert(fix(m)==m&&(m>=1),'m should be an interger >=1');

IBM=zeros(size(cleansp));

ibm_index= abs(cleansp)./abs(noisesp)>10^(LC/20) ;
IBM(ibm_index)=1;

% smooth the feature along the time frame axis
% auto-regressive moving average (ARMA) filter
% IBM_smooth=zeros(size(IBM)); % a nonbinary matrix
% IBM_s= zeros(size(IBM)); % a binary matrix is better under low SNR

% if m>1
%     % number of frame (time)
%     nt=size(IBM,2);
%     for ti=1:nt
%         IBM_smooth(:,ti)=mean(IBM(:,max(1,ti-m):min(nt,ti+m)),2);
%     end
%     IBM_s(IBM_smooth>=0.5)=1; % this threshold should be considered
% else
%     IBM_s=IBM;
% end

end

