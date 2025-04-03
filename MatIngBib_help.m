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
% $\begin{array}{c}\textrm{Matematisk}\\\textrm{Ingeniørbibliotek}\end{array}$

%% Hjælpefunktioner
% *unicode_dansk(inputTekst)*
%
% Konverterer mellem almindelige erstatninger og unicode for danske tegn.
%
% *demoProgrammet()*
%
% Viser brug af biblioteket med eksempler.
%
% *kommandoOversigt([kategori])*
%
% Viser en oversigt over kommandoer og deres brug i MatIngBib.

%% Komplekse Tal Funktioner
% *vis(z, [label])*
%
% Visualiserer et komplekst tal i kompleksplanen.
%
% *[r, theta] = kompleksPolaer(z)*
%
% Konverterer komplekst tal til polær form: $z = r\cdot e^{i\theta}$
%
% *z = polaerTilKompleks(r, theta)*
%
% Konverterer polær form til komplekst tal.
%
% *[re, im] = deMoivre(n, theta)*
%
% Beregner $\cos(n\theta)$ og $\sin(n\theta)$ ved hjælp af DeMoivre's formel.
%
% *result = kompleksPotens(z, n)*
%
% Beregner $z^n$ for et komplekst tal. Giver alle $n$ mulige værdier hvis $n$ er en brøk.

%% Polynomier
% *roedder = findRoedder(koeff)*
%
% Finder rødderne i et polynomium.
%
% *vaerdi = evaluerPoly(koeff, x)*
%
% Evaluerer et polynomium ved værdi x.
%
% *[q, r] = polyDivision(p, d)*
%
% Dividerer polynomium p med polynomium d: $p = q \cdot d + r$
%
% *faktorer = faktoriserPoly(koeff)*
%
% Faktoriserer et polynomium.
%
% *polyTekst = polyTilTekst(koeff, [variabel])*
%
% Konverterer polynomium-koefficienter til pæn tekstrepræsentation.

%% Taylor Polynomier
% *koeff = taylorPoly(func, x0, n)*
%
% Beregner koefficienter for Taylor-polynomium af orden n.
%
% Returnerer en vektor med koefficienter $[a_0, a_1, a_2, \ldots, a_n]$
% hvor $a_i$ er koefficienten for $(x-x_0)^i / i!$
%
% *vaerdi = evaluerTaylor(koeff, x0, x)*
%
% Evaluerer et Taylor-polynomium ved værdi x.
%
% *visTaylorApproks(func, x0, n_max, x_range)*
%
% Visualiserer Taylor-approksimationer af funktionen.

%% Førsteordens Differentialligninger
% *[t, y] = loesForsteOrden(ode_func, tspan, y0, [options])*
%
% Løser førsteordens differentialligning $y' = f(t,y)$
%
% *[t, y] = loesLinForsteOrden(p, q, tspan, y0, [options])*
%
% Løser lineær førsteordens differentialligning $y' + p(t)y = q(t)$
%
% *[t, y] = loesForsteOrdenSeparabel(ode_func, tspan, y0, [options])*
%
% Løser separabel førsteordens differentialligning $y' = f(t)g(y)$

%% Andenordens Differentialligninger
% *[t, y] = loesAndenOrden(a, b, c, f_func, init_cond, tspan, [options])*
%
% Løser andenordens differentialligning $a \cdot y'' + b \cdot y' + c \cdot y = f(t)$
%
% *[t, y] = loesAndenOrdenKonstant(a, b, c, f_func, init_cond, tspan)*
%
% Løser andenordens differentialligning med konstante koefficienter.
%
% *visAndenOrdenTyper()*
%
% Visualiserer de tre typer af andenordens lineære homogene differentialligninger:
% $\begin{cases}
% \textrm{Overdæmpet} & \textrm{(to reelle forskellige rødder)} \\
% \textrm{Kritisk dæmpet} & \textrm{(dobbeltrod)} \\
% \textrm{Underdæmpet} & \textrm{(komplekse rødder)}
% \end{cases}$

%% Numeriske Funktioner
% *rod = karakteristiskeRoedder(a, b, c)*
%
% Finder rødderne i det karakteristiske polynomium $a\lambda^2 + b\lambda + c$
%
% *roedder = polynomRoedder(koeff)*
%
% Finder alle rødder i et polynomium og analyserer dem.

function MatIngBib_help
    % Denne funktion viser dokumentationen for MatIngBib biblioteket
    % i MATLAB's hjælpesystem med LaTeX-understøttelse.
    
    % Når denne funktion køres, vises dokumentationen i Help-vinduet
    help MatIngBib_help;
    
    % For at vise et bestemt afsnit, kan man bruge:
    % helpwin MatIngBib_help>Komplekse Tal Funktioner
end