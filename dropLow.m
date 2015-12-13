function Wout = dropLow(W,p)
    A = abs(W(:));
    A = A(A>0);
    % can be improved by avoiding sorting
    A = sort(A);
    thresh = A(round(length(A)*p));
    Wout = W.*(abs(W)>thresh);
end
    