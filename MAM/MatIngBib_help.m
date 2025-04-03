%% MatIngBib Dokumentation
% *MatIngBib*: Matematisk Ingeniørbibliotek til 01911 "Matematisk Analyse og Modellering"
% 
% Dette bibliotek giver praktiske funktioner til at løse opgaver indenfor:
%
% * Komplekse tal
% * Polynomier
% * Taylorpolynomier
% * Differentialligninger
%
% $\begin{pmatrix}
% \textrm{Matematisk}\\
% \textrm{Ingeniør}\\
% \textrm{Bibliotek}
% \end{pmatrix}$

%% Indholdsfortegnelse
% <html>
% <ul>
%   <li><a href="#1">Hjælpefunktioner</a></li>
%   <li><a href="#2">Komplekse Tal Funktioner</a></li>
%   <li><a href="#3">Polynomier</a></li>
%   <li><a href="#4">Taylor Polynomier</a></li>
%   <li><a href="#5">Førsteordens Differentialligninger</a></li>
%   <li><a href="#6">Andenordens Differentialligninger</a></li>
%   <li><a href="#7">Numeriske Funktioner</a></li>
% </ul>
% </html>

%% Hjælpefunktioner
% *unicode_dansk(inputTekst)*
%
% Konverterer mellem almindelige erstatninger og unicode for danske tegn.
%
% Eksempel:
%   s = MatIngBib.unicode_dansk('loes differentialligning')
%   % Resultat: "løs differentialligning"
%
% *demoProgrammet()*
%
% Viser brug af biblioteket med eksempler.
%
% Eksempel:
%   MatIngBib.demoProgrammet()
%   % Viser demonstrationer af alle hovedfunktioner
%
% *kommandoOversigt([kategori])*
%
% Viser en oversigt over kommandoer og deres brug i MatIngBib.
%
% Eksempler:
%   MatIngBib.kommandoOversigt()
%   % Viser hovedmenuen
%
%   MatIngBib.kommandoOversigt('kompleks')
%   % Viser detaljer om komplekse tal funktioner

%% Komplekse Tal Funktioner
% *vis(z, [label])*
%
% Visualiserer et komplekst tal i kompleksplanen.
%
% Eksempel:
%   z = 3 + 4i;
%   MatIngBib.vis(z, 'Eksempel på komplekst tal')
%   % Opretter en figur med det komplekse tal
%
% *[r, theta] = kompleksPolaer(z)*
%
% Konverterer komplekst tal til polær form: $z = r\cdot e^{i\theta}$
%
% Eksempel:
%   [r, theta] = MatIngBib.kompleksPolaer(1+1i)
%   % Resultat: r = 1.4142, theta = 0.7854 rad (45 grader)
%
% *z = polaerTilKompleks(r, theta)*
%
% Konverterer polær form til komplekst tal.
%
% Eksempel:
%   z = MatIngBib.polaerTilKompleks(2, pi/3)
%   % Resultat: z ≈ 1 + 1.732i (2∠60°)
%
% *[re, im] = deMoivre(n, theta)*
%
% Beregner $\cos(n\theta)$ og $\sin(n\theta)$ ved hjælp af DeMoivre's formel.
%
% Eksempel:
%   [c, s] = MatIngBib.deMoivre(3, pi/6)
%   % Beregner cos(3pi/6) og sin(3pi/6)
%   % Resultat: c = 0, s = 1 (cos(pi/2) = 0, sin(pi/2) = 1)
%
% *result = kompleksPotens(z, n)*
%
% Beregner $z^n$ for et komplekst tal. Giver alle $n$ mulige værdier hvis $n$ er en brøk.
%
% Eksempler:
%   r = MatIngBib.kompleksPotens(2+3i, 2)
%   % Beregner (2+3i)^2
%   % Resultat: r = -5 + 12i
%
%   r = MatIngBib.kompleksPotens(1, 1/3)
%   % Finder alle kubikrødder af 1
%   % Resultat: r = [1, -0.5+0.866i, -0.5-0.866i]

