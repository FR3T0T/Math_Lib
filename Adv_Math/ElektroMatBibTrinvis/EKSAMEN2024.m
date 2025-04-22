% LØSNING AF DTU EKSAMEN - VIDEREGÅENDE MATEMATIK FOR DIPLOM ELEKTROTEKNOLOGI
% Dette script bruger ElektroMatBibTrinvis til at løse eksamensopgaver

%% Initialiser
clear all;
close all;
clc;

% Symbolske variable
syms t s omega;

fprintf('===== DTU EKSAMEN - VIDEREGÅENDE MATEMATIK FOR DIPLOM ELEKTROTEKNOLOGI =====\n\n');

%% OPGAVE 1
fprintf('========== OPGAVE 1 ==========\n');
fprintf('Et lineært tidsinvariant system er beskrevet ved differentialligningen:\n');
fprintf('y′′(t) + 4y′(t) + 9y(t) + 10∫_{0}^{t}y(τ)dτ = x(t)\n\n');

% 1a) Bestem systemets overføringsfunktion H(s)
fprintf('1a) Bestem systemets overføringsfunktion H(s)\n');
fprintf('--------------------------------------\n');

% Omskrivning af differentialligningen med Laplacetransform:
% Laplacetransform af integralleddet: ∫_{0}^{t}y(τ)dτ => Y(s)/s
% s^2 Y(s) + 4s Y(s) + 9Y(s) + 10Y(s)/s = X(s)
% Multiplicer med s for at få polynomform:
% s^3 Y(s) + 4s^2 Y(s) + 9s Y(s) + 10 Y(s) = s X(s)

% Koefficienter for output:
a = [1 4 9 10];  % koefficienter for: s^3, s^2, s, s^0
% Koefficienter for input:
b = [1 0 0 0];   % koefficienter for: s, s^0, osv.

[num, den, forklaring1a] = ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktion_med_forklaring(b, a);

% Opbyg overføringsfunktionen manuelt for at vise den
H_s = poly2sym(num, s) / poly2sym(den, s);
fprintf('Overføringsfunktionen er: H(s) = %s\n\n', char(H_s));

% 1b) Bestem systemets poler og nulpunkter
fprintf('1b) Bestem systemets poler og nulpunkter og tegn pol-nulpunktsdiagrammet\n');
fprintf('--------------------------------------\n');

% Find polerne ved at analysere differentialligningen
forklaring1b = ElektroMatBibTrinvis.analyserDifferentialligning_med_forklaring(a);

% Beregn polerne manuelt
poler = roots(den);
nulpunkter = roots(num);

fprintf('Systemets poler er:\n');
for i = 1:length(poler)
    fprintf('p%d = %.4f %+.4fi\n', i, real(poler(i)), imag(poler(i)));
end

fprintf('\nSystemets nulpunkter er:\n');
for i = 1:length(nulpunkter)
    fprintf('z%d = %.4f %+.4fi\n', i, real(nulpunkter(i)), imag(nulpunkter(i)));
end

% Stabilitetsanalyse
if all(real(poler) < 0)
    fprintf('\nAlle poler har negativ realdel, så systemet er STABILT.\n\n');
else
    fprintf('\nDer findes poler med positiv eller nul realdel, så systemet er USTABILT.\n\n');
end

% Tegn pol-nulpunktsdiagram
figure(1);
zplane(num, den);
title('Pol-nulpunktsdiagram for systemet');
grid on;

% 1c) Bestem systemets impulsrespons h(t)
fprintf('1c) Bestem systemets impulsrespons h(t)\n');
fprintf('--------------------------------------\n');

% Find impulsresponsen med invers Laplacetransformation
[h_t, forklaring1c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(H_s, s, t);
fprintf('Systemets impulsrespons er: h(t) = %s\n\n', char(h_t));

% 1d) Bestem udgangssignalet når indgangssignalet er te^(-4t)u(t)
fprintf('1d) Bestem udgangssignalet når indgangssignalet er te^(-4t)u(t)\n');
fprintf('--------------------------------------\n');

% Laplacetransform af te^(-4t)u(t)
X_s = 1/(s+4)^2;

% Beregn udgangssignalet i s-domænet
Y_s = H_s * X_s;
fprintf('Y(s) = H(s) · X(s) = %s\n\n', char(simplify(Y_s)));

% Find den inverse Laplacetransformation
[y_t, forklaring1d] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(Y_s, s, t);
fprintf('Udgangssignalet er: y(t) = %s\n\n', char(y_t));


%% OPGAVE 2
fprintf('========== OPGAVE 2 ==========\n');
fprintf('Betragt den stykkevis definerede funktion:\n');
fprintf('f(t) = 3t                 for 0 ≤ t < 1\n');
fprintf('f(t) = t^2 - 6t + 8       for 1 ≤ t < 2\n');
fprintf('f(t) = 0                  for 2 ≤ t < ∞\n\n');

% 2a) Udtryk f(t) ved Heavisides enhedstrinfunktion
fprintf('2a) Udtryk f(t) ved Heavisides enhedstrinfunktion\n');
fprintf('--------------------------------------\n');

