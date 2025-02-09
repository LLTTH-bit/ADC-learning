function out=DEM(in,vthid,flag_dac,mism,index1,index2,index3,index4,index5,index6,index7,index8,index9,index10,index11,index12,index13,index14,index15,index16,Nelements,LSB,VfsL,DEM_sel,flag_quant)

term=(in>=vthid);
termo=sum(term);
if flag_dac==1
    termo=termo-1;
end
if DEM_sel==0                                   % no Algorithms
    xx(1:termo)=ones(1,termo);
    xx(termo+1:Nelements)=zeros(1,Nelements-termo);
    yy=(xx.*(1+mism));
    an_out=VfsL+(sum(yy)*LSB)-LSB*(1-flag_dac)-flag_quant*LSB/2;
    out=[zeros(1,16) an_out];
elseif DEM_sel==1                               % DWA Algorithm
conv=DWA1(index1,termo,Nelements);
new_index=conv(1);
xx=conv(2:Nelements+1);
yy=(xx.*(1+mism));
an_out=VfsL+(sum(yy)*LSB)-LSB*(1-flag_dac)-flag_quant*LSB/2;
out=[new_index zeros(1,15) an_out];
elseif  DEM_sel==2
     conv=ILAr(index1,index2,index3,index4,index5,index6,index7,index8,...
               index9,index10,index11,index12,index13,index14,index15,...
               index16,termo,Nelements);  % ILA Rotation Appr
     new_index1=conv(1);
     new_index2=conv(2);
     new_index3=conv(3);
     new_index4=conv(4);
     new_index5=conv(5);
     new_index6=conv(6);
     new_index7=conv(7);
     new_index8=conv(8);
     new_index9=conv(9);
     new_index10=conv(10);
     new_index11=conv(11);
     new_index12=conv(12);
     new_index13=conv(13);
     new_index14=conv(14);
     new_index15=conv(15);
     new_index16=conv(16);
     xx=conv(17:Nelements+16);
     yy=(xx.*(1+mism));
     an_out=VfsL+(sum(yy)*LSB)-LSB*(1-flag_dac)-flag_quant*LSB/2;
     out=[new_index1 new_index2 new_index3 new_index4 new_index5 ...
          new_index6 new_index7 new_index8 new_index9 new_index10 ...
          new_index11 new_index12 new_index13 new_index14 new_index15 ...
          new_index16 an_out];
      
elseif  DEM_sel==3                              % ILA Addition Appr
     conv=ILAad(index1,index2,index3,index4,index5,index6,index7,index8,...
                index9,index10,index11,index12,index13,index14,index15,...
                index16,termo,Nelements);
     new_index1=conv(1);
     new_index2=conv(2);
     new_index3=conv(3);
     new_index4=conv(4);
     new_index5=conv(5);
     new_index6=conv(6);
     new_index7=conv(7);
     new_index8=conv(8);
     new_index9=conv(9);
     new_index10=conv(10);
     new_index11=conv(11);
     new_index12=conv(12);
     new_index13=conv(13);
     new_index14=conv(14);
     new_index15=conv(15);
     new_index16=conv(16);
     xx=conv(17:Nelements+16);
     yy=(xx.*(1+mism));
     an_out=VfsL+(sum(yy)*LSB)-LSB*(1-flag_dac)-flag_quant*LSB/2;
     out=[new_index1 new_index2 new_index3 new_index4 new_index5 ...
          new_index6 new_index7 new_index8 new_index9 new_index10 ...
          new_index11 new_index12 new_index13 new_index14 new_index15 ...
          new_index16 an_out];
     
elseif  DEM_sel==4                              %Butterfly
     conv=butterfly(termo,Nelements);
     xx=conv(1:Nelements);
     yy=(xx.*(1+mism));
     an_out=VfsL+(sum(yy)*LSB)-LSB*(1-flag_dac)-flag_quant*LSB/2;
     out=[zeros(1,16) an_out];     
     
end
    