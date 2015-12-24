% xVar is interpreted as the number of bits

function [Out, sizeOut] = quantize_nnS(In, xVar)
    Out = In;

    Max = max(In(:));
    Min = min(In(:));
    Range = double(2^xVar - 1);
    
    % Make the output between [0, Range]    
    Out = (Out - Min) .* (Range/(Max - Min));
    
    % Round to integers
    Out = round(Out);    
    sizeOut = xVar*numel(Out)/8;  % size is in bytes
    
    % Transform back
    Out = Out .* ((Max - Min)/Range) + Min;    
    
    Out = single(Out);
end