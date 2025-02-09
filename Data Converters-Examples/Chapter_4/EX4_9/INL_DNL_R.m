function [DNL,INL,ideal,real,in,co,edges]=INL_DNL_R(in_source,in_conv,n_bin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   DNL and INL calculation with an input ramp                             %
%                                                                         %
%   in_conv       Input data from the output of the converter             %
%   in_source     Input of the Converter                                  %
%   n_bin         Number of bins                                          %
%                                                                         %
%   DNL           Differential nonlinearity                               %
%   INL           Integral nonlinearity                                   %
%                                                                         %
%   ideal         Hystogram of the source data                            %
%   real          Hystogram of the input data                             %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

size_c=size(in_conv);
if size_c(1)==1
    in_conv=in_conv';
end
size_s=size(in_source);
if size_s(1)==1
    in_source=in_source';
end
size_c=size(in_conv);
size_s=size(in_source);
points_c=size_c(1);
points_s=size_s(1);
points=min([points_c points_s]);
in=in_source([1:points]);
co=in_conv([1:points]);

% offset and gain = 1
in1=in(1);
inp=in(points);
in=(in-in1)/(inp-in1);

co1=co(1);
cop=co(points);
co=(co-co1)/(cop-co1);

edges=[0, 1:n_bin];
edges=(edges)/n_bin;

ideal=histc(in,edges);
real=histc(co,edges);
mismatch=real-ideal;
SxLSB=points/n_bin;
DNL=mismatch./SxLSB;
DNL(1)=DNL(2);
DNL(n_bin)=DNL(n_bin-1);
DNL(n_bin+1)=DNL(n_bin);
INL=cumsum(DNL);
INL=INL-edges'*INL(n_bin+1);
