function x=statchar(nbin,offset,dnl,firstbin,lastbin,half)

% function x=statchar(nbin,offset,dnl,firstbin,lastbin,half)
% nbin            
% offset, absolute value
% dnl in LSB
% firstbin value of the first bin
% lastbin  value of the last bin
% if half=1 the first and the last quantization intervals are half LSB

bin=[1:nbin];
err=(rand(1,nbin)-0.5)*dnl*(lastbin-firstbin)/(nbin-1);
x=offset+firstbin+(bin-1-half*0.5)*(lastbin-firstbin)/(nbin-1-half)+err;
x(1)=firstbin;
x(nbin)=lastbin;
