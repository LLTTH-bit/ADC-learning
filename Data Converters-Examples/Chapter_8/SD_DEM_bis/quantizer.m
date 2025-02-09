function out=quantizer(in,vth,vthid,flag_dac)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      in       => analog input                                         %%
%%      vth      => real thresholds of the Quantizer                     %%
%%      vthid    => ideal thresholds of the Quantizer                    %%
%%      VfsH     => Higher Reference Voltage                             %%
%%      flag_dac => thresholds selector of the dac                       %%
%%               => % if 0  dac_output beginning of the interval         %%
%%                  % if 0.5 dac_output half of the interval             %%
%%                  % if 1   dac_output end of the interval              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              


term=(in>vth);                     % thermometric vector
int=sum(term);
if flag_dac==0
    out=vthid(int+1);
elseif flag_dac==1
    out=vthid(int+2);
else 
    out=(vthid(int+1)+vthid(int+2))*0.5;
end
    

