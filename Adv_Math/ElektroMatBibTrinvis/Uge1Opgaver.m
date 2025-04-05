% Uge1Opgaver.m - Løsninger til øvelsesopgaverne fra uge 1
% Dette script bruger ElektroMatBibTrinvis til at besvare alle
% øvelsesopgaver fra uge 1 i 62735 Videregående Matematik for Diplom Elektroteknologi

%% Initalisering
% Call the setup function to ensure paths are correct
[F1, forklaring1] = MathTools.enhedsTrin_med_forklaring(0, t, s);

% Symbolske variable
syms t s a b;
disp('62735 Videregående Matematik for Diplom Elektroteknologi');
disp('Løsninger til Uge 1 opgaver');
disp('-------------------------------------------------------');

%% Opgave 1
disp('OPGAVE 1');

% (a) Stykkevis defineret funktion
disp('Opgave 1 (a): Beregning af Laplacetransformationen af en stykkevis defineret funktion');
disp('f(t) = { 1 for 0 ≤ t < 1, -1 for 1 < t < 2, 0 for t > 2 }');

% Vi deler funktionen op og bruger linearitet
disp('Vi løser dette ved at dele funktionen op i tre dele og bruge linearitet:');
disp('f(t) = u(t) - 2*u(t-1) + u(t-2)');

% Beregn Laplacetransformation af hver del
[F1, forklaring1] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(0, t, s);
[F2, forklaring2] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(1, t, s);
[F3, forklaring3] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(2, t, s);

% Kombiner dem
F_a = F1 - 2*F2 + F3;
disp(['Resultat: F(s) = ' char(F_a)]);
disp(' ');

% (b) Forsinket eksponentialfunktion
disp('Opgave 1 (b): Beregning af Laplacetransformationen af en forsinket eksponentialfunktion');
disp('f(t) = { 0 for 0 ≤ t < a, e^(-5t) for t > a }, hvor a > 0');

% Vi bruger forsinkelsesreglen
disp('Vi bruger forsinkelsesreglen:');
f_original = exp(-5*t);
[F_exp, forklaring_exp] = ElektroMatBibTrinvis.laplace_med_forklaring(f_original, t, s);
[F_b, forklaring_b] = ElektroMatBibTrinvis.forsinkelsesRegel_med_forklaring(f_original, a, t, s);

disp(['Resultat: F(s) = ' char(F_b)]);
disp(' ');

%% Opgave 2
disp('OPGAVE 2');

% (a) Bruge Eulers formel til at vise Laplacetransformationen af sin(at) og cos(at)
disp('Opgave 2 (a): Vise formler for Laplacetransformation af trigonometriske funktioner');
disp('Vis: L{sin(at)} = a/(s^2+a^2) og L{cos(at)} = s/(s^2+a^2)');

% Beregn Laplacetransformationerne direkte
[F_sin, forklaring_sin] = ElektroMatBibTrinvis.laplace_med_forklaring(sin(a*t), t, s);
[F_cos, forklaring_cos] = ElektroMatBibTrinvis.laplace_med_forklaring(cos(a*t), t, s);

disp(['L{sin(at)} = ' char(F_sin)]);
disp(['L{cos(at)} = ' char(F_cos)]);
disp(' ');

% (b) Vise mere generelle formler for dæmpede svingninger
disp('Opgave 2 (b): Vise formler for dæmpede svingninger');
disp('Vis: L{e^(-bt)sin(at)} = a/((s+b)^2+a^2) og L{e^(-bt)cos(at)} = (s+b)/((s+b)^2+a^2)');

% Beregn Laplacetransformationerne direkte
[F_dampSin, forklaring_dampSin] = ElektroMatBibTrinvis.laplace_med_forklaring(exp(-b*t)*sin(a*t), t, s);
[F_dampCos, forklaring_dampCos] = ElektroMatBibTrinvis.laplace_med_forklaring(exp(-b*t)*cos(a*t), t, s);

disp(['L{e^(-bt)sin(at)} = ' char(F_dampSin)]);
disp(['L{e^(-bt)cos(at)} = ' char(F_dampCos)]);
disp(' ');

%% Opgave 3
disp('OPGAVE 3');
disp('Opgave 3: Find de inverse Laplacetransformerede');

% (a) F(s) = 1/((s+2)(s+5))
F_3a = 1/((s+2)*(s+5));
[f_3a, forklaring_3a] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_3a, s, t);
disp(['(a) L^(-1){1/((s+2)(s+5))} = ' char(f_3a)]);

% (b) F(s) = 1/(s(s+1)(s+2))
F_3b = 1/(s*(s+1)*(s+2));
[f_3b, forklaring_3b] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_3b, s, t);
disp(['(b) L^(-1){1/(s(s+1)(s+2))} = ' char(f_3b)]);

% (c) F(s) = (3s+7)/(s^2+9)
F_3c = (3*s+7)/(s^2+9);
[f_3c, forklaring_3c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_3c, s, t);
disp(['(c) L^(-1){(3s+7)/(s^2+9)} = ' char(f_3c)]);
disp(' ');

%% Opgave 4
disp('OPGAVE 4');
disp('Opgave 4: Beregn Laplacetransformation ved hjælp af tabel, e-reglen og t-reglen');

% (a) f(t) = e^(3t)*cos(2t)
f_4a = exp(3*t)*cos(2*t);
[F_4a, forklaring_4a] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4a, t, s);
disp(['(a) L{e^(3t)cos(2t)} = ' char(F_4a)]);

% (b) f(t) = t^3*e^(-2t)
f_4b = t^3*exp(-2*t);
[F_4b, forklaring_4b] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4b, t, s);
disp(['(b) L{t^3*e^(-2t)} = ' char(F_4b)]);

