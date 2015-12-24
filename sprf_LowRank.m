function [Out, sizeOut] = sprf_LowRank(In, xVar, field)
    Out = In;
    temp = whos('Out');
    sizeOut = temp.bytes;
    % if(length(size(In)) == 2) && ~strcmp(field, 'ip2')
    if (strcmp(field, 'ip1'))
        cd code_ncrpca/
        [Out, ~, sizeOut] = ncrpca_mod(double(In), double(xVar), 1e-3, 51, 1e-3, 50, 1e-1);
        cd ..
    end
end