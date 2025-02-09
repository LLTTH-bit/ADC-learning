%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 8.1                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

Fs=1;  				                       % Sampling frequency
bw=0.5;                                    % Base-band
R=Fs/(2*bw);                               % OSR
Ts=1/Fs;                                   % Sampling time
N=2^12;		      		                   % Number of samples
nper=1111;                                 % Number of point location for input frequency
Fin=nper*Fs/N;			                   % Input signal frequency (Fin = nper*Fs/N)

input=-6;                                  % Input magnitude(dB)
Vref=1;                                    % Pre-quantizer reference voltage (+/-1V)
in=10^(input/20)*Vref;                     % input amplitude (V)
st=N*Ts+1000;                                   % Simulation Time
Ntransient=1;

D=1/16
ic=[-2 4 6 -1 3 -6 5 1]
i1=ic(1)*D;
i2=ic(2)*D;
i3=ic(3)*D;
i4=ic(4)*D;
i5=ic(5)*D;
i6=ic(6)*D;
i7=ic(7)*D;
i8=ic(8)*D;

alpha(1:7)=0.1^2*randn(1,7)
a0=alpha(1);
a1=alpha(2);
a2=alpha(3);
a3=alpha(4);
a4=alpha(5);
a5=alpha(6);
a6=alpha(7);

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%
%%%%%%%%%
flag=1  %
%%%%%%%%%
options=simset('InitialStep', 1, 'RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex8_1', (N+Ntransient)/Fs, options);	    %Starts Simulink simulation

%-------------------------------------------------------------------------%
%       Calculates SNR and PSD of the bit-stream and of the signal        %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs;			                          % Normalized signal frequency
fB=N*(bw/Fs);		                          % Base-band frequency bins

yy1=zeros(1,N);
yy1=simout(1+Ntransient:N+Ntransient)';

ptot1=zeros(1,N);
[snr1,ptot1,psig1]=calcSNR(yy1(1:N),f,fB,w',N,Vref);
set(gca,'Xscale', 'linear')
SNR1=snr1
bit1=(snr1-1.76)/6.02	                    % Equivalent resolution in bits

%%%%%%%%%
flag=-1 %
%%%%%%%%%
options=simset('InitialStep', 1, 'RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex8_1', (N+Ntransient)/Fs, options);	   %Starts Simulink simulation

w=hann(N);
f=Fin/Fs;			                                    % Normalized signal frequency
fB=N*(bw/Fs);		                                    % Base-band frequency bins

yy2=zeros(1,N);
yy2=simout(1+Ntransient:N+Ntransient)';

ptot2=zeros(1,N);
[snr2,ptot2,psig2]=calcSNR(yy2(1:N),f,fB,w',N,Vref);
set(gca,'Xscale', 'linear')
SNR2=snr2
bit2=(snr2-1.76)/6.02	                        % Equivalent resolution in bits


figure(1);
subplot(2,1,1)
plot(linspace(0,Fs/2,N/2), ptot2(1:N/2), 'r');
grid on;
xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [ dB ]')
axis([0 Fs/2 -100 0]);

subplot(2,1,2)
plot(linspace(0,Fs/2,N/2), ptot1(1:N/2), 'b');
grid on;

xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [ dB ]')
axis([0 Fs/2 -100 0]);
grid on;
