function [Out, sizeOut] = dropOutputwise(In,p)
    
    Out = In;
    if (p ~= 0)
        n = size(In,1);
        for i = 1 : n
            Out(i,:) = dropLow(In(i,:),p);
        end
    end
    
    temp = whos('Out');
    size1 = temp.bytes;
    
    tempOut = sparse(double(Out(:)));
    temp = whos('tempOut');
    size2 = temp.bytes - nnz(tempOut)*4;
    sizeOut = min(size1, size2);
    
end