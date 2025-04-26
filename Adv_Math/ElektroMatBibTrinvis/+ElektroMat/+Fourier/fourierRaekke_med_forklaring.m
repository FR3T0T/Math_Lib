function [f_approx, forklaringsOutput] = fourierRaekke_med_forklaring(cn, t, T, N)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

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
    
    % Tilføj de positive n-led
    for k = 1:N
        field_name = sprintf('c%d', k);
        if isfield(cn, field_name)
            f_approx_sym = f_approx_sym + cn.(field_name) * exp(1i*k*omega*t);
        end
    end
    
    % Tilføj de negative n-led
    for k = 1:N
        field_name = sprintf('cm%d', k);
        if isfield(cn, field_name)
            f_approx_sym = f_approx_sym + cn.(field_name) * exp(-1i*k*omega*t);
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Opbyg Fourierrækkeudtrykket', ...
        ['Vi indsætter de beregnede koefficienter:'], ...
        ['f(t) ≈ ' char(f_approx_sym)]);
    
    % Forenkl til reel form (cos/sin)
    try
        f_approx_real = simplify(f_approx_sym, 'IgnoreAnalyticConstraints', true);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Omskriv til cosinus/sinus-form', ...
            ['Vi kan omskrive udtrykt til reelle cosinus- og sinusfunktioner:'], ...
            ['f(t) ≈ ' char(f_approx_real)]);
    catch
        % Kunne ikke forenkle symbolsk
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Fourierrækken i eksponentiel form', ...
            ['Fourierrækken er udtrykt i eksponentiel form.'], ...
            ['']);
    end
    
    % Beregn effekten af signalet
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    power_sum = c0_squared;
    for k = 1:N
        if isfield(cn, sprintf('c%d', k))
            power_sum = power_sum + abs(cn.(sprintf('c%d', k)))^2;
        end
        if isfield(cn, sprintf('cm%d', k))
            power_sum = power_sum + abs(cn.(sprintf('cm%d', k)))^2;
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Beregn effekten af approksimationen', ...
        ['Signaleffekten kan beregnes ved hjælp af Parsevals teorem:'], ...
        ['P = |c₀|² + ∑ |cₙ|² fra n = -∞ til ∞, n ≠ 0']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
        'Estimér signalets effekt', ...
        ['Den estimerede effekt med ' num2str(2*N+1) ' led er:'], ...
        ['P ≈ ' num2str(power_sum)]);
    
    % Resultat
    f_approx = f_approx_sym;
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['Fourierrækkeapproksimationen er beregnet med ' num2str(2*N+1) ' led.']);
    
    % Plot approksimationen
    figure;
    
    % Generer t-værdier for 3 perioder
    t_values = linspace(-1.5*T, 1.5*T, 1000);
    
    % Evaluer funktionen
    f_values = zeros(size(t_values));
    for i = 1:length(t_values)
        f_values(i) = double(subs(f_approx, t, t_values(i)));
    end
    
    % Plot
    plot(t_values, real(f_values), 'LineWidth', 2);
    grid on;
    title(['Fourierrækkeapproksimation (N = ' num2str(N) ')']);
    xlabel('t');
    ylabel('f(t)');
    
    % Markér periodeintervallet
    xline(-T/2, '--', 'T/2');
    xline(T/2, '--', 'T/2');
    
    % Markér middelværdien
    if isfield(cn, 'c0')
        yline(real(cn.c0), '-.', 'c₀');
    end
end