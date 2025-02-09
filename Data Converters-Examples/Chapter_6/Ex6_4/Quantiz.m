function out = Quantiz(in,VrefN,VrefP,NComp)

% generates the ideal flash ADC output with half LSB at the
% two sides of the reference range
%
% out = flashADC(in,VrefN,VrefP,NComp)
%
% in:       input signal
% VrefN:    lower reference
% VrefN:	higer reference
% NComp:	number of comparators
%
% out:		Output signal amplitude


Vfs=VrefP-VrefN;
Delta=(VrefP-VrefN)/NComp;
Ndelta=ceil((in-VrefN+eps)/(Delta/2));
code=floor(Ndelta/2+eps);
out=VrefN+code*Delta;

