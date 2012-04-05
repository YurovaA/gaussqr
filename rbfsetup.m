% rbfsetup.m
% This file puts the appropriate directories in your path
% This is called a function because I don't want the user to
%   see these internal variables after this is called
function rbfsetup
P = path;
thisDir = pwd;

if(length(strfind(thisDir,'\'))>0) % We are in Windows
    sourceDir = strcat(thisDir,'\source');
    exampleDir = strcat(thisDir,'\examples');
    otherDir = strcat(thisDir,'\fromothers');
    sineqrDir = strcat(thisDir,'\sineqr');
elseif(length(strfind(thisDir,'/'))>0) % We are in Unix
    sourceDir = strcat(thisDir,'/source');
    exampleDir = strcat(thisDir,'/examples');
    otherDir = strcat(thisDir,'/fromothers');
    sineqrDir = strcat(thisDir,'/sineqr');
end
addpath(sourceDir,exampleDir,otherDir,sineqrDir,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup global constants and parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global GAUSSQR_PARAMETERS

% At what point should the asymptotic approximation to Hermite be used
% Anything between 35-60 you shouldn't be able to tell the difference
% Beyond 70 it's pretty necessary
GAUSSQR_PARAMETERS.HERMITE_ASYMPTOTIC_MIN_INDEX = 40;

% Sets up the polynomial coefficients for later use
GAUSSQR_PARAMETERS.HERMITE_COEFFICIENTS = cell(GAUSSQR_PARAMETERS.HERMITE_ASYMPTOTIC_MIN_INDEX,1);
for k=1:GAUSSQR_PARAMETERS.HERMITE_ASYMPTOTIC_MIN_INDEX
    GAUSSQR_PARAMETERS.HERMITE_COEFFICIENTS{k} = HermitePoly(k-1);
end

% Parameters which determine how the difference between two
% vectors is computed.
% errstyle : 1 - relative RMS error <default>
%            2 - absolute error
%            3 - relative error
% normtype : 1 - sum absolute values
%            2 - sqrt of sum of squares <default>
%            inf - largest absolute value
GAUSSQR_PARAMETERS.ERROR_STYLE = 1;
GAUSSQR_PARAMETERS.NORM_TYPE = 2;

% Use logarithms when computing rbfphi
% Shouldn't be an issue unless you have M>200 or x>20
% In general, you should use logs
% Set to 0 to turn off, 1 to turn on
GAUSSQR_PARAMETERS.RBFPHI_WITH_LOGS = 1;

% Tolerance for using asymptotic approximation of exponential within rbfphi
% The term sqrt(1+(2ep/a)^2)-1 pops up, and you can get cancelation
% This will cause the switch to sqrt(1+(2ep/a)^2)-1 = 2(ep/a)^2-2(ep/a)^4
% The switch occurs when (1+(2ep/a)^2)^(1/4)-1<tol
GAUSSQR_PARAMETERS.RBFPHI_EXP_TOL = 1e-4;

% Maximum additional eigenfunctions to add to try to reach optimal accuracy
% Adding more should allow you to spread out the ill-conditioning to more
% functions, but those functions can themselves become ill-conditioned so
% there may be a trade off.
% Choosing 0 means there is no upper bound.
% If you choose a negative number, that is treated as a percentage of the
% number of input points, ie. -50 would mean max M=1.5N
GAUSSQR_PARAMETERS.MAX_EXTRA_EFUNC = 1999;

% This chooses a default global scale parameter
% You should really set this as you go and not use the default
% This is only here to get you going and will probably be removed
GAUSSQR_PARAMETERS.ALPHA_DEFAULT = sqrt(2);

% Pick a transition point for the ranksolve algorithm to switch between
% directly forming the linear system or solving with the Sherman-Morrison
% formula.
% This value r must be between 0 and 1.
% For M < r*N, Sherman-Morrison will be used
% For M >= r*N, the low-rank portion will be explicitly computed
GAUSSQR_PARAMETERS.RANKSOLVE_PROPORTION = .75;

% Alert the user if there is an issue during computation
% Otherwise this info is stored in the rbfqrOBJ
GAUSSQR_PARAMETERS.WARNINGS_ON = false;

% Default number of functions to use for regression
% Adding more functions will help the quality of the regression but will
% cost more than a lower r.
% If you choose r>1, this value is the default number of functions to use,
% which will work up to N
% For 0<r<=1, this value M is a proportion of N
GAUSSQR_PARAMETERS.DEFAULT_REGRESSION_FUNC = .5;

% This is the default value for the number of eigenfunctions
% to require orthonormality for when searching for an alpha value.
% This value must be a positive integer
% rbfalphasearch will try to choose the smallest alpha such that all 
GAUSSQR_PARAMETERS.ORTH_INDEX_REQUESTED = 1;

% This is the tolerance to which orthonormality is accepted
% We consider functions orthonormal if
%   abs(1-Integral_n)<tol
% In higher dimensions you will have to give more leeway because the
% integrals are generally all smaller than 1 and their product may be
% significantly less than one.
GAUSSQR_PARAMETERS.DEFAULT_ORTH_TOLERANCE = 3e-2;

% These are the bounds of the alpha search algorithm
% If the acceptable alpha region is outside this, you likely won't find it
% As a general guide, for higher dimensions, you'll need a smaller alpha
% on the same domain
% The minimum value is the starting point for the alpha search, so if you
% have a better value, use it.
GAUSSQR_PARAMETERS.ORTH_MINIMUM_ALPHA = 1e-3;
GAUSSQR_PARAMETERS.ORTH_MAXIMUM_ALPHA = 1e3;

% This determines how accurate the alpha parameter needs to be solved for
% In general this doesn't need to be too accurate because there should be a
% range of acceptable parameters
% This value is passed directly to fminbnd as options.TolX
GAUSSQR_PARAMETERS.ORTH_SEARCH_ACCURACY = 1e-1;

% The accuracy required of quadl in the orthonormality test while computing
% the integration.  The default value for quadl is 1e-6, but you might be
% able to speed up the search by choosing a higher tolerance.  For right
% now this is only used to get a starting point for the optimization
% routine which uses the full 1e-6 tolerance.
GAUSSQR_PARAMETERS.ORTH_INTEGRATION_TOL = 1e-4;

% We use a linear eigenvalue computation to determine the roots of the
% eigenfunctions.  At some point, it is cheaper to only find the largest
% eigenvalue than all the eigenvalues (if that's all you need) using sparse
% eigensolver methods.  This value allows you to determine where you'd like
% to switch between eig(J) and eigs(Jsparse).
% 
% If you are computing all the roots, it will always use eig(J) because it
% is much faster, at least on my laptop.  If you are going to be using a
% large number of points often, maybe consider computing them all once and
% then storing them.  Or maybe I could do that and store up to M=1000 roots
% or so in a binary file in the repo.
GAUSSQR_PARAMETERS.ORTH_ROOT_SPARSE_LIMIT = 500;

end
