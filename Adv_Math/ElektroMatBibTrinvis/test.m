% First, set up the paths
setup_paths();

% Define symbolic variables
syms s t;

% Define the function f(t) = u(t) - 2u(t-1) + u(t-2)
% We'll use your library's functions to compute the Laplace transforms

% Calculate Laplace transform of u(t) with explanation
[F1, forklaring1] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(0, t, s);
disp('Laplacetransformation af u(t):');
disp(F1);

% Calculate Laplace transform of u(t-1) with explanation
[F2, forklaring2] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(1, t, s);
disp('Laplacetransformation af u(t-1):');
disp(F2);

% Calculate Laplace transform of u(t-2) with explanation
[F3, forklaring3] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(2, t, s);
disp('Laplacetransformation af u(t-2):');
disp(F3);

% Combined Laplace transform for f(t) = u(t) - 2u(t-1) + u(t-2)
F = 1*F1 - 2*F2 + 1*F3;
F = simplify(F);

% Display the result
disp('Den samlede Laplacetransformation F(s):');
disp(F);