%% Polynomier
% *roedder = findRoedder(koeff)*
%
% Finder rødderne i et polynomium.
%
% Input: 
%   koeff - vektor med koefficienter $[a_n, a_{n-1}, \ldots, a_1, a_0]$
%   for polynomiet $a_n x^n + a_{n-1} x^{n-1} + \ldots + a_1 x + a_0$
%
% Eksempel:
%   r = MatIngBib.findRoedder([1 0 -4])
%   % Finder rødder i x^2 - 4
%   % Resultat: r = [2; -2]
%
% *vaerdi = evaluerPoly(koeff, x)*
%
% Evaluerer et polynomium ved værdi x.
%
% Eksempel:
%   v = MatIngBib.evaluerPoly([1 0 -4], 3)
%   % Beregner 3^2 - 4
%   % Resultat: v = 5
%
% *[q, r] = polyDivision(p, d)*
%
% Dividerer polynomium p med polynomium d: $p = q \cdot d + r$
%
% Eksempel:
%   [q, r] = MatIngBib.polyDivision([1 -5 6], [1 -2])
%   % Dividerer x^2-5x+6 med x-2
%   % Resultat: q = [1 -3], r = [0]
%   % Hvilket svarer til: (x^2-5x+6) = (x-2)(x-3) + 0
%
% *faktorer = faktoriserPoly(koeff)*
%
% Faktoriserer et polynomium.
%
% Eksempel:
%   f = MatIngBib.faktoriserPoly([1 -5 6])
%   % Faktoriserer x^2-5x+6
%   % Resultat: f = {[1 -2], [1 -3]}
%   % Hvilket svarer til (x-2)(x-3)
%
% *polyTekst = polyTilTekst(koeff, [variabel])*
%
% Konverterer polynomium-koefficienter til pæn tekstrepræsentation.
%
% Eksempler:
%   s = MatIngBib.polyTilTekst([1 -5 6])
%   % Resultat: "x^2 -5x +6"
%
%   s = MatIngBib.polyTilTekst([2 0 -3 1], 't')
%   % Resultat: "2t^3 -3t +1"

%% Taylor Polynomier
% *koeff = taylorPoly(func, x0, n)*
%
% Beregner koefficienter for Taylor-polynomium af orden n.
%
% Returnerer en vektor med koefficienter $[a_0, a_1, a_2, \ldots, a_n]$
% hvor $a_i$ er koefficienten for $(x-x_0)^i / i!$
%
% Taylor-polynomiet af orden $n$ er defineret som:
%
% $$T_n(x) = \sum_{k=0}^{n} \frac{f^{(k)}(x_0)}{k!} (x - x_0)^k$$
%
% Eksempel:
%   k = MatIngBib.taylorPoly(@exp, 0, 3)
%   % Taylor-polynomium for e^x omkring x=0
%   % Resultat: k = [1 1 0.5 0.166...]
%   % Hvilket svarer til 1 + x + x^2/2 + x^3/6
%
% *vaerdi = evaluerTaylor(koeff, x0, x)*
%
% Evaluerer et Taylor-polynomium ved værdi x.
%
% Eksempel:
%   v = MatIngBib.evaluerTaylor([1 1 0.5 1/6], 0, 1)
%   % Evaluerer 3. ordens Taylor-polynomium for e^x ved x=1
%   % Resultat: v ≈ 2.67 (sammenlign med e^1 ≈ 2.72)
%
% *visTaylorApproks(func, x0, n_max, x_range)*
%
% Visualiserer Taylor-approksimationer af funktionen.
%
% Eksempel:
%   MatIngBib.visTaylorApproks(@sin, 0, 5, [-pi pi])
%   % Viser Taylor-approksimationer af sin(x) op til 5. orden
%   % omkring x=0 i intervallet [-π, π]

