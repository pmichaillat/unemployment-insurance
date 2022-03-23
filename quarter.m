%=======================================================================
% transform the array from monthly frequency to quarterly frequency.
% assumes always starts in january and finishes in december (number of observations can be divided by 3)
% observation must be in columns
%=======================================================================

function RES=quarter(DAT)

[r,c]=size(DAT);
L=reshape(DAT,3,r/3,c);
M=mean(L,1);
RES=shiftdim(M);