% Vi bruger u(t) som Heavisides enhedstrinfunktion
syms u(t)
f_t_med_u = 3*t*u(t) + (t^2-6*t+8-3*t)*u(t-1) - (t^2-6*t+8)*u(t-2);

fprintf('f(t) = %s\n\n', char(f_t_med_u));

% Illustration med vores bibliotek (viser principielt hvad vi beregner)
[F1_u, forklaring2a1] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(0, t, s);
[F2_u, forklaring2a2] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(1, t, s);
[F3_u, forklaring2a3] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(2, t, s);

% 2b) Bestem den Laplacetransformerede F(s) af f(t)
fprintf('2b) Bestem den Laplacetransformerede F(s) af f(t)\n');
fprintf('--------------------------------------\n');

% Definer en kontinuert funktion der repræsenterer f(t) ved hjælp af Heaviside-funktioner
f_t = 3*t*heaviside(t) + (t^2-6*t+8-3*t)*heaviside(t-1) - (t^2-6*t+8)*heaviside(t-2);

% Beregn Laplacetransformationen
[F_s, forklaring2b] = ElektroMatBibTrinvis.laplace_med_forklaring(f_t, t, s);
fprintf('Laplacetransformationen er: F(s) = %s\n\n', char(F_s));

% 2c) Bestem den Laplacetransformerede af g(t) = t^2*f(t)
fprintf('2c) Bestem den Laplacetransformerede af g(t) = t^2·f(t)\n');
fprintf('--------------------------------------\n');

% Definer g(t) = t^2 · f(t)
g_t = t^2 * f_t;

% Beregn Laplacetransformationen direkte
[G_s, forklaring2c] = ElektroMatBibTrinvis.laplace_med_forklaring(g_t, t, s);
fprintf('Laplacetransformationen af g(t) er: G(s) = %s\n\n', char(G_s));


%% OPGAVE 3
fprintf('========== OPGAVE 3 ==========\n');
fprintf('Betragt den periodiske funktion med periode T = 4:\n');
fprintf('f(t) = 0    for -2 ≤ t < -1\n');
fprintf('f(t) = 2    for -1 ≤ t ≤ 1\n');
fprintf('f(t) = 0    for 1 < t ≤ 2\n\n');

% 3a) Skitser grafen og bestem den fundamentale radianfrekvens
fprintf('3a) Skitser grafen og bestem den fundamentale radianfrekvens\n');
fprintf('--------------------------------------\n');

% Periode og radianfrekvens
T = 4;
omega_0 = 2*pi/T;

fprintf('Den fundamentale radianfrekvens er: ω₀ = 2π/T = 2π/4 = %.4f rad/s\n\n', omega_0);

% Tegn grafen over 3 perioder
figure(2);
t_values = linspace(-7, 7, 1000);
f_values = zeros(size(t_values));

for i = 1:length(t_values)
    t_i = mod(t_values(i) + 2, 4) - 2;  % Normaliserer til [-2, 2]
    if t_i >= -1 && t_i <= 1
        f_values(i) = 2;
    else
        f_values(i) = 0;
    end
end

plot(t_values, f_values, 'LineWidth', 2);
grid on;
title('Periodisk funktion f(t) over intervallet -7 ≤ t < 7');
xlabel('t');
ylabel('f(t)');
xlim([-7, 7]);
ylim([-0.5, 2.5]);

% 3b) Opstil integralet til bestemmelse af Fourierkoefficienterne
fprintf('3b) Opstil integralet til bestemmelse af Fourierkoefficienterne\n');
fprintf('--------------------------------------\n');

% Definer funktionen på en periode med Heaviside funktioner
% Bemærk: Vi undgår piecewise da den kan give syntaksfejl
f_t_period = 2*(heaviside(t+1) - heaviside(t-1));

% Manuelt opstil integralet for Fourierkoefficienterne
syms n real
% Fourierkoefficientens integralformel: cn = (1/T)∫f(t)·e^(-j·n·ω₀·t)dt fra -T/2 til T/2
% hvor ω₀ = 2π/T
omega_0 = 2*pi/T;
cn_integral = (1/T) * int(f_t_period * exp(-1i*n*omega_0*t), t, -2, 2);
cn_integral_simplified = simplify(cn_integral);

% Numerisk beregning af Fourierkoefficienterne fordi biblioteksfunktionen
% kan have problemer med piecewise funktionen
c0 = 1;  % Dette er middelværdien (c₀ = 1)
cn_func = @(n) sinc(n*pi/2);  % sinc(x) = sin(x)/x, hvor sinc(0) = 1

fprintf('Integralet til beregning af Fourierkoefficienterne er:\n');
fprintf('cₙ = (1/T)∫f(t)·e^(-j·n·ω₀·t)dt fra -T/2 til T/2\n');
fprintf('cₙ = (1/4)∫f(t)·e^(-j·n·π/2·t)dt fra -2 til 2\n\n');

fprintf('Løsning:\n');
fprintf('c₀ = 1\n');
fprintf('cₙ = sinc(πn/2) for n ≠ 0\n\n');

