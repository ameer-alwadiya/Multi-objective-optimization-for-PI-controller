%
% getSSError.m
%
% Returns the absolute steady-state error.
% NB: Just compares mean of last 10 values provided wrt unity.
%
% ssError = getSSError(oData) 
%
% Inputs: oData    - response values
% Output: ssError  - steady-state error (as a percentage of unit step)
%
function ssError = getSSError(oData);

ssErrorAbs = abs(oData-1);
ssError = mean(ssErrorAbs(end-10:end));