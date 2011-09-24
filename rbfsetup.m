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
elseif(length(strfind(thisDir,'/'))>0) % We are in Unix
    sourceDir = strcat(thisDir,'/source');
    exampleDir = strcat(thisDir,'/examples');
end
path(P,sourceDir);
P = path;
path(P,exampleDir);

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
GAUSSQR_PARAMETERS.MAX_EXTRA_EFUNC = 1000;

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
GAUSSQR_PARAMETERS.DEFAULT_REGRESSION_FUNC = .4;

% This is the default value for the number of eigenfunctions
% to require orthogonality for when searching for an alpha value.
% This value must be a positive integer
% rbfalphasearch will try to choose the smallest alpha such that all 
GAUSSQR_PARAMETERS.DEFAULT_ORTH_REQUESTED = 20;

% This is the tolerance to which orthonormality is accepted
% We consider functions orthonormal if
%   abs(1-Integral_n)<tol
GAUSSQR_PARAMETERS.DEFAULT_ORTH_TOLERANCE = 1e-2;

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
GAUSSQR_PARAMETERS.ORTH_SEARCH_ACCURACY = 1e-1;

end
