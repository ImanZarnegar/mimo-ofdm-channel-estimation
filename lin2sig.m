C = 0.1;
K =10;

mask = feat_label;

%% for PSM
usesigmode=1;
if(usesigmode==1)
    % compress to [0,1]
    PSM =2*mask-1;
    PSM = max(min(PSM,0.999),-0.999);
    oPSM =  -1/C*log((1-PSM)./(1+PSM));
else
    % using lin output
%     oPSM =  -1/C*log((1-mask/K)./(1+mask/K));
    PSM = max(min(mask/K,0.999),-0.999);
    oPSM =  -1/C*log((1-PSM)./(1+PSM));
end

% the target K and C
C = 1;
K =10;
% compress to [-1,1]
oPSM = max(-50,min(50,oPSM));

% usesigmode=1;
if(usesigmode==1)
    % compress to [0,1]
    PSM = (1-exp(-C*oPSM))./(1+exp(-C*oPSM));
    PSM = PSM/2+0.5;
else
    % using lin output
    % PSM = tanh(0.5*C*oPSM); %not accurate
    PSM = (1-exp(-C*oPSM))./(1+exp(-C*oPSM));
    PSM = PSM*K;
end

histogram(PSM);

% feat_label = PSM;
