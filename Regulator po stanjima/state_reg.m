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
Ksi = 0.9;
w0 = 5/ ( Ts * Ksi);

p = [-10, -Ksi * w0 + 1i * w0 * sqrt(1 - Ksi^2), -Ksi * w0 - 1i * w0 * sqrt(1 - Ksi^2)];               %Zeljeni polovi
fd = poly(p);

K = acker(A, B, p);  



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

%% Simulacija
reg_type = 1; % 1 - cont. , 0 - disc
sat_off = 1; % 1 - off, 0 - on

Tss = [3];
Ksis = [0.9];
for Ts = Tss
    for Ksi = Ksis
        w0 = 5/ ( Ts * Ksi);
        
        p = [-10, -Ksi * w0 + 1i * w0 * sqrt(1 - Ksi^2), -Ksi * w0 - 1i * w0 * sqrt(1 - Ksi^2)];   
        fd = poly(p);
        K = acker(A, B, p);
        [y, u, d, r, t] = simulate_step_input(0, 1, 1);

        plot(t, y(:, 1), "LineWidth", 2, "DisplayName", "Odziv Ts = " + num2str(Ts) + ", \xi = " + num2str(Ksi));
        %legend("Odziv Ts = " + num2str(Ts) + ", \xi = " + num2str(Ksi));

        hold on;
    end
end
%plot(t, r, "LineStyle", "--", "LineWidth", 1.5, "DisplayName", "Referentna vrednost");
yline(1/(1 + K(1, 1)), "LineStyle", "--", "LineWidth", 1.5, "DisplayName", "1/(1 + k_1)")
xlabel("Vreme [s]");
ylabel("Amplituda [-]");
grid on; legend show; % Vidimo da za vece Ts -> k1 manje, pa je ess vece.

function [y, u, d, r, t] = simulate_step_input(R0, D0, noise)
   
    mdl = "state_reg_mdl";
    %open_system(mdl);
    set_param(mdl + "/Step", "After", num2str(R0));
    set_param(mdl + "/Step1", "After", num2str(D0));
    set_param(mdl + "/n", "Gain", num2str(noise))
    out = sim(mdl);

    y = transpose(squeeze(out.y(1,:, :)));
    u = transpose(squeeze(out.u));
    d = out.d;
    r = out.r;
    t = out.tout(:, 1);
    
end