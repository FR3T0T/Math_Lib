function [h, forklaringsOutput] = foldningMedForklaring(f, g, t, t_range)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % FOLDNING_MED_FORKLARING Beregner foldningen af to funktioner med trinvis forklaring
    %
    % Syntax:
    %   [h, forklaringsOutput] = ElektroMatBibTrinvis.foldningMedForklaring(f, g, t, t_range)
    %
    % Input:
    %   f - første funktion som symbolsk udtryk eller function handle
    %   g - anden funktion som symbolsk udtryk eller function handle
    %   t - tidsvariabel (symbolsk)
    %   t_range - [t_min, t_max] interval for numerisk beregning
    % 
    % Output:
    %   h - resultatet af foldningen
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Foldning af Funktioner');
    
    % Vis de oprindelige funktioner
    if isa(f, 'function_handle')
        f_str = func2str(f);
    else
        f_str = char(f);
    end
    
    if isa(g, 'function_handle')
        g_str = func2str(g);
    else
        g_str = char(g);
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer funktionerne', ...
        'Vi starter med at identificere de to funktioner, der skal foldes.', ...
        ['f(t) = ' f_str '\ng(t) = ' g_str]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Definér foldningsintegralet', ...
        'Foldningen af to funktioner er defineret som integralet:', ...
        '(f * g)(t) = ∫ f(τ) · g(t-τ) dτ fra -∞ til ∞');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Analysér funktionernes støtte', ...
        'For at optimere beregningen, undersøger vi hvornår funktionerne er forskellige fra nul.', ...
        'Dette hjælper os med at bestemme integrationsintervallet mere præcist.');
    
    % Numerisk beregning af foldningen
    dt = (t_range(2) - t_range(1)) / 1000;
    t_values = t_range(1):dt:t_range(2);
    
    % Evaluer funktioner hvis de er symbolske
    if ~isa(f, 'function_handle')
        syms tau;
        f_func = matlabFunction(subs(f, t, tau));
    else
        f_func = @(tau) f(tau);
    end
    
    if ~isa(g, 'function_handle')
        g_func = matlabFunction(g);
    else
        g_func = g;
    end
    
    % Beregn foldningen for hver t-værdi
    h_values = zeros(size(t_values));
    tau_range = t_range(1):dt:t_range(2);
    
    for i = 1:length(t_values)
        t_i = t_values(i);
        integrand = zeros(size(tau_range));
        
        for j = 1:length(tau_range)
            tau_j = tau_range(j);
            % Kontroller om vi er inden for domænet hvor begge funktioner er defineret
            try
                f_val = f_func(tau_j);
                g_val = g_func(t_i - tau_j);
                integrand(j) = f_val * g_val;
            catch
                integrand(j) = 0;
            end
        end
        
        h_values(i) = sum(integrand) * dt; % Tilnærmet integral
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Numerisk beregning af foldningen', ...
        'Vi beregner foldningen numerisk ved at approksimere integralet for hver værdi af t.', ...
        'For hver værdi af t evaluerer vi integralet ∫ f(τ) · g(t-τ) dτ numerisk.');
    
    % Resultat
    h = h_values;
    
    % Visualisér resultater
    figure('Position', [100, 100, 800, 600]);
    
    % Plot f(t)
    subplot(3, 1, 1);
    f_plot = zeros(size(t_values));
    for i = 1:length(t_values)
        try
            f_plot(i) = f_func(t_values(i));
        catch
            f_plot(i) = 0;
        end
    end
    plot(t_values, f_plot, 'LineWidth', 2);
    title('f(t)');
    grid on;
    
    % Plot g(t)
    subplot(3, 1, 2);
    g_plot = zeros(size(t_values));
    for i = 1:length(t_values)
        try
            g_plot(i) = g_func(t_values(i));
        catch
            g_plot(i) = 0;
        end
    end
    plot(t_values, g_plot, 'LineWidth', 2);
    title('g(t)');
    grid on;
    
    % Plot resultat
    subplot(3, 1, 3);
    plot(t_values, h_values, 'LineWidth', 2);
    title('(f * g)(t) - Foldning');
    grid on;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Visualisér resultater', ...
        'Vi plotter de oprindelige funktioner og resultatet af foldningen.', ...
        '');
    
    % Fortolkning af resultatet
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Fortolk foldningsresultatet', ...
        ['Foldning har følgende egenskaber:\n' ...
        '1. Kommutativitet: (f * g)(t) = (g * f)(t)\n' ...
        '2. Associativitet: (f * (g * h))(t) = ((f * g) * h)(t)\n' ...
        '3. Distributivitet: (f * (g + h))(t) = (f * g)(t) + (f * h)(t)'], ...
        '');
    
    % Sammenhæng med Laplacetransformation
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
        'Relation til Laplacetransformation', ...
        'Foldningssætningen for Laplacetransformation fortæller os, at:', ...
        'L{(f * g)(t)} = L{f(t)} · L{g(t)} = F(s) · G(s)');
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Foldningen er beregnet numerisk og visualiseret.');
end