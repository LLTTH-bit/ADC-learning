%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 3.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%               Resistive divider: effect of the random error             %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

N=2^12;                         % The input sequence is made by 2^12 points
Nbit=10;                        % 10-bit Resistive divider
Ntransient=0;         
Ntot=N+Ntransient;
nper=91;                        % prime integer number of sine waveforms
Fs=1;
bw=Fs/2;

errandom=0.05;
R=ones(1,2^Nbit)+errandom*random('normal',0,1,1,2^Nbit);
Fin=nper*Fs/N;                  % Input signal frequency (Fin = nper*Fs/N)
Vref=0.5;                       % Full scale for an input sinewave
Amp_dB=-0;                      % Amplitude in dB
Ampl=10^(Amp_dB/20)*Vref;       % Input signal amplitude

finrad=Fin*2*pi;

for i=1:Ntot,
    x=Vref*sin(finrad*(i-1))+Vref;       % Unipolar range
    k=round(x*2^Nbit);
    vout=2*Vref*sum(R(1:k))/sum(R);
    y(i)=vout;
    xx(i)=k;
end
y=y-mean(y);                        % Output with zero average
%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Figure 3.13 page 95                                   %
%     figure(2) --> Figure 3.14 page 96                                   %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
clf;
plot(R)
grid
title('Value of unity resistors')
xlabel('bin')
ylabel('Normalized value')
axis([0 2^Nbit 0.5 1.5]);

w=hann(N);
f=Fin/Fs;                            % Normalized signal frequency
fB=N*(bw/Fs);                        % Base-band frequency bins
[snr,ptot]=calcSNR(y(1:N),f,fB,w',N);
ptot=ptot-max(ptot);                 % Normalize total spectrum

figure(2);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/4 -100 0]);
text(0.05,-20, sprintf('\\bfSNR = %3.1fdB with random error = %3.3f\n'...
    ,snr,errandom),'Fontsize',12);

snr

j=1;
a=(ptot>-80);
b=ones(1,round(sum(a)/2));
for i=1:1:length(a)/2
    if a(i)==1
        b(j)=i;
        j=j+1;
    end
end

for i=5:3:length(b)
text(Fs/N*b(i),ptot(b(i))+3, sprintf('\\bf%2.1fdB',ptot(b(i))),...
    'Fontsize',8,'HorizontalAlignment','center');
end
