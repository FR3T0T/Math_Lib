% UgeEnkeltOpgaver.m - Enkel løsning til uge 1 opgaver
clear all; close all;
syms t s a real;

%% Først, lad os se, hvad biblioteket kan
ElektroMatBib.kommandoOversigt('laplace');
ElektroMatBib.laplaceTransformationsTabel();

%% Opgave 1 - Beregn Laplacetransformerede
disp('===== OPGAVE 1 =====');

% Opgave 1(a)
f1a = 1*(heaviside(t)-heaviside(t-1)) + (-1)*(heaviside(t-1)-heaviside(t-2));
F1a = ElektroMatBib.laplace(f1a, t, s);
disp('1(a) Resultat:'); simplify(F1a)

% Opgave 1(b)
f1b = exp(-5*t)*heaviside(t-a);
F1b = ElektroMatBib.laplace(f1b, t, s);
disp('1(b) Resultat:'); simplify(F1b)

%% Opgave 2 - Eulers formler
disp('===== OPGAVE 2 =====');

% Brug biblioteket til at verificere formler
f2a1 = sin(a*t);
F2a1 = ElektroMatBib.laplace(f2a1, t, s);
disp('L{sin(at)} ='); simplify(F2a1)

f2a2 = cos(a*t);
F2a2 = ElektroMatBib.laplace(f2a2, t, s);
disp('L{cos(at)} ='); simplify(F2a2)

% Opgave 2(b)
syms b real;
f2b1 = exp(-b*t)*sin(a*t);
F2b1 = ElektroMatBib.laplace(f2b1, t, s);
disp('L{e^(-bt)sin(at)} ='); simplify(F2b1)

f2b2 = exp(-b*t)*cos(a*t);
F2b2 = ElektroMatBib.laplace(f2b2, t, s);
disp('L{e^(-bt)cos(at)} ='); simplify(F2b2)

%% Opgave 3 - Invers Laplacetransformation
disp('===== OPGAVE 3 =====');

% Opgave 3(a)
F3a = 1/((s+2)*(s+5));
f3a = ElektroMatBib.inversLaplace(F3a, s, t);
disp('3(a) Resultat:'); simplify(f3a)

% Opgave 3(b)
F3b = 1/(s*(s+1)*(s+2));
f3b = ElektroMatBib.inversLaplace(F3b, s, t);
disp('3(b) Resultat:'); simplify(f3b)

% Opgave 3(c)
F3c = (3*s+7)/(s^2+9);
f3c = ElektroMatBib.inversLaplace(F3c, s, t);
disp('3(c) Resultat:'); simplify(f3c)

%% Opgave 4 - e-reglen og t-reglen
disp('===== OPGAVE 4 =====');

% Opgave 4(a-d)
f4a = exp(3*t)*cos(2*t);
F4a = ElektroMatBib.laplace(f4a, t, s);
disp('4(a) Resultat:'); simplify(F4a)

f4b = t^3*exp(-2*t);
F4b = ElektroMatBib.laplace(f4b, t, s);
disp('4(b) Resultat:'); simplify(F4b)

f4c = t*cos(2*t);
F4c = ElektroMatBib.laplace(f4c, t, s);
disp('4(c) Resultat:'); simplify(F4c)

f4d = t*exp(3*t)*cos(2*t);
F4d = ElektroMatBib.laplace(f4d, t, s);
disp('4(d) Resultat:'); simplify(F4d)

%% Opgave 5 - Invers Laplace
disp('===== OPGAVE 5 =====');

F5a = 1/(s^2+10*s+25);
f5a = ElektroMatBib.inversLaplace(F5a, s, t);
disp('5(a) Resultat:'); simplify(f5a)

F5b = 1/(s^2+10*s+26);
f5b = ElektroMatBib.inversLaplace(F5b, s, t);
disp('5(b) Resultat:'); simplify(f5b)

F5c = s/(s^2+10*s+26);
f5c = ElektroMatBib.inversLaplace(F5c, s, t);
disp('5(c) Resultat:'); simplify(f5c)

F5d = (s+3)/(s^2+6*s+11);
f5d = ElektroMatBib.inversLaplace(F5d, s, t);
disp('5(d) Resultat:'); simplify(f5d)

%% Opgave 6 & 7 - Differentialligninger
disp('===== OPGAVE 6 & 7 =====');

% Opgave 6 - Direkte beregning af den Laplacetransformerede
X6 = 1/((s+5)*(s+2)); % Fra opgaven
x6 = ElektroMatBib.inversLaplace(X6, s, t);
disp('Opgave 6 løsning:'); simplify(x6)

% Opgave 7 - Direkte beregning af den Laplacetransformerede
X7 = 1/(s*(s+1)*(s+2)); % Fra opgaven
x7 = ElektroMatBib.inversLaplace(X7, s, t);
disp('Opgave 7 løsning:'); simplify(x7)

%% Opgave 8 - Begyndelsesværdiproblem med Heaviside
disp('===== OPGAVE 8 =====');

% Biblioteket kan også bruges til at løse dette, men her vises en enkel tilgang
X8 = 2/(s*(s+1)*(s+5)); % Fra opgaven efter analysen
x8 = ElektroMatBib.inversLaplace(X8, s, t);
disp('Opgave 8 løsning:'); simplify(x8)

%% Opgave 9 - Komplekse inverse Laplacetransformationer
disp('===== OPGAVE 9 =====');

F9a = 5/((s+4)*(s+9));
f9a = ElektroMatBib.inversLaplace(F9a, s, t);
disp('9(a) Resultat:'); simplify(f9a)

F9b = 5/((s^2+4)*(s^2+9));
f9b = ElektroMatBib.inversLaplace(F9b, s, t);
disp('9(b) Resultat:'); simplify(f9b)

F9c = 20/(s^2*(s^2+4)*(s^2+9));
f9c = ElektroMatBib.inversLaplace(F9c, s, t);
disp('9(c) Resultat:'); simplify(f9c)