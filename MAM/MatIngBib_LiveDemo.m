%% MatIngBib Interaktiv Dokumentation
% Dette er en Live Script dokumentation af MatIngBib biblioteket

%% Indholdsfortegnelse
% # Introduktion
% # Komplekse Tal
% # Polynomier
% # Taylor Polynomier
% # Differentialligninger
% # Eksempler

%% Introduktion
% *MatIngBib* er et matematisk ingeniørbibliotek til kurset 01911 "Matematisk Analyse og Modellering".
% 
% Dette script demonstrerer brugen af biblioteket sammen med relevante teoribegreber.

%% Komplekse Tal
% Et komplekst tal $z = a + bi$ kan repræsenteres på forskellige måder:
% 
% * *Kartesisk form*: $z = a + bi$
% * *Polær form*: $z = r e^{i\theta}$, hvor $r = |z|$ og $\theta = \arg(z)$
% 
% Biblioteket indeholder følgende funktioner til komplekse tal:

% Eksempel: Visualisering af et komplekst tal
z = 3 + 4i;
fprintf('Komplekst tal: z = %.2f + %.2fi\n', real(z), imag(z));

% Find polære koordinater
[r, theta] = MatIngBib.kompleksPolaer(z);
fprintf('Polær form: r = %.2f, θ = %.4f rad (%.2f°)\n', r, theta, theta*180/pi);

