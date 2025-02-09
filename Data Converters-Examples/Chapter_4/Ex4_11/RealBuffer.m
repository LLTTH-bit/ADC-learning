function out = RealBuffer(u,sr,tau,gain,Tmax)


% Models the buffer or residue generator finite bandwidth and slew rate
% used in a pipeline converter
%
% out = RealBuffer(sr,tau,gain)
%
% u:       input signal
% sr:		Slew rate in V/s
% tau:		exponential time constant in sec
% gain:		gain of the buffer
% Tmax:     period of operation
%
% out:		Output signal amplitude
in=u;
slope=abs(in)/tau;

if slope > sr			% Op-amp in slewing
	
	tslew = abs(in)/sr - tau;  % Slewing time
	
	if tslew >= Tmax
		error = abs(in) - sr*Tmax;
	else
		texp = Tmax - tslew;
		error = abs(in)*sr*tau * exp(-texp/tau);
	end
	
else					% Op-amp in linear region
	texp = Tmax;
	error = sr*tau * exp(-texp/tau);
end

out = in - sign(in)*error;
