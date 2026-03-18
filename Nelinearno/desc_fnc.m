

k = 1;
A = 1;
B = 1;
a = linspace(1, 2, 50);

ReN = 2 / pi * (k * asin(A ./ a) - sqrt(1 - (A./a).^2) * (k.*A + 2*B) ./ a);
ImN = 0 .* a;
w = logspace(0, 2, 5000);
s = 1j * w;

G = 4 ./ (s .* (s + 1) .^2);
plot(real(G), imag(G), color='r');
hold("on");
plot(- 1 ./ ReN, ImN, color='b');