% Vis tallet i kompleksplanen (dette ville køre MatIngBib.vis(z) i praksis)
figure('Name', 'Komplekst tal visualisering');
plot(real(z), imag(z), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
line([0, real(z)], [0, imag(z)], 'Color', 'b', 'LineWidth', 2);
plot(cos(linspace(0,2*pi,100)), sin(linspace(0,2*pi,100)), 'k--');
grid on; axis equal;
xlabel('Re(z)'); ylabel('Im(z)');
title('Visualisering af komplekst tal', 'Interpreter', 'latex');
text(real(z) + 0.1, imag(z) + 0.1, ['$z = ' num2str(real(z)) ' + ' num2str(imag(z)) 'i$'], 'Interpreter', 'latex');
text(real(z)/2, imag(z)/2, ['$|z| = ' num2str(r) '$'], 'Interpreter', 'latex');

% Vis alle kompleks funktioner
disp('Komplekse tal funktioner:');
disp('- MatIngBib.vis(z, [label])');
disp('- [r, theta] = MatIngBib.kompleksPolaer(z)');
disp('- z = MatIngBib.polaerTilKompleks(r, theta)');
disp('- [re, im] = MatIngBib.deMoivre(n, theta)');
disp('- result = MatIngBib.kompleksPotens(z, n)');

%% Polynomier
% Polynomier på formen $P(x) = a_n x^n + a_{n-1} x^{n-1} + \ldots + a_1 x + a_0$
% repræsenteres som vektorer [a_n, a_{n-1}, ..., a_1, a_0].
% 
% Funktioner til polynomier:

% Eksempel: Find rødder og evaluer et polynomium
p = [1 0 -4]; % x^2 - 4
fprintf('Polynomium: p(x) = x^2 - 4\n');

% Find rødderne
roedder = roots(p); % Dette ville bruge MatIngBib.findRoedder(p) i praksis
fprintf('Rødder: %.2f og %.2f\n', roedder(1), roedder(2));

% Evaluer ved en værdi
x = 3;
p_val = polyval(p, x); % Dette ville bruge MatIngBib.evaluerPoly(p, x) i praksis
fprintf('p(%.2f) = %.2f\n', x, p_val);

% Vis alle polynomie funktioner
disp('Polynomie funktioner:');
disp('- roedder = MatIngBib.findRoedder(koeff)');
disp('- vaerdi = MatIngBib.evaluerPoly(koeff, x)');
disp('- [q, r] = MatIngBib.polyDivision(p, d)');
disp('- faktorer = MatIngBib.faktoriserPoly(koeff)');
disp('- polyTekst = MatIngBib.polyTilTekst(koeff, [variabel])');

%% Taylor Polynomier
% Taylor polynomiet af orden $n$ for en funktion $f(x)$ omkring punktet $x_0$ er:
% 
% $T_n(x) = \sum_{k=0}^{n} \frac{f^{(k)}(x_0)}{k!} (x - x_0)^k$
% 
% Biblioteket har funktioner til beregning og visualisering af Taylor-polynomier:

% Eksempel: Taylor-polynomie for e^x omkring x=0
x0 = 0;
n = 3;
func = @exp;

% Dette ville bruge MatIngBib.taylorPoly(func, x0, n) i praksis
taylor_coeff = [1, 1, 1/2, 1/6]; % Koefficienter for e^x: 1 + x + x^2/2 + x^3/6

fprintf('Taylor-polynomium af %d. orden for e^x omkring x=%d:\n', n, x0);
fprintf('T_%d(x) = %.2f + %.2f*x + %.2f*x^2 + %.2f*x^3\n', n, taylor_coeff(1), taylor_coeff(2), taylor_coeff(3), taylor_coeff(4));

% Visualiserer Taylor-approksimationer
figure('Name', 'Taylor Approksimation');
x_range = [-2, 2];
x = linspace(x_range(1), x_range(2), 1000);
y_exact = func(x);

plot(x, y_exact, 'k-', 'LineWidth', 2);
hold on;

colors = jet(n);
for i = 1:n
    % Beregn i-te ordens Taylor-polynomie
    y_taylor = zeros(size(x));
    for j = 0:i
        y_taylor = y_taylor + taylor_coeff(j+1) * (x - x0).^j;
    end
    plot(x, y_taylor, 'LineWidth', 1.5, 'Color', colors(i,:));
end

plot(x0, func(x0), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
grid on;
xlabel('$x$', 'Interpreter', 'latex');
ylabel('$y$', 'Interpreter', 'latex');
title(['Taylor-approksimationer omkring $x_0 = ' num2str(x0) '$'], 'Interpreter', 'latex');
legend('Eksakt funktion', 'Orden 1', 'Orden 2', 'Orden 3', 'Udviklingspunkt', 'Location', 'best');

% Vis alle Taylor funktioner
disp('Taylor funktioner:');
disp('- koeff = MatIngBib.taylorPoly(func, x0, n)');
disp('- vaerdi = MatIngBib.evaluerTaylor(koeff, x0, x)');
disp('- MatIngBib.visTaylorApproks(func, x0, n_max, x_range)');

%% Differentialligninger
% Biblioteket kan løse forskellige typer af differentialligninger.
% 
% *Første ordens differentialligninger* på formen $y' = f(t,y)$
% 
% *Anden ordens differentialligninger* på formen $a y'' + b y' + c y = f(t)$

% Eksempel: Andenordens differentialligning y'' + 0.5y' + 2y = 0
a = 1; 
b = 0.5; 
c = 2;
init_cond = [1; 0]; % y(0) = 1, y'(0) = 0
tspan = 0:0.1:10;

% Løs differentialligningen (dette ville bruge MatIngBib.loesAndenOrden i praksis)
% Her bruger vi ode45 som en substitution
odefun = @(t, Y) [Y(2); -(b/a)*Y(2) - (c/a)*Y(1)];
[t, Y] = ode45(odefun, tspan, init_cond);

% Plot løsningen
figure('Name', 'Løsning til Differentialligning');
plot(t, Y(:,1), 'LineWidth', 2);
grid on;
xlabel('$t$', 'Interpreter', 'latex');
ylabel('$y(t)$', 'Interpreter', 'latex');
title('Løsning til $y\prime\prime + 0.5y\prime + 2y = 0$', 'Interpreter', 'latex');

% Vis differentiallignings-funktioner
disp('Differentialligning funktioner:');
disp('- [t, y] = MatIngBib.loesForsteOrden(ode_func, tspan, y0)');
disp('- [t, y] = MatIngBib.loesLinForsteOrden(p, q, tspan, y0)');
disp('- [t, y] = MatIngBib.loesAndenOrden(a, b, c, f_func, init_cond, tspan)');
disp('- MatIngBib.visAndenOrdenTyper()');

%% Eksempler på de tre typer af andenordens differentialligninger
% Andenordens lineære homogene differentialligninger kan klassificeres som:
% 
% * *Overdæmpet*: To reelle forskellige rødder i det karakteristiske polynomium
% * *Kritisk dæmpet*: Dobbeltrod i det karakteristiske polynomium
% * *Underdæmpet*: Komplekse rødder i det karakteristiske polynomium

% Tidsinterval
tspan = 0:0.1:10;

% Begyndelsesbetingelser
y0 = [1; 0]; % y(0) = 1, y'(0) = 0

% Overdæmpet (a=1, b=5, c=6)
odefun1 = @(t, Y) [Y(2); -5*Y(2) - 6*Y(1)];
[t1, Y1] = ode45(odefun1, tspan, y0);

% Kritisk dæmpet (a=1, b=6, c=9)
odefun2 = @(t, Y) [Y(2); -6*Y(2) - 9*Y(1)];
[t2, Y2] = ode45(odefun2, tspan, y0);

% Underdæmpet (a=1, b=0.5, c=1)
odefun3 = @(t, Y) [Y(2); -0.5*Y(2) - Y(1)];
[t3, Y3] = ode45(odefun3, tspan, y0);

% Plot resultaterne
figure('Name', 'Typer af andenordens differentialligninger');
plot(t1, Y1(:,1), 'r-', 'LineWidth', 2);
hold on;
plot(t2, Y2(:,1), 'g-', 'LineWidth', 2);
plot(t3, Y3(:,1), 'b-', 'LineWidth', 2);

grid on;
xlabel('$t$', 'Interpreter', 'latex');
ylabel('$y(t)$', 'Interpreter', 'latex');
title('Typer af andenordens lineære differentialligninger', 'Interpreter', 'latex');
legend('Overdæmpet', 'Kritisk dæmpet', 'Underdæmpet', 'Location', 'best');

%% Kommandooversigt
disp('For at se en detaljeret oversigt over alle funktioner, kør:');
disp('  MatIngBib.kommandoOversigt()');
disp('For specifik kategori (fx komplekse tal):');
disp('  MatIngBib.kommandoOversigt(''kompleks'')');