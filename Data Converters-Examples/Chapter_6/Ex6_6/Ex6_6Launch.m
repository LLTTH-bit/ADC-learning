%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 6.6                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   1. Plots the Power Spectral Density of the bit-stream                 %
%   2. Calculates the SNR                                                 %
%   3. Calculates histograms at the integrator outputs                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

t0=clock;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

bw=22.05e3;				% Base-band
R=64;                   % Oversampling
Fs=R*2*bw;				% Oversampling frequency
Ts=1/Fs;
N=1024*8;				% Samples number
nper=93;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		% Input signal frequency in radians
Amp_dB=-3;              % Input amblitude in dB

Ampl=10^(Amp_dB/20)-pi/1024;
Ntransient=100;

VrefN=-1;
VrefP=1;
Ncomp=7;
Delta=(VrefP-VrefN)/Ncomp

%*************************************************************************%
Feedforward=1;
%*************************************************************************%

s0=sprintf('** Simulation Parameters **');
s1=sprintf('   Fs(Hz)=%1.0f',Fs);
s2=sprintf('   Ts(s)=%1.6e',Ts);
s3=sprintf('   Fin(Hz)=%1.4f',Fin);
s4=sprintf('   BW(Hz)=%1.0f',bw);
s5=sprintf('   OSR=%1.0f',R);
s6=sprintf('   Npoints=%1.0f',N);
s7=sprintf('   tsim(sec)=%1.3f',N/Fs);
s8=sprintf('   Nperiods=%1.3f',N*Fin/Fs);
disp(s0)
disp(s1)
disp(s2)
disp(s3)
disp(s4)
disp(s5)
disp(s6)
disp(s7)
disp(s8)

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_6', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

%-------------------------------------------------------------------------%
%       Calculates SNR and PSD of the bit-stream and of the signal        %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs			% Normalized signal frequency
fB=N*(bw/Fs)		% Base-band frequency bins
yy1=zeros(1,N);
yy1=yout(2+Ntransient:1+N+Ntransient)';


ptot=zeros(1,N);
[snr,ptot]=calcSNR(yy1(1:N),f,fB,w',N);
Rbit=(snr-1.76)/6.02;	% Equivalent resolution in bits

%-------------------------------------------------------------------------%
%           Calculates amplitudes of output sine wave                     %
%-------------------------------------------------------------------------%

input=in(2+Ntransient:1+N+Ntransient)';
ampin=sinusx(input,f,N);
ampout=sinusx(yy1,f,N);

%-------------------------------------------------------------------------%
%                               Plots                                     %
%-------------------------------------------------------------------------%

figure(2);
clf;
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD with Saturation in Both Integrators')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);
text_handle = text(floor(Fs/R),-15, sprintf('SNR = %4.1fdB @ OSR=%d\n'...
    ,snr,R));
text_handle = text(floor(Fs/R),-30, sprintf('Rbit = %2.2f bits @ OSR=%d\n'...
    ,Rbit,R));

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

%-------------------------------------------------------------------------%
%                   Histograms of the integrator outputs                  %
%-------------------------------------------------------------------------%

figure(1)
nbins=200;
[bin1,xx1]=hist(y1, nbins);
clf;
plot(xx1, bin1)
%axis([-0.2 0.2 0 100])
grid on;
title('First Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')

MaxY1=max(abs(y1))
MaxY2=max(abs(y2))
STF_mod_dB=20*log10(max(abs(ampout))/Ampl)
