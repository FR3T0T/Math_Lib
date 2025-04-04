% uge1.m
% Løsning til opgaverne fra uge 1 i Videregående Matematik for Diplom Elektroteknologi
% Benytter ElektroMatBibTrinvis biblioteket

clear all; close all; clc;

% Definer symbolske variable
syms t s a b;

fprintf('=============================================\n');
fprintf('Uge 1 - Opgavebesvarelse\n');
fprintf('=============================================\n\n');

%% Opgave 1
fprintf('Opgave 1\n');
fprintf('--------\n');

% (a) Bestem Laplacetransformationen af stykkevis defineret funktion
fprintf('(a) Bestem Laplacetransformationen af f(t) = 1 for 0 ≤ t < 1, -1 for 1 < t < 2, 0 for t > 2\n\n');
f_1a = heaviside(t) - 2*heaviside(t-1) + heaviside(t-2);
[F_1a, forklaring_1a] = ElektroMatBibTrinvis.laplace_med_forklaring(f_1a, t, s);
fprintf('F(s) = %s\n\n', char(F_1a));

% (b) Bestem Laplacetransformationen af f(t) med forskydning
fprintf('(b) Bestem Laplacetransformationen af f(t) = 0 for 0 ≤ t < a, e^(-5t) for t > a\n\n');
f_1b = heaviside(t-a)*exp(-5*t);
[F_1b, forklaring_1b] = ElektroMatBibTrinvis.laplace_med_forklaring(f_1b, t, s);
fprintf('F(s) = %s\n\n', char(F_1b));

%% Opgave 2
fprintf('Opgave 2\n');
fprintf('--------\n');

% (a) Vis formlerne for trigonometriske funktioner
fprintf('(a) Vis formlerne for L{sin(at)} og L{cos(at)}\n\n');
[F_2a_sin, forklaring_2a_sin] = ElektroMatBibTrinvis.laplace_med_forklaring(sin(a*t), t, s);
[F_2a_cos, forklaring_2a_cos] = ElektroMatBibTrinvis.laplace_med_forklaring(cos(a*t), t, s);
fprintf('L{sin(at)} = %s\n', char(F_2a_sin));
fprintf('L{cos(at)} = %s\n\n', char(F_2a_cos));

% (b) Vis formlerne for dæmpede trigonometriske funktioner
fprintf('(b) Vis formlerne for L{e^(-bt)sin(at)} og L{e^(-bt)cos(at)}\n\n');
[F_2b_sin, forklaring_2b_sin] = ElektroMatBibTrinvis.laplace_med_forklaring(exp(-b*t)*sin(a*t), t, s);
[F_2b_cos, forklaring_2b_cos] = ElektroMatBibTrinvis.laplace_med_forklaring(exp(-b*t)*cos(a*t), t, s);
fprintf('L{e^(-bt)sin(at)} = %s\n', char(F_2b_sin));
fprintf('L{e^(-bt)cos(at)} = %s\n\n', char(F_2b_cos));

%% Opgave 3
fprintf('Opgave 3\n');
fprintf('--------\n');

% (a) Invers Laplacetransformation
fprintf('(a) Bestem den invers Laplacetransformerede f(t) = L^(-1){1/((s+2)(s+5))}\n\n');
F_3a = 1/((s+2)*(s+5));
[f_3a, forklaring_3a] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_3a, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_3a));

% (b) Invers Laplacetransformation
fprintf('(b) Bestem den invers Laplacetransformerede f(t) = L^(-1){1/(s(s+1)(s+2))}\n\n');
F_3b = 1/(s*(s+1)*(s+2));
[f_3b, forklaring_3b] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_3b, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_3b));

% (c) Invers Laplacetransformation
fprintf('(c) Bestem den invers Laplacetransformerede f(t) = L^(-1){(3s+7)/(s^2+9)}\n\n');
F_3c = (3*s+7)/(s^2+9);
[f_3c, forklaring_3c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_3c, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_3c));

%% Opgave 4
fprintf('Opgave 4\n');
fprintf('--------\n');

% (a) Laplacetransformation med "e-reglen"
fprintf('(a) Bestem Laplacetransformationen af f(t) = e^(3t)cos(2t)\n\n');
f_4a = exp(3*t)*cos(2*t);
[F_4a, forklaring_4a] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4a, t, s);
fprintf('F(s) = %s\n\n', char(F_4a));

% (b) Laplacetransformation med "t-reglen"
fprintf('(b) Bestem Laplacetransformationen af f(t) = t^3e^(-2t)\n\n');
f_4b = t^3*exp(-2*t);
[F_4b, forklaring_4b] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4b, t, s);
fprintf('F(s) = %s\n\n', char(F_4b));

% (c) Laplacetransformation
fprintf('(c) Bestem Laplacetransformationen af f(t) = tcos(2t)\n\n');
f_4c = t*cos(2*t);
[F_4c, forklaring_4c] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4c, t, s);
fprintf('F(s) = %s\n\n', char(F_4c));

% (d) Laplacetransformation
fprintf('(d) Bestem Laplacetransformationen af f(t) = te^(3t)cos(2t)\n\n');
f_4d = t*exp(3*t)*cos(2*t);
[F_4d, forklaring_4d] = ElektroMatBibTrinvis.laplace_med_forklaring(f_4d, t, s);
fprintf('F(s) = %s\n\n', char(F_4d));

