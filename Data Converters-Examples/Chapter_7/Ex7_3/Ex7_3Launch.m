%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 7.3                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   1. Plots the Power Spectral Density of the bit-stream                 %
%   2. Calculates the SNR                                                 %
%   3. Calculates histograms at the integrator outputs                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

t0=clock;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%
bw=22.05e3;				% Base-band
R=64;                   % Oversampling
Fs=R*2*bw;				% Oversampling frequency
Ts=1/Fs;
N=1024*16;				% Samples number
nper=61;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		% Input signal frequency in radians

% ************************************************************************

A1=10^8;
A2=10^8;
A3=10^8;
A4=10^8;
gain1=A1/(A1+2);
gain2=A2/(A2+2);
gain3=A3/(A3+2);
gain4=A4/(A4+2);
delta1=(A1+1)/(A1+2);
delta2=(A2+1)/(A2+2);
delta3=(A3+1)/(A3+2);
delta4=(A4+1)/(A4+2);
sat1=1.95;
sat2=4;
sat3=4;
sat4=4;
scal1=1;
scal2=1;
Amp_dB=-10.1;  
Ampl=10^(Amp_dB/20);
Ntransient=100;

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex7_3', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

%-------------------------------------------------------------------------%
%       Calculates SNR and PSD of the bit-stream and of the signal        %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs;			% Normalized signal frequency
fB=N*(bw/Fs);		% Base-band frequency bins
yy1=zeros(1,N);
yy1=yout(2+Ntransient:1+N+Ntransient)';

ptot=zeros(1,N);
[snr,ptot]=calcSNR(yy1(1:N),f,fB,w',N);
%
Rbit=(snr-1.76)/6.02;	% Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                               Plots                                     %
%-------------------------------------------------------------------------%

figure(2);
clf;
hold on
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'b');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

