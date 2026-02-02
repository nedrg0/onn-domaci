%% System
A = [0 1 0; 0 0 1; -1 -3 -3];   %Matrica dinamike stanja
B = [0; 0; 1];                  %Matrica ulaza
C = [1, 0, 0];                    %Matrica izlaza
D = 0;                          %Matrica direktnog prenosa

sys = ss(A, B, C, D);
%initial(sys, [1; 1; 1])         %Sopstveni odziv
%pause;
T = 1e-3;
%% Regulator

Ts = 5;
Ksi = 0.7;
w0 = 5/ ( Ts * Ksi);

p = [-10, -Ksi * w0 + 1i * w0 * sqrt(1 - Ksi^2), -Ksi * w0 - 1i * w0 * sqrt(1 - Ksi^2)];               %Zeljeni polovi
%p = [-2, -2, -2];
fd = poly(p);

K = acker(A, B, p);     % ili samo p
%K = [100, 100, 0]
%initial(sys, [1; 1; 1])


%% Zatvorena povratna sprega [1. DEO]
s = tf('s');
Gcl =  C * inv(s*eye(size(A)) - (A - B*K)) * B + D;
Gcl_2ord = tf([0 dcgain(Gcl)], poly([-Ksi * w0 + 1i * w0 * sqrt(1 - Ksi^2), -Ksi * w0 - 1i * w0 * sqrt(1 - Ksi^2)]));

%Provera polova
p_cl = pole(Gcl);

[~ , i] = min(abs(real(p_cl)));
dom_poles = p_cl(i, 1);

tau = 1/abs(real(dom_poles));
Ts_cl = 5 * tau;
Ksi_cl = abs(real(dom_poles)) / abs(dom_poles);
%% Saturacija [3. Deo]
umax = 1;
umin = -1;

