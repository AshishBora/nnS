function [Out, sizeOut] = sprf_LowRank_incoh(In, xVar, field)
    
    Out = In;
    temp = whos('Out');
    sizeOut = temp.bytes;
    % if(length(size(In)) == 2) && ~strcmp(field, 'ip2')
    if (strcmp(field, 'ip1'))
        cd code_ncrpca/
        % [m,n] = size(In);
        %  xVar_mod = min([m,n, xVar]);
        [Out, ~, sizeOut] = ncrpca_mod(double(In), 100, 1e-3, 51, 1e-3, double(xVar), 1e-1);
        cd ..
    end
    
end