function plot_spectrum(points,freq, out)
% Spectrum
w=hann(points);
f=freq;			            % Normalized signal frequency
fB=points/2;     		    % Base-band frequency bins
N=points;
yy1=zeros(1,N);
yy1=out-mean(out);
Vref=1;
ptot=zeros(1,N);
[snr,ptot]=calcSNR(yy1(1:N),f,fB,w',N);
Rbit=(snr-1.76)/6.02;	% Equivalent resolution in bits
figure (2)
ptot=ptot-max(ptot);
plot(ptot(1:N/2), 'r');
grid on
text(N/4, -10, sprintf('\\bfSNDR = %3.1fdB     N-bit=%3.2f\n',snr,Rbit),...
    'Fontsize',12, 'HorizontalAlignment', 'center');
 axis([0 points/2 -120 0]);