%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 4.6                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                       Full Flash & Two Steps Converter                  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
              %-----------------------------------------------------------%
              % for full-flash flag_flash=0                               %
flag_flash=1; %                                                           %
              % for two-steps flag_flash=1                                %
              %-----------------------------------------------------------%
              
              %-----------------------------------------------------------%
              % if flag_ramp=1 the input is a ramp starting from 0        % 
flag_ramp=0;  %                                                           %
              % if flag_ramp is not 1 the input is a sine wave            %
              %-----------------------------------------------------------%

%-------------------------------------------------------------------------%
%                         Simulation parameters                           %
%-------------------------------------------------------------------------%
             
points=2^10;
t=[1:points];

nbit_coarse=4;              % Coarse Conversion
nbit_fine=4;                % Fine   Conversion
Res_gain=2^nbit_coarse;     % Residue Gain

%-------------------------------------------------------------------------%
%                         Input signal                                    %
%-------------------------------------------------------------------------%
ampl=0.989;
in_offset=0;
full_scale=2;
n_sine=29;
freq=n_sine/points;
x=ampl*sin(2*pi*freq*t)+full_scale/2+0.000001*rand(1,points)+in_offset;

if flag_ramp==1
    x=ampl*t/points+in_offset;
end

%-------------------------------------------------------------------------%
nbit=nbit_coarse+nbit_fine*flag_flash;
nbinc=2^nbit_coarse;
nbinf=2^nbit_fine;

%-------------------------------------------------------------------------%
%                       Coarse ADC Characteristics                        %
%-------------------------------------------------------------------------%

offset=0; 
dnl=0.9/2^nbit_coarse; 
firstbin=0;  
lastbin=full_scale;
yc=statchar(nbinc+1,offset,dnl,firstbin,lastbin,0);
dnl

%-------------------------------------------------------------------------%
%                              Distortion                                 %
%-------------------------------------------------------------------------%

sec=0; 
third=0.0; 
fourth=0; 
fifth=0;
ycoarse = dist(yc,sec,third,fourth,fifth);

%-------------------------------------------------------------------------%
%                          DAC characteristics                            %
%-------------------------------------------------------------------------%

offset=0; 
dnl=0./2^nbit_coarse; 
firstbin=0;  
lastbin=full_scale;
yd=statchar(nbinc+1,offset,dnl,firstbin,lastbin,0);

%-------------------------------------------------------------------------%
%                              Distortion                                 %
%-------------------------------------------------------------------------%

sec=0; 
third=0.0; 
fourth=0; 
fifth=0;
yDAC = dist(yd,sec,third,fourth,fifth);

%-------------------------------------------------------------------------%
%                         Fine ADC Characteristics                        %
%-------------------------------------------------------------------------%

offset=0; 
dnl=0.; 
firstbin=0;  
lastbin=full_scale;
yf=statchar(nbinf+1,offset,dnl,firstbin,lastbin,0);

%-------------------------------------------------------------------------%
%                              Distortion                                 %
%-------------------------------------------------------------------------%

sec=0; 
third=0.0; 
fourth=0; 
fifth=0;
yfine = dist(yf,sec,third,fourth,fifth);

%-------------------------------------------------------------------------%
%                              CONVERSION                                 %
%-------------------------------------------------------------------------%

for i=1:points
    
%-------------------------------------------------------------------------%
%                           coarse conversion                             %
%-------------------------------------------------------------------------%
 
[out_coarse(i),comp]=Flash(x(i),ycoarse);
if out_coarse(i)<=1
   out_coarse(i)=1;
end
if out_coarse(i)>=nbinc;
   out_coarse(i)=nbinc;
end

%----------------------------- Residual ----------------------------------%

yout(i)=yDAC(out_coarse(i));
res(i)=(x(i)-yout(i))*Res_gain;

%-------------------------------------------------------------------------%
%                             fine conversion                             %
%-------------------------------------------------------------------------%

[out_fine(i),comp]=Flash(res(i),yfine);
if out_fine(i)<=1
   out_fine(i)=1;
end
if out_fine(i)>=nbinf;
   out_fine(i)=nbinf;
end

end

out=(out_coarse-1)*2^nbit_fine+(out_fine-1)*flag_flash;

%------------------------------Graphics-----------------------------------%
%                                                                         %
%   figure(1)  -->  output error                                          %
%   figure(2)  -->  Figure 4.15 page 163                                  %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
clf;
xc=[0:2^nbit_coarse]*ycoarse(2^nbit_coarse+1)/(2^nbit_coarse);
plot(ycoarse-xc);
xlim([1 nbit]);
grid on;

if flag_ramp ~= 1
    plot_spectrum(points,freq, out)
end
