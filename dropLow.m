function [Out, sizeOut] = dropLow(In, p)
    
    if (p == 0)
        Out = In;
    else
        A = abs(In(:));
        A = A(A>0);
        A = sort(A);
        thresh = A(round(length(A)*p));
        Out = In .* (abs(In)>thresh);
    end
    
    temp = whos('Out');
    size1 = temp.bytes;
    
    tempOut = sparse(double(Out(:)));
    temp = whos('tempOut');
    size2 = temp.bytes - nnz(tempOut)*4;
    sizeOut = min(size1, size2);
    
end