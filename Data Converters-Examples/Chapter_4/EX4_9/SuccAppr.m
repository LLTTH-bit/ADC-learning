 function n_out=SuccAppr(input,nbit, yDAC)
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %                                                                        %  
 %  function n_out=SuccAppr(input,nbit, yDAC)                             %
 %  input    input signal                                                 %
 %  nbit     number of bit                                                %
 %  yDAC     Vector of (at least) 2^nbit-1 elements                       %
 %           representing the DAC response                                %
 %                                                                        %  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_out=0;                                    
for i=1:nbit
    nguess=n_out+2^(nbit-i);
    bit=(sign(input-yDAC(nguess))+1)/2;
    if bit==0.5
        bit=1;
    end
n_out=n_out+bit*2^(nbit-i);
end