%% Førsteordens Differentialligninger
% *[t, y] = loesForsteOrden(ode_func, tspan, y0, [options])*
%
% Løser førsteordens differentialligning $y' = f(t,y)$
%
% Input:
%   ode_func - funktionshåndtag på formen f(t,y)
%   tspan - vektor [t_start, t_slut] eller detaljeret tidsvektor
%   y0 - begyndelsesværdi
%   options - valgfrie parametre til ode45
%
% Eksempel:
%   [t, y] = MatIngBib.loesForsteOrden(@(t,y) -2*y, [0 5], 1)
%   % Løser y' = -2y med y(0) = 1, som har løsningen y = e^(-2t)
%   
% *[t, y] = loesLinForsteOrden(p, q, tspan, y0, [options])*
%
% Løser lineær førsteordens differentialligning $y' + p(t)y = q(t)$
%
% Eksempel:
%   [t, y] = MatIngBib.loesLinForsteOrden(@(t) 1, @(t) t, [0 5], 0)
%   % Løser y' + y = t med y(0) = 0
%
% *[t, y] = loesForsteOrdenSeparabel(ode_func, tspan, y0, [options])*
%
% Løser separabel førsteordens differentialligning $y' = f(t)g(y)$
%
% Eksempel:
%   [t, y] = MatIngBib.loesForsteOrdenSeparabel(@(t,y) t*y, [0 2], 1)
%   % Løser y' = t*y med y(0) = 1, som har løsningen y = e^(t^2/2)