fprintf('Fourierkoefficienterne er:\n');
fprintf('c₀ = %d\n', c0);
for n = 1:6
    fprintf('c₍₋%d₎ = c₍%d₎ = %.4f\n', n, n, cn_func(n));
end
fprintf('\n');

% 3c) Skitser det 1-sidede amplitudespektrum for |n| ≤ 6
fprintf('3c) Skitser det 1-sidede amplitudespektrum for |n| ≤ 6\n');
fprintf('--------------------------------------\n');

% Beregn amplitudespektrum for n = 0 til 6
n_values = 0:6;
cn_values = zeros(size(n_values));
for i = 1:length(n_values)
    if n_values(i) == 0
        cn_values(i) = c0;
    else
        cn_values(i) = cn_func(n_values(i));
    end
end

figure(3);
stem(n_values, cn_values, 'filled', 'LineWidth', 2);
grid on;
title('1-sidet amplitudespektrum for f(t)');
xlabel('n');
ylabel('|cₙ|');
xlim([-0.5, 6.5]);

fprintf('Det 1-sidede amplitudespektrum er plottet i Figur 3.\n\n');

% 3d) Beregn middeleffekten P_f i f
fprintf('3d) Beregn middeleffekten P_f i f\n');
fprintf('--------------------------------------\n');

% Middeleffekten beregnes med Parsevals teorem
% P_f = |c₀|² + 2∑|cₙ|² for n > 0

% Skab en struktur der repræsenterer cn
cn_struct = struct();
cn_struct.c0 = c0;
for n = 1:6
    cn_struct.(sprintf('c%d', n)) = cn_func(n);
    cn_struct.(sprintf('cm%d', n)) = cn_func(n);
end

[P_f, forklaring3d] = ElektroMatBibTrinvis.parsevalTeorem_med_forklaring(cn_struct, 6);

% Beregn også manuelt
P_f_manual = c0^2;
for n = 1:100  % Summerer mange led for nøjagtighed
    P_f_manual = P_f_manual + 2*(cn_func(n))^2;
end

fprintf('Middeleffekten i f er: P_f = %.6f\n\n', P_f_manual);


%% OPGAVE 4
fprintf('========== OPGAVE 4 ==========\n');
fprintf('Betragt funktionen f(t) = sgn(t)e^(5it)u(t)\n\n');

% 4a) Bestem Fouriertransformationen af f₁(t) = d²f(t)/dt²
fprintf('4a) Bestem Fouriertransformationen af f₁(t) = d²f(t)/dt²\n');
fprintf('--------------------------------------\n');

% Definér funktionen f(t)
f_t = sign(t)*exp(5i*t)*heaviside(t);

% Beregn Fouriertransformationen af den anden afledte
[F1_omega, forklaring4a] = ElektroMatBibTrinvis.fourierAfledt_med_forklaring(f_t, t, omega, 2);
fprintf('Fouriertransformationen af f₁(t) er: F₁(ω) = %s\n\n', char(F1_omega));

% 4b) Bestem Fouriertransformationen af f₂(t) = (-it)³f(t)
fprintf('4b) Bestem Fouriertransformationen af f₂(t) = (-it)³f(t)\n');
fprintf('--------------------------------------\n');

% Beregn Fouriertransformationen
[F2_omega, forklaring4b] = ElektroMatBibTrinvis.fourierTidMultiplikation_med_forklaring(f_t, t, omega, 3, true);
fprintf('Fouriertransformationen af f₂(t) er: F₂(ω) = %s\n\n', char(F2_omega));

% 4c) Bestem Fouriertransformationen af f₃(t) = f(3t-10)
fprintf('4c) Bestem Fouriertransformationen af f₃(t) = f(3t-10)\n');
fprintf('--------------------------------------\n');

% Beregn Fouriertransformationen
[F3_omega, forklaring4c] = ElektroMatBibTrinvis.fourierSkalering_med_forklaring(f_t, t, omega, 3, 10);
fprintf('Fouriertransformationen af f₃(t) er: F₃(ω) = %s\n\n', char(F3_omega));

% 4d) Bestem Fouriertransformationen af f₄(t) = ∫_{-∞}^{t}f(τ)dτ
fprintf('4d) Bestem Fouriertransformationen af f₄(t) = ∫_{-∞}^{t}f(τ)dτ\n');
fprintf('--------------------------------------\n');

% Beregn Fouriertransformationen
[F4_omega, forklaring4d] = ElektroMatBibTrinvis.fourierIntegral_med_forklaring(f_t, t, omega);
fprintf('Fouriertransformationen af f₄(t) er: F₄(ω) = %s\n\n', char(F4_omega));

% 4e) Bestem Fouriertransformationen af f₅(t) = F(t)
fprintf('4e) Bestem Fouriertransformationen af f₅(t) = F(t)\n');
fprintf('--------------------------------------\n');

% Beregn Fouriertransformationen
[F5_omega, forklaring4e] = ElektroMatBibTrinvis.fourierAfFourier_med_forklaring(f_t, t, omega);
fprintf('Fouriertransformationen af f₅(t) er: F₅(ω) = %s\n\n', char(F5_omega));

fprintf('===== EKSAMENSOPGAVER AFSLUTTET =====\n');