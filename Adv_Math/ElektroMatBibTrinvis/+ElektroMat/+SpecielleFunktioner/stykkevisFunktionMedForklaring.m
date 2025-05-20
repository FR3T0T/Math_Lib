function [f_t, forklaringsOutput] = stykkevisFunktionMedForklaring(func_liste, graenser, t)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % STYKKEVIISFUNKTION_MED_FORKLARING Udtrykker en stykkevis funktion ved hjælp af Heavisides enhedstrinfunktion
    %
    % Syntax:
    %   [f_t, forklaringsOutput] = stykkevisFunktionMedForklaring(func_liste, graenser, t)
    %
    % Input:
    %   func_liste - celle-array med funktionerne [f1, f2, ..., fn]
    %   graenser - array med grænserne [g0, g1, g2, ..., gn]
    %              hvor g0 er den nedre grænse for første interval
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   f_t - symbolsk udtryk med Heaviside funktioner
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = startForklaring('Stykkevis funktion med Heavisides enhedstrinfunktion');
    
    % Kontroller input
    if length(func_liste) ~= length(graenser) - 1
        error('Antal funktioner skal være lig med antal grænser minus 1');
    end
    
    % Opret symbolsk variabel hvis ikke givet
    if nargin < 3
        syms t;
    end
    
    % Vis den stykkevis definerede funktion
    interval_tekst = 'f(t) = ';
    for i = 1:length(func_liste)
        % Konverter funktionen til en streng - håndter specielt konstanter
        if isa(func_liste{i}, 'double') || isa(func_liste{i}, 'sym') && isempty(symvar(func_liste{i}))
            func_str = num2str(double(func_liste{i}));
        else
            func_str = char(func_liste{i});
        end
        
        % Hvis strengen stadig er tom, antag at det er 1
        if isempty(func_str)
            func_str = '1';
        end
        
        % Formatér intervallet
        if i < length(func_liste) || ~isinf(graenser(end))
            interval_tekst = [interval_tekst, func_str, ' for ', ...
                num2str(graenser(i)), ' ≤ t < ', num2str(graenser(i+1)), char(10)];
        else
            interval_tekst = [interval_tekst, func_str, ' for t ≥ ', ...
                num2str(graenser(i))];
        end
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den stykkevis definerede funktion', ...
        'Vi starter med at identificere den stykkevis definerede funktion.', ...
        interval_tekst);
    
    % Initialiser udtryk
    f_t = sym(0);
    
    % Trin 2: Introducer Heavisides enhedstrinfunktion
    heaviside_def = ['Heavisides enhedstrinfunktion u(t-a) er defineret som:', char(10), ...
         'u(t-a) = 0 for t < a', char(10), ...
         'u(t-a) = 1 for t ≥ a'];
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Introduktion til Heavisides enhedstrinfunktion', ...
        heaviside_def, ...
        'Vi bruger denne til at skifte mellem de forskellige funktionsdele.');
    
    % Byg udtryk med Heaviside funktioner og forklar trinvist
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Konverter den stykkevis funktion til Heaviside-notation', ...
        'Vi udtrykker hver del af funktionen med Heaviside-funktioner:', ...
        '');
    
    trinNummer = 4;
    heaviside_udtryk = '';
    
    for i = 1:length(func_liste)
        % Konverter funktionen til en streng - håndter specielt konstanter
        if isa(func_liste{i}, 'double') || isa(func_liste{i}, 'sym') && isempty(symvar(func_liste{i}))
            func_str = num2str(double(func_liste{i}));
        else
            func_str = char(func_liste{i});
        end
        
        % Hvis strengen stadig er tom, antag at det er 1
        if isempty(func_str)
            func_str = '1';
        end
        
        % For symbolske konstanter som 1, sørg for at de behandles korrekt
        if isa(func_liste{i}, 'sym') && isempty(symvar(func_liste{i}))
            func_value = double(func_liste{i});
        else
            func_value = func_liste{i};
        end
        
        if i == 1
            % Første interval
            if graenser(1) == 0
                del_udtryk = func_value * (heaviside(t) - heaviside(t - graenser(2)));
                heaviside_udtryk = [heaviside_udtryk, func_str, '·[u(t) - u(t-', num2str(graenser(2)), ')]'];
            else
                del_udtryk = func_value * (heaviside(t - graenser(1)) - heaviside(t - graenser(2)));
                heaviside_udtryk = [heaviside_udtryk, func_str, '·[u(t-', num2str(graenser(1)), ') - u(t-', num2str(graenser(2)), ')]'];
            end
        else
            % Andre intervaller
            if isinf(graenser(i+1))
                del_udtryk = func_value * heaviside(t - graenser(i));
                heaviside_udtryk = [heaviside_udtryk, ' + ', func_str, '·u(t-', num2str(graenser(i)), ')'];
            else
                del_udtryk = func_value * (heaviside(t - graenser(i)) - heaviside(t - graenser(i+1)));
                heaviside_udtryk = [heaviside_udtryk, ' + ', func_str, '·[u(t-', num2str(graenser(i)), ') - u(t-', num2str(graenser(i+1)), ')]'];
            end
        end
        
        f_t = f_t + del_udtryk;
        
        % Forklar hvert led
        forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, ...
            ['Del ' num2str(i) ': Funktion på intervallet [' num2str(graenser(i)) ', ' num2str(graenser(i+1)) ')'], ...
            ['Vi udtrykker f(t) = ' func_str ' på intervallet [' num2str(graenser(i)) ', ' num2str(graenser(i+1)) ') som:'], ...
            [func_str '·[u(t-' num2str(graenser(i)) ') - u(t-' num2str(graenser(i+1)) ')]']);
        
        trinNummer = trinNummer + 1;
    end
    
    % Trin for at kombinere alle udtryk
    forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, ...
        'Kombinér alle led', ...
        'Vi kombinerer alle led til et samlet udtryk:', ...
        ['f(t) = ' heaviside_udtryk]);
    
    % Forsøg at forenkle udtrykket
    f_t_simpel = simplify(f_t);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer + 1, ...
        'Forsøg at forenkle udtrykket', ...
        'Vi kan forsøge at forenkle udtrykket:', ...
        ['f(t) = ' char(f_t_simpel)]);
    
    % Afslut forklaring
    forklaringsOutput = afslutForklaring(forklaringsOutput, ['f(t) = ' char(f_t_simpel)]);
    
    % Returner det forenklede udtryk
    f_t = f_t_simpel;
end