%
% Simulation model for a PI controller.
% ACS6124 Part 2 2023/24
% RP, 6 February 2024
%
% Z = evaluateControlSystem(X);
%
% Input:  X - a sampling plan
%             (one design per row, one design variable per column)
% Output: Z - performance evaluations
%             (one design per row, one criterion per column;
%              criteria are...
%              1:  maximum closed-loop pole magnitude
%              2:  gain margin
%              3:  phase margin
%              4:  10-90% rise time
%              5.  peak time
%              6.  overshoot (% points)
%              7.  undershoot (% points)
%              8.  2% settling time
%              9.  steady-state error (% points))
%              10. aggregate control input (MJ)
%
function Z = evaluateControlSystem(X);

[noInds, noVar] = size(X);

Z = NaN * ones(noInds,10);

warning('off')

% Define the plant
ts = 1;
GS = c2d(tf(1,[1 1],'InputDelay',2),ts,'zoh');

for ind = 1:noInds
 
  % Extract the candidate controller gains.
  kp=X(ind,1);
  ki=X(ind,2);
  
  % Define the controller
  GC = tf([(kp+ki) -kp],[1 -1],ts);
  
  % Construct the open-loop transfer function
  olTF = GC*GS;
  
  % Construct the closed-loop transfer function
  clTF = feedback(olTF,1);
  
  % Construct the transfer function between control input and
  % system output
  uTF= GC / (1 + olTF);
 
  % Get stability measure.
  sPoles = roots(clTF.Denominator{1});
  clStable = max(abs(sPoles));
  
  [gainMargin, phaseMargin, wcGP, wcPM] = margin(olTF);
  
  % Do a unit step response.
  timeData = [0:1:100];
  outputData = step(clTF, timeData);
  
  % Collect results where possible (stable).
  if clStable < 1
    riseTime = getRiseTime(timeData, outputData, outputData(end));
    settleTime = getSettlingTime(timeData, outputData, 0.02, ...
						outputData(end));
  else
    riseTime = getRiseTime(timeData, outputData, 1.0);
    settleTime = getSettlingTime(timeData, outputData, 0.02, 1.0);
  end
  [overshoot, overTime, undershoot, underTime] = getShoots(timeData, outputData);
  ssError = getSSError(outputData);
  
  controlEffort = sum(step(uTF, timeData).^2) / 150;
  
  % Assign to output variable.
  Z(ind,1) = clStable;
  Z(ind,2) = min(gainMargin, 1000);   %-1* for minimisation
  Z(ind,3) = min(phaseMargin, 180);  % for minimisation (goal set at 70)
  % Z(ind,4) = (-1)*min(phaseMargin, 1000);  %-1* for maximisation (goal set at -30)
  Z(ind,4) = min(riseTime, 1000);
  Z(ind,5) = min(overTime, 1000);
  Z(ind,6) = min(100*overshoot, 1000);
  Z(ind,7) = min(100*undershoot, 1000);
  Z(ind,8) = min(settleTime, 1000);
  Z(ind,9) = min(100*ssError, 1000);
  Z(ind,10) = controlEffort;
  
end

warning('on')