%% Andenordens Differentialligninger
% *[t, y] = loesAndenOrden(a, b, c, f_func, init_cond, tspan, [options])*
%
% Løser andenordens differentialligning $a \cdot y'' + b \cdot y' + c \cdot y = f(t)$
%
% Input:
%   a, b, c - konstante koefficienter
%   f_func - funktionshåndtag på formen f(t) eller 0 for homogen ligning
%   init_cond - [y(t_0); y'(t_0)] initial betingelser
%   tspan - vektor [t_start, t_slut] eller detaljeret tidsvektor
%   options - valgfrie parametre til ode45
%
% Eksempel:
%   [t, y] = MatIngBib.loesAndenOrden(1, 0.5, 2, 0, [1; 0], 0:0.1:10)
%   % Løser y'' + 0.5y' + 2y = 0 med y(0) = 1, y'(0) = 0
%
% *[t, y] = loesAndenOrdenKonstant(a, b, c, f_func, init_cond, tspan)*
%
% Løser andenordens differentialligning med konstante koefficienter.
%
% Eksempel: Se loesAndenOrden eksemplet ovenfor.
%
% *visAndenOrdenTyper()*
%
% Visualiserer de tre typer af andenordens lineære homogene differentialligninger:
% 
% $$\begin{cases}
% \textrm{Overdæmpet} & \textrm{(to reelle forskellige rødder)} \\
% \textrm{Kritisk dæmpet} & \textrm{(dobbeltrod)} \\
% \textrm{Underdæmpet} & \textrm{(komplekse rødder)}
% \end{cases}$$
%
% Eksempel:
%   MatIngBib.visAndenOrdenTyper()
%   % Opretter en figur med 3 kurver der viser de tre typer

%% Numeriske Funktioner
% *rod = karakteristiskeRoedder(a, b, c)*
%
% Finder rødderne i det karakteristiske polynomium $a\lambda^2 + b\lambda + c$
% og analyserer dem (overdæmpet, kritisk dæmpet, underdæmpet)
%
% Eksempel:
%   r = MatIngBib.karakteristiskeRoedder(1, 4, 4)
%   % Analyse af rødderne i λ^2 + 4λ + 4 = 0
%   % Output: Dobbeltrod (kritisk dæmpet): -2
%
% *roedder = polynomRoedder(koeff)*
%
% Finder alle rødder i et polynomium og analyserer dem.
%
% Eksempel:
%   r = MatIngBib.polynomRoedder([1 0 0 -1])
%   % Analyse af rødderne i x^3 - 1 = 0
%   % Output: En reel rod (1) og to komplekse rødder

%% Eksempler
% Her er nogle eksempler på typiske opgaver, der kan løses med biblioteket:
%
% *Eksempel 1:* Løs og visualiser en andenordens differentialligning
%
%   % Dæmpet harmonisk oscillator
%   a = 1; b = 0.5; c = 2; 
%   f_func = 0;
%   init_cond = [1; 0];  % y(0) = 1, y'(0) = 0
%   tspan = 0:0.1:10;
%   
%   [t, y] = MatIngBib.loesAndenOrden(a, b, c, f_func, init_cond, tspan);
%   
%   figure;
%   plot(t, y(:,1), 'LineWidth', 2);
%   grid on;
%   title('$y'''' + 0.5y'' + 2y = 0$', 'Interpreter', 'latex');
%   xlabel('$t$', 'Interpreter', 'latex');
%   ylabel('$y(t)$', 'Interpreter', 'latex');
%
% *Eksempel 2:* Taylorapproksimation af cosinus
%
%   % Find koefficienter for Taylor-polynomium
%   func = @cos;
%   x0 = 0;
%   n = 6;
%   
%   koeff = MatIngBib.taylorPoly(func, x0, n);
%   
%   % Vis koefficienter og polynomial
%   fprintf('Taylor-polynomium for cos(x) omkring x=0:\n');
%   fprintf('T_%d(x) = ', n);
%   for i = 0:n
%       if koeff(i+1) ~= 0
%           if i == 0
%               fprintf('%.4f ', koeff(i+1));
%           elseif koeff(i+1) > 0
%               fprintf('+ %.4f·x^%d ', koeff(i+1), i);
%           else
%               fprintf('- %.4f·x^%d ', abs(koeff(i+1)), i);
%           end
%       end
%   end
%   fprintf('\n');
%   
%   % Visualiser approximationen
%   MatIngBib.visTaylorApproks(func, x0, n, [-pi pi]);
%
% *Eksempel 3:* Arbejde med komplekse tal
%
%   % Definer et komplekst tal
%   z = 2*exp(1i*pi/4);  % Polær form: 2∠45°
%   
%   % Konverter mellem former
%   [r, theta] = MatIngBib.kompleksPolaer(z);
%   fprintf('Polær form: %.2f∠%.2f°\n', r, theta*180/pi);
%   
%   % Visualiser tallet
%   MatIngBib.vis(z, 'Komplekst tal i polær form');
%   
%   % Beregn potens
%   z_cube = MatIngBib.kompleksPotens(z, 3);
%   fprintf('z^3 = %.2f + %.2fi\n', real(z_cube), imag(z_cube));
%   
%   % Find kubikrødder af 1
%   roots_of_unity = MatIngBib.kompleksPotens(1, 1/3);
%   
%   % Visualiser alle rødder
%   figure;
%   hold on;
%   for i = 1:length(roots_of_unity)
%       plot(real(roots_of_unity(i)), imag(roots_of_unity(i)), 'ro', 'MarkerSize', 10);
%       line([0, real(roots_of_unity(i))], [0, imag(roots_of_unity(i))], 'Color', 'b');
%   end
%   grid on;
%   axis equal;
%   title('Kubikrødder af 1', 'Interpreter', 'latex');
%   xlabel('$\textrm{Re}(z)$', 'Interpreter', 'latex');
%   ylabel('$\textrm{Im}(z)$', 'Interpreter', 'latex');

%% Publishing this documentation
% To generate a nicely formatted HTML version of this documentation with 
% LaTeX equations rendered, run:
%
%   publish('MatIngBib_help.m', 'html')
%
% This will create an HTML file in a directory named 'html' that can be opened
% in any web browser.

function MatIngBib_help
    % Denne funktion viser dokumentationen for MatIngBib biblioteket
    % i MATLAB's hjælpesystem med LaTeX-understøttelse.
    
    % Når denne funktion køres, vises dokumentationen i Help-vinduet
    help MatIngBib_help;
    
    % Publish dokumentation som HTML med LaTeX-formatering
    publish('MatIngBib_help.m', 'html');
    
    % For at vise et bestemt afsnit, kan man bruge:
    % helpwin MatIngBib_help>Komplekse Tal Funktioner
end