function [SparseWeights, ModelSize] = Sparsify_refac(Weights, Expt)
    
    numTrials = length(Expt.Trials);
    SparseWeights = cell(1, numTrials);
    ModelSize = zeros(1, numTrials);
    fnames = fieldnames(Weights);
    
    for i = 1 : numTrials
        
        SparseWeights{i} = struct();
        xVar = Expt.Trials{i}.('xVar');
        for j = 1 : length(fnames)
            field = fnames{j};
            In = Weights.(field);
            
            if(strcmp(Expt.mode,'dropLow'))
                [Out, sizeOut] = dropLow(In, xVar);                
            elseif(strcmp(Expt.mode,'dropOutputwise'))
                [Out, sizeOut] = dropOutputwise(In, xVar);
            elseif(strcmp(Expt.mode,'quantize'))
                [Out, sizeOut]  = quantize_nnS(double(In), xVar);
            elseif (strcmp(Expt.mode,'LowRank_incoh'))
                [Out, sizeOut] = sprf_LowRank_incoh(In, xVar, field);
            elseif (strcmp(Expt.mode,'LowRankSparse'))
                [Out, sizeOut] = sprf_LowRankSparse(In, xVar, field);
            elseif (strcmp(Expt.mode,'LowRank'))
                [Out, sizeOut] = sprf_LowRank(In, xVar, field);
            elseif (strcmp(Expt.mode,'LowRankSparseQuantizeBoth'))
                [Out, sizeOut] = sprf_LowRankSparseQuantizeBoth(In, xVar, field);
            end
            
            SparseWeights{i}.(field) = Out;
            ModelSize(i) = ModelSize(i) + sizeOut;
        end
    end
    
end

% Out = single(ncrpca(double(In), 100, 1e-3, 51, 1e-3, 50, 1e-1));
