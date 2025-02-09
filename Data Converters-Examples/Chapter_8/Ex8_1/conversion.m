function out=conversion(in)
bit=dec2bin(abs(in),7);

for i=1:1:7
    temp(i)=str2num(bit(i));
end

out=temp;
