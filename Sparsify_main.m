function Sparsify_main(WeightMat, ExptMat, OutMat)
    
    load(WeightMat);
    load(ExptMat);
    [SparseWeights, ModelSizes] = Sparsify(Weights, Expt);
    save(OutMat, 'SparseWeights', 'Expt', 'ModelSizes');
    
end