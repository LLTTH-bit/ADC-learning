%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 6.3                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

t0=clock;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

R=64;                    % Oversampling
Fs=50e6;    		      % Sampling frequency
Ts=1/Fs;
bw=Fs/2/R;
N=1024*8;				  % Samples number
nper=23;
Fin=nper*Fs/N;			  % Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		  % Input signal frequency in radians
Amp_dB=-6;                % Input amblitude in dB

Ampl=10^(Amp_dB/20)-pi/1024;
Ntransient=100;

% ************************************************************************
Gain1=100000;
alpha1=1-1/Gain1;
Amax1=200;
sr1=79e6;
GBW1=30000e6;
Gain2=100000;
alpha2=1-1/Gain2;
Amax2=200;
sr2=325e6;
GBW2=100e6;
% ************************************************************************

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
sim('Ex6_3', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

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
Rbit=(snr-1.76)/6.02;	% Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                               Plots                                     %
%-------------------------------------------------------------------------%
ptot=ptot-max(ptot)+Amp_dB;
figure(1);
clf;
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD with SR in the First Op-Amp 200 V/\mus')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -140 0]);
text_handle = text(floor(Fs/R),-10, sprintf('\\bfSNR = %4.1fdB,  OSR=%d\n',...
    snr,R));
text_handle = text(floor(Fs/R),-20, sprintf('\\bfRbit= %2.2f bits,OSR=%d\n',...
    Rbit,R));

%-------------------------------------------------------------------------%
%                         Delta Out Integreators                          %
%-------------------------------------------------------------------------%

% ************************************************************************
% Delta Out Integrators 
% ************************************************************************

DeltaOut1Max=max(abs(yout1))
DeltaOut2Max=max(abs(yout2))



