%% System
A = [0 1 0; 0 0 1; -1 -3 -3];   %Matrica dinamike stanja
B = [0; 0; 1];                  %Matrica ulaza
C = [1, 0, 0];                    %Matrica izlaza
D = 0;                          %Matrica direktnog prenosa

sys = ss(A, B, C, D);
%initial(sys, [1; 1; 1])         %Sopstveni odziv
%pause;
T = 1e-3;

%% Estimator
L = acker(transpose(A), transpose(C), [-2, -2, -2]);



