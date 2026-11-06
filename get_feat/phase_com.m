function [ sc_phase ] = phase_com( s_phase,hop)
%PHASE_COM Summary of this function goes here
%   Detailed explanation goes here
% phase compensation for each frequency bin
% win=hanning(Lw); % exclude the zero ends, may have better phase peaks
% the hop is the time shift

[nf,nt]=size(s_phase);

% compensate the phase based on its corresponding frequency
% construct the compensate phase matrix
com_phase=pi*((1:nf)-1).'/(nf-1)*hop*(1:nt);

sc_phase=wrapToPi(s_phase-com_phase);
% sc_phase=(s_phase-com_phase);

end