%% Opgave 5
fprintf('Opgave 5\n');
fprintf('--------\n');

% (a) Invers Laplacetransformation
fprintf('(a) Bestem den invers Laplacetransformerede f(t) = L^(-1){1/(s^2+10s+25)}\n\n');
F_5a = 1/(s^2+10*s+25);
[f_5a, forklaring_5a] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5a, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_5a));

% (b) Invers Laplacetransformation
fprintf('(b) Bestem den invers Laplacetransformerede f(t) = L^(-1){1/(s^2+10s+26)}\n\n');
F_5b = 1/(s^2+10*s+26);
[f_5b, forklaring_5b] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5b, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_5b));

% (c) Invers Laplacetransformation
fprintf('(c) Bestem den invers Laplacetransformerede f(t) = L^(-1){s/(s^2+10s+26)}\n\n');
F_5c = s/(s^2+10*s+26);
[f_5c, forklaring_5c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5c, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_5c));

% (d) Invers Laplacetransformation
fprintf('(d) Bestem den invers Laplacetransformerede f(t) = L^(-1){(s+3)/(s^2+6s+11)}\n\n');
F_5d = (s+3)/(s^2+6*s+11);
[f_5d, forklaring_5d] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_5d, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_5d));

%% Opgave 6
fprintf('Opgave 6\n');
fprintf('--------\n');
fprintf('Løs differentialligningen x''(t) + 5x(t) = e^(-2t) for t ≥ 0 med x(0) = 0\n\n');

% Laplacetransformer ligningen
% s*X(s) - x(0) + 5*X(s) = 1/(s+2)
% (s+5)*X(s) = 1/(s+2)
% X(s) = 1/((s+2)(s+5))

X_6 = 1/((s+2)*(s+5));
[x_6, forklaring_6] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(X_6, s, t);
fprintf('Løsning: x(t) = %s for t ≥ 0\n\n', char(x_6));

%% Opgave 7
fprintf('Opgave 7\n');
fprintf('--------\n');
fprintf('Løs begyndelsesværdiproblemet x''(t) + 3x''(t) + 2x(t) = 1 for t ≥ 0 med x(0) = 0 og x''(0) = 0\n\n');

% Laplacetransformer ligningen
% s^2*X(s) - s*x(0) - x'(0) + 3*(s*X(s) - x(0)) + 2*X(s) = 1/s
% (s^2 + 3s + 2)*X(s) = 1/s
% X(s) = 1/(s*(s^2 + 3s + 2))
% X(s) = 1/(s*(s+1)*(s+2))

X_7 = 1/(s*(s+1)*(s+2));
[x_7, forklaring_7] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(X_7, s, t);
fprintf('Løsning: x(t) = %s for t ≥ 0\n\n', char(x_7));

%% Opgave 8
fprintf('Opgave 8\n');
fprintf('--------\n');
fprintf('Løs begyndelsesværdiproblemet x''(t) + 6x''(t) + 5x(t) = 20·u(t) med x(0) = 2 og x''(0) = 2\n\n');

% Laplacetransformer ligningen
% s^2*X(s) - s*x(0) - x'(0) + 6*(s*X(s) - x(0)) + 5*X(s) = 20/s
% (s^2 + 6s + 5)*X(s) - 2s - 2 - 6*2 = 20/s
% (s^2 + 6s + 5)*X(s) = 2s + 14 + 20/s
% X(s) = (2s + 14 + 20/s)/(s^2 + 6s + 5)
% X(s) = (2s^2 + 14s + 20)/(s*(s^2 + 6s + 5))
% X(s) = (2s^2 + 14s + 20)/(s*(s+1)*(s+5))

% Vi forenkler løsningen som vist i løsningsdokumentet
X_8 = (2*s^2 + 14*s + 20)/(s*(s+1)*(s+5));
[x_8, forklaring_8] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(X_8, s, t);
fprintf('Løsning: x(t) = %s for t ≥ 0\n\n', char(x_8));

%% Opgave 9
fprintf('Opgave 9\n');
fprintf('--------\n');

% (a) Invers Laplacetransformation
fprintf('(a) Bestem den invers Laplacetransformerede f(t) = L^(-1){5/((s+4)(s+9))}\n\n');
F_9a = 5/((s+4)*(s+9));
[f_9a, forklaring_9a] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_9a, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_9a));

% (b) Invers Laplacetransformation
fprintf('(b) Bestem den invers Laplacetransformerede f(t) = L^(-1){5/((s^2+4)(s^2+9))}\n\n');
F_9b = 5/((s^2+4)*(s^2+9));
[f_9b, forklaring_9b] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_9b, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_9b));

% (c) Invers Laplacetransformation
fprintf('(c) Bestem den invers Laplacetransformerede f(t) = L^(-1){20/(s^2(s^2+4)(s^2+9))}\n\n');
F_9c = 20/(s^2*(s^2+4)*(s^2+9));
[f_9c, forklaring_9c] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F_9c, s, t);
fprintf('f(t) = %s for t ≥ 0\n\n', char(f_9c));

fprintf('=============================================\n');
fprintf('Besvarelse komplet\n');
fprintf('=============================================\n');