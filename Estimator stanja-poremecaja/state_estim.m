%% System
A = [0 1 0; 0 0 1; -1 -3 -3];   %Matrica dinamike stanja
B = [0; 0; 1];                  %Matrica ulaza
C = [1, 0, 0];                    %Matrica izlaza
D = 0;                          %Matrica direktnog prenosa

sys = ss(A, B, C, D);
%pause;

T = 1e-3;
ic = 0;

%Modify model to include the disturbance model 
%d = const.
Aw = [0, 1; 0, 0];
Cw = [1, 0];
Ae = [A, B*Cw; zeros([length(Aw), length(A)]), Aw];
Ce = [C zeros(size(Cw))];
%% Estimator
L = acker(transpose(Ae), transpose(Ce), -2 * [1, 1, 1, 1, 1]);




