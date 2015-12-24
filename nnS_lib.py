import numpy as np
import caffe
import scipy.io
import pickle

# Some helper functions

def dumpExpt(Expt):
    ExptMat = Expt['ExptMat']
    Expt_top = {}
    Expt_top['Expt'] = Expt
    scipy.io.savemat(ExptMat, Expt_top)
    
def populate(Expt, prefix):
    Expt['ExptMat'] = prefix + '_' + Expt['name'] + '.mat'
    Expt['OutMat']  = prefix + '_' + Expt['name'] + '_SparseWeights.mat'
    Expt['ResMat']  = prefix + '_' + Expt['name'] + '_results.pkl'

def getW(matW):
    W = {}
    for lyr in matW._fieldnames:
        W[lyr] = getattr(matW, lyr)
    return W

def getWeightsAndSizes(Expt):
    OutMat = Expt['OutMat']
    Sprf = scipy.io.loadmat(OutMat, struct_as_record=False)
    sprfW_arr = list(Sprf['SparseWeights'][0])
    size_arr = Sprf['ModelSizes'][0]
    for trialNum in range(len(Expt['Trials'])):
        matW = sprfW_arr[trialNum][0][0]
        W = getW(matW)
        Expt['Trials'][trialNum]['SparseWeights'] = W
        Expt['Trials'][trialNum]['size'] = size_arr[trialNum]
        
def addTrials(Expt):
    Trials = []
    for xVar in Expt['xVars']:
        trial = {}
        trial['xVar'] = xVar
        Trials.append(trial)
    Expt['Trials'] = Trials
    
def dumpResults(Expt):
    filename = Expt['ResMat']
    output = open(filename, 'wb')
    pickle.dump(Expt, output)
    output.close()
    
def prepareExperiments(Expts, prefix):
    # Add necessary things, and save experiment parameters
    for Expt in Expts:
        addTrials(Expt)
        populate(Expt, prefix)
        dumpExpt(Expt)
    return Expts

def runExperiments(Expts, net, WeightMat):
    
    # Start matlab
    import matlab.engine
    # import StringIO
    # out = StringIO.StringIO()
    eng = matlab.engine.start_matlab()
    eng.eval("cd ../caffe",nargout=0)

    # Sparsify for each experiment and save in OutMat file
    for Expt in Expts:
        print(Expt['name'])
        ExptMat = Expt['ExptMat']
        OutMat = Expt['OutMat']    
        eng.Sparsify_main(WeightMat, ExptMat, OutMat, nargout = 0)

    # Quit matlab
    eng.quit()
    
    # Load the sparsified weights
    for Expt in Expts:
        getWeightsAndSizes(Expt)
        
    # Compute accuracy for each trial in each experiment
    for Expt in Expts: 
        print('\n' + Expt['name'])
        for trial in Expt['Trials']:        
            print trial['xVar'],
            for lyr in net.params:
                net.params[lyr][0].data[...] = trial['SparseWeights'][lyr]

            acc_arr = []
            for i in range(100):
                acc = net.forward()['accuracy']
                acc_arr.append(float(acc))

            trial['acc_arr'] = acc_arr
            trial['accuracy'] = np.mean(np.asarray(acc_arr))
            print trial['accuracy']
        Expt['accuracies'] = [trial['accuracy'] for trial in Expt['Trials']]
    
    # Save results to a pickle file
    for Expt in Expts:
        dumpResults(Expt)

    return Expts

# def showResults(Expts, ModelSizeOrig):
#     # Multiple plots, accuracy vs vs xVar
#     # plt.figure()
#     # plt.hold(True)
#     # Plot_handles = []
#     # for Expt in Expts[0:2]:
#     #     Plot_handles.append(plt.plot(Expt['xVars'], Expt['accuracy'], label = Expt['name'])[0])
#     # legends = [Expt['mode'] for Expt in Expts]
#     # plt.legend(Plot_handles, legends, loc = 'lower left')
    
#     # Single plot accuracy vs xVar
#     # fig = plt.figure()
#     # fig = plt.plot(Expt['xVars'], Expt['accuracy'], label = Expt['name'])[0]
#     # ax = fig.axes.set_xlabel(Expts[0]['xVar_interp'])
#     # ax = fig.axes.set_ylabel('accuracy')
    
#     # Single plot accuracy vs size

#     # mpld3.enable_notebook()
#     # mpld3.disable_notebook()

#     for Expt in Expts:
#         CompRatio = [(ModelSizeOrig*1.0)/trial['size'] for trial in Expt['Trials']]
#         fig = plt.figure()
#         fig = plt.scatter(CompRatio, Expt['accuracies'], label = Expt['name'])
#         ax = fig.axes.set_xlabel('Compression Ratio')
#         ax = fig.axes.set_ylabel('accuracy')

