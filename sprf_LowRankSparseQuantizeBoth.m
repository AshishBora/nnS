function [Out, sizeOut] = sprf_LowRankSparseQuantizeBoth(In, xVar, field)
    Out = In;
    temp = whos('Out');
    sizeOut = temp.bytes;
    % if(length(size(In)) == 2) && ~strcmp(field, 'ip2')
    if (strcmp(field, 'ip1'))
        cd code_ncrpca/
        [L, S, sizeL, sizeS] = ncrpca_mod(double(In), double(xVar), 1e-3, 51, 1e-3, 50, 1e-1);
        cd ..
        L = quantize_nnS(double(L), 4);
        S = quantize_nnS(double(S), 4);
        Out = L + S;
        sizeOut = sizeL/8 + sizeS/8; % 4 bits are 8 times smaller than single precision = 32 bits
    end
end