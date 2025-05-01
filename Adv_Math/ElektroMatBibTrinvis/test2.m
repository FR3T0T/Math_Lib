% Opsæt bibliotek og symbolske variable
setup_paths(); % Sørg for at dette er kørt først hvis nødvendigt
syms s t;

% Opgave (b): F(s) = 1/((s+2)(s+5))
disp('===== OPGAVE (b) =====');
F_b = 1/((s+2)*(s+5));
disp('F(s) = ');
disp(F_b);

% Beregn invers Laplacetransformation med forklaring
[f_b, forklaring_b] = ElektroMatBibTrinvis.inversLaplaceMedForklaring(F_b, s, t);

disp('f(t) = ');
disp(f_b);

% Opgave (c): F(s) = 1/(s(s+1)(s+2))
disp('===== OPGAVE (c) =====');
F_c = 1/(s*(s+1)*(s+2));
disp('F(s) = ');
disp(F_c);

% Beregn invers Laplacetransformation med forklaring
[f_c, forklaring_c] = ElektroMatBibTrinvis.inversLaplaceMedForklaring(F_c, s, t);

disp('f(t) = ');
disp(f_c);

% Opgave (d): F(s) = (3s+7)/(s^2+9)
disp('===== OPGAVE (d) =====');
F_d = (3*s+7)/(s^2+9);
disp('F(s) = ');
disp(F_d);

% Beregn invers Laplacetransformation med forklaring
[f_d, forklaring_d] = ElektroMatBibTrinvis.inversLaplaceMedForklaring(F_d, s, t);

disp('f(t) = ');
disp(f_d);