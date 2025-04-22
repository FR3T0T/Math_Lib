% TestKasser.m - Test for at verificere at problemet med tomme kasser er løst
clear all;
clc;

% Sæt stier op
setup_paths();

% Definer symbolske variable
syms t s;

% Test 1: Fast værdi (skal virke uden tomme kasser)
disp('TEST 1: Enhedstrinfunktion med fast værdi t0 = 2');
[F1, ~] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(2, t, s);
disp('--------------------------------------------------');

% Test 2: Symbolsk værdi (skal virke uden tomme kasser)
disp('TEST 2: Enhedstrinfunktion med symbolsk værdi t0 = a');
syms a;
[F2, ~] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(a, t, s);
disp('--------------------------------------------------');

% Test 3: Sammensat udtryk (skal også virke uden tomme kasser)
disp('TEST 3: Opgave 1a - Stykkevis defineret funktion');
[F3a, ~] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(0, t, s);
[F3b, ~] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(1, t, s);
[F3c, ~] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(2, t, s);

F3 = F3a - 2*F3b + F3c;
disp(['Resultat: F(s) = ' char(F3)]);