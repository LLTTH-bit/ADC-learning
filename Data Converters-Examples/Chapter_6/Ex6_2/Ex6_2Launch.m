%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 6.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear

t0=clock;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

R=256;                   % Oversampling
Fs=2e6;    				 % Oversampling frequency
Ts=1/Fs;
bw=Fs/2/R;
N=1024*32;				% Samples number
nper=31;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		% Input signal frequency in radians
Amp_dB=-10;             % Input amblitude in dB

Ampl=10^(Amp_dB/20)-pi/1024;
Ntransient=100;

Delta=2

% ************************************************************************
A0=100;
C1=1;
C2=1;
gainerr1=A0/(A0+1+C1/C2)
phaseerr1=(1+A0)*C2/((1+A0)*C2+C1)
C1=1;
C2=1;
gainerr2=A0/(A0+1+C1/C2);
phaseerr2=(1+A0)*C2/((1+A0)*C2+C1)
gaindc=(1-phaseerr1)*(1-phaseerr2)
floordc=10*log10(gaindc^2/N*2)

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
sim('Ex6_2', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

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
title('PSD with Saturation in Both Integrators')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);
text_handle = text(floor(Fs/R/2),-15, sprintf...
    ('\\bfA_0=100 SNR = %4.1fdB,  OSR=%d\n',snr,R));
text_handle = text(floor(Fs/R/2),-25, sprintf...
    ('\\bfA_0=100 Rbit= %2.2f bits,OSR=%d\n',Rbit,R));

% ************************************************************************
A0= 100000;
C1=1;
C2=1;
gainerr1=A0/(A0+1+C1/C2)
phaseerr1=(1+A0)*C2/((1+A0)*C2+C1);
C1=1;
C2=1;
gainerr2=A0/(A0+1+C1/C2)
phaseerr2=(1+A0)*C2/((1+A0)*C2+C1);
% ************************************************************************

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_2', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

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
hold on
figure(1);
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'b');
grid on;
title('PSD with and without Finite Gain')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);
axis([0 Fs/2 -200 0]);
text_handle = text(floor(Fs/R/2),-175, sprintf...
    ('\\bfSNR  Ideal= %4.1fdB,   OSR=%d\n',snr,R));
text_handle = text(floor(Fs/R/2),-185, sprintf...
    ('\\bfRbit Ideal= %2.2f bits, OSR=%d\n',Rbit,R));