function Compress(p)
    W = csvread('Wval.csv');
    W_app = dropLow(W,p);
    csvwrite('Wval_approx.csv',W_app);
end