% (c) f(t) = t*cos(2t)
f_4c = t*cos(2*t);
[F_4c, forklaring_4c] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4c, t, s);
disp(['(c) L{t*cos(2t)} = ' char(F_4c)]);

% (d) f(t) = t*e^(3t)*cos(2t)
f_4d = t*exp(3*t)*cos(2*t);
[F_4d, forklaring_4d] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4d, t, s);
disp(['(d) L{t*e^(3t)*cos(2t)} = ' char(F_4d)]);
disp(' ');

%% Opgave 5
disp('OPGAVE 5');
disp('Opgave 5: Find de inverse Laplacetransformerede');

% (a) F(s) = 1/(s^2+10s+25)
F_5a = 1/(s^2+10*s+25);
[f_5a, forklaring_5a] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5a, s, t);
disp(['(a) L^(-1){1/(s^2+10s+25)} = ' char(f_5a)]);

% (b) F(s) = 1/(s^2+10s+26)
F_5b = 1/(s^2+10*s+26);
[f_5b, forklaring_5b] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5b, s, t);
disp(['(b) L^(-1){1/(s^2+10s+26)} = ' char(f_5b)]);

% (c) F(s) = s/(s^2+10s+26)
F_5c = s/(s^2+10*s+26);
[f_5c, forklaring_5c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5c, s, t);
disp(['(c) L^(-1){s/(s^2+10s+26)} = ' char(f_5c)]);

% (d) F(s) = (s+3)/(s^2+6s+11)
F_5d = (s+3)/(s^2+6*s+11);
[f_5d, forklaring_5d] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5d, s, t);
disp(['(d) L^(-1){(s+3)/(s^2+6s+11)} = ' char(f_5d)]);
disp(' ');

%% Opgave 6
disp('OPGAVE 6');
disp('Opgave 6: Løs differentialligningen x''(t) + 5x(t) = e^(-2t) for t ≥ 0 med x(0) = 0');

% Løsning ved hjælp af Laplacetransformation
syms X(s);
% Transformer differentialligningen
lhs = s^2*X(s) - s*0 - 0 + 5*X(s); % venstre side med begyndelsesbetingelser
rhs = 1/(s+2);                     % højre side: Laplacetransform af e^(-2t)

% Løs for X(s)
eqn = lhs == rhs;
X_sol = solve(eqn, X(s));
X_sol = simplify(X_sol);

disp(['Laplacetransform af løsningen: X(s) = ' char(X_sol)]);

% Find den inverse Laplacetransformerede
[x_sol, forklaring_6] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(X_sol, s, t);
disp(['Løsning: x(t) = ' char(x_sol)]);
disp(' ');

%% Opgave 7
disp('OPGAVE 7');
disp('Opgave 7: Løs begyndelsesværdiproblemet x''''(t) + 3x''(t) + 2x(t) = 1 for t ≥ 0 med x(0) = 0 og x''(0) = 0');

% Løsning ved hjælp af Laplacetransformation
syms X(s);
% Transformer differentialligningen
lhs = s^2*X(s) - s*0 - 0 + 3*(s*X(s) - 0) + 2*X(s); % venstre side med begyndelsesbetingelser
rhs = 1/s;                                          % højre side: Laplacetransform af 1

% Løs for X(s)
eqn = lhs == rhs;
X_sol = solve(eqn, X(s));
X_sol = simplify(X_sol);

disp(['Laplacetransform af løsningen: X(s) = ' char(X_sol)]);

% Find den inverse Laplacetransformerede
[x_sol, forklaring_7] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(X_sol, s, t);
disp(['Løsning: x(t) = ' char(x_sol)]);
disp(' ');

%% Opgave 8
disp('OPGAVE 8');
disp('Opgave 8: Løs begyndelsesværdiproblemet x''''(t) + 6x''(t) + 5x(t) = 20·u(t) med x(0) = 2 og x''(0) = 2');

% Løsning ved hjælp af Laplacetransformation
syms X(s);
% Transformer differentialligningen
lhs = s^2*X(s) - s*2 - 2 + 6*(s*X(s) - 2) + 5*X(s); % venstre side med begyndelsesbetingelser
rhs = 20/s;                                         % højre side: Laplacetransform af 20·u(t)

% Løs for X(s)
eqn = lhs == rhs;
X_sol = solve(eqn, X(s));
X_sol = simplify(X_sol);

disp(['Laplacetransform af løsningen: X(s) = ' char(X_sol)]);

% Find den inverse Laplacetransformerede
[x_sol, forklaring_8] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(X_sol, s, t);
disp(['Løsning: x(t) = ' char(x_sol)]);
disp(' ');

%% Opgave 9
disp('OPGAVE 9');
disp('Opgave 9: Find de inverse Laplacetransformerede');

% (a) F(s) = 5/((s+4)(s+9))
F_9a = 5/((s+4)*(s+9));
[f_9a, forklaring_9a] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_9a, s, t);
disp(['(a) L^(-1){5/((s+4)(s+9))} = ' char(f_9a)]);

% (b) F(s) = 5/((s^2+4)(s^2+9))
F_9b = 5/((s^2+4)*(s^2+9));
[f_9b, forklaring_9b] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_9b, s, t);
disp(['(b) L^(-1){5/((s^2+4)(s^2+9))} = ' char(f_9b)]);

% (c) F(s) = 20/(s^2(s^2+4)(s^2+9))
F_9c = 20/(s^2*(s^2+4)*(s^2+9));
[f_9c, forklaring_9c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_9c, s, t);
disp(['(c) L^(-1){20/(s^2(s^2+4)(s^2+9))} = ' char(f_9c)]);
disp(' ');

disp('Alle opgaver fra uge 1 er nu løst ved hjælp af ElektroMatBibTrinvis.');