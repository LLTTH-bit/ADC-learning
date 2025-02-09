function output = my_bin2dec(input)

[row,col] = size(input);

output = zeros(1,row);

for i = 1:row
    for j = 1:col
        if j==1 && str2double(input(i,1)) == 1
            output(1,i) = output(1,i) - 2^(col-1);
        else
            output(1,i) = output(1,i) + str2double(input(i,j))*2^(col-j);
        end
    end
end

end