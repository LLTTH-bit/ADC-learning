function out=ILAr(index1,index2,index3,index4,index5,index6,index7,...
                  index8,index9,index10,index11,index12,index13,index14,...
                  index15,index16,value,Nelements);

index=[index1,index2,index3,index4,index5,index6,index7,index8,index9,...
       index10,index11,index12,index13,index14,index15,index16];
   
x=zeros(1,Nelements);
a=index(value)+value;
b=a-Nelements;
if b>0
    x(1:b)=1;
    x(b+1:index(value))=0;
    x(index(value)+1:Nelements)=1;
else
    x(1:index(value))=0;
    x(index(value)+1:a)=1;
    x(a+1:Nelements)=0;
end

xxx=index(value);
index(value)=index(value)+1;

if index(value)>Nelements;
    index(value)=1;
end

ss=zeros(1,16);
ss(1:Nelements)=index(1:Nelements);

 out=[ss x];
