

function [f_approx, forklaringsOutput] = fourierRaekke_med_forklaring(cn, t, T, N)
    % FOURIERRAEKKE_MED_FORKLARING Beregner Fourierrækkeapproksimation med trinvis forklaring
    %
    % Syntax:
    %   [f_approx, forklaringsOutput] = ElektroMatBibTrinvis.fourierRaekke_med_forklaring(cn, t, T, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   t - tidsvariabel (symbolsk)
    %   T - periode
    %   N - antal led i Fourierrækken
    % 
    % Output:
    %   f_approx - approksimation af den periodiske funktion
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Fourierrækkeapproksimation');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Fourierrækken', ...
        ['Fourierrækken for en periodisk funktion med periode T er givet ved:'], ...
        ['f(t) = ∑ cₙ·e^(jnω₀t) fra n = -∞ til ∞, hvor ω₀ = 2π/T']);
    
    % Beregn grundfrekvensen
    omega = 2*pi/T;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn grundfrekvensen', ...
        ['Grundfrekvensen er ω₀ = 2π/T.'], ...
        ['ω₀ = 2π/' char(T) ' = ' char(omega) ' rad/s']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Begræns antallet af led', ...
        ['Vi approksimerer Fourierrækken med et begrænset antal led:'], ...
        ['f(t) ≈ ∑ cₙ·e^(jnω₀t) fra n = -' num2str(N) ' til ' num2str(N)]);
    
    % Opbyg rækkens udtryk
    f_approx_sym = 0;
    
    % Tilføj c₀-leddet
    if isfield(cn, 'c0')
        f_approx_sym = f_approx_sym + cn.c0;
    end