import numpy as np
# import itertools
import copy

def dropLow(In,p):
    if (p == 0):
        thresh = 0
    else:
        A = np.asarray(In).flatten()
        A = np.absolute(A)
        A = [x for x in A if x > 0]
        # can be improved by avoiding sorting
        A.sort()
        thresh = A[int(np.rint(len(A)*p))-1]
    Out = np.where(np.absolute(In) >= thresh, In, 0) 
    return Out


def dropOutputwise(In,p):
    Out = copy.deepcopy(In)
    if (p == 0):
        return Out
    else:
        n = Out.shape[0]
        for i in range(n):
            Out[i,:] = dropLow(Out[i,:],p)
    return Out

# shape = A.shape
# dim = len(shape)
# rangeList = [range(shape[i]) for i in range(1,dim)]
# for i in itertools.product(*rangeList)):
#     A[]

