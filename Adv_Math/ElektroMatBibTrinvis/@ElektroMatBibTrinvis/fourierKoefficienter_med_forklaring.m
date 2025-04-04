

function [cn, forklaringsOutput] = fourierKoefficienter_med_forklaring(f, t, T)
    % FOURIERKOEFFICIENTER_MED_FORKLARING Beregner Fourierkoefficienter med trinvis forklaring
    %
    % Syntax:
    %   [cn, forklaringsOutput] = ElektroMatBibTrinvis.fourierKoefficienter_med_forklaring(f, t, T)
    %
    % Input:
    %   f - periodisk funktion som symbolsk udtryk
    %   t - tidsvariabel (symbolsk)
    %   T - periode
    % 
    % Output:
    %   cn - struktur med Fourierkoefficienter
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Beregning af Fourierkoefficienter');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den periodiske funktion', ...
        ['Vi starter med den periodiske funktion f(t) med periode T = ' char(T) '.'], ...
        ['f(t) = ' char(f)]);
    
    % Beregn grundfrekvensen
    omega = 2*pi/T;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Definér grundfrekvensen', ...
        ['Grundfrekvensen beregnes som ω₀ = 2π/T.'], ...
        ['ω₀ = 2π/' char(T) ' = ' char(omega) ' rad/s']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Definér formlen for Fourierkoefficienter', ...
        ['Fourierkoefficienten cₙ er defineret som:'], ...
        ['cₙ = (1/T) · ∫ f(t) · e^(-jnω₀t) dt fra -T/2 til T/2']);
    
    % Beregn koefficienter
    syms n;
    cn_expr = (1/T) * int(f * exp(-1i*n*omega*t), t, -T/2, T/2);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Opsæt integralet', ...
        ['Vi indsætter funktionen i formlen:'], ...
        ['cₙ = (1/' char(T) ') · ∫ ' char(f) ' · e^(-jn·' char(omega) '·t) dt fra -' char(T/2) ' til ' char(T/2)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Løs integralet symbolsk', ...
        ['Vi integrerer udtrykket med hensyn til t:'], ...
        ['cₙ = ' char(cn_expr)]);
    
    % Beregn specifikke koefficienter
    max_n = 5;
    c_values = struct();
    c_values.c0 = double(subs(cn_expr, n, 0));
    
    coef_text = ['c₀ = ' num2str(c_values.c0, '%.6f')];
    
    for k = 1:max_n
        c_values.(sprintf('c%d', k)) = double(subs(cn_expr, n, k));
        c_values.(sprintf('cm%d', k)) = double(subs(cn_expr, n, -k));
        
        coef_text = [coef_text '\nc₋' num2str(k) ' = ' num2str(c_values.(sprintf('cm%d', k)), '%.6f')];
        coef_text = [coef_text '\nc' num2str(k) ' = ' num2str(c_values.(sprintf('c%d', k)), '%.6f')];
    end