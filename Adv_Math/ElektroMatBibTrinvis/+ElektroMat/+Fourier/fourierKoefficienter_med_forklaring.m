function [cn, forklaringsOutput] = fourierKoefficienterMedForklaring(f, t, T)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % FOURIERKOEFFICIENTER_MED_FORKLARING Beregner Fourierkoefficienter med trinvis forklaring
    %
    % Syntax:
    %   [cn, forklaringsOutput] = ElektroMatBibTrinvis.fourierKoefficienterMedForklaring(f, t, T)
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
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Beregn specifikke koefficienter', ...
        ['Vi beregner koefficienterne c₀, c₁, c₋₁, ..., c' num2str(max_n) ', c₋' num2str(max_n) ':'], ...
        coef_text);
    
    % Symmetriegenskaber
    if isreal(f)
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
            'Undersøg symmetriegenskaber', ...
            ['Da f(t) er en reel funktion, gælder: c₋ₙ = cₙ*'], ...
            ['Hvor * angiver den komplekst konjugerede.']);
        
        % Tjek for lige/ulige symmetri
        try
            f_even = subs(f, t, -t);
            if isequal(f_even, f)
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                    'Identificer lige symmetri', ...
                    ['Funktionen har lige symmetri: f(-t) = f(t)'], ...
                    ['Dette giver reelle Fourierkoefficienter.']);
            elseif isequal(f_even, -f)
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                    'Identificer ulige symmetri', ...
                    ['Funktionen har ulige symmetri: f(-t) = -f(t)'], ...
                    ['Dette giver rent imaginære Fourierkoefficienter.']);
            end
        catch
            % Kunne ikke undersøge symbolsk
        end
    end
    
    % Returnér koefficienter
    cn = c_values;
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Fourierkoefficienter er beregnet.');
    
    % Visualiser amplitudespektrum
    figure;
    
    % Ekstrahér koefficienter til plot
    n_values = -max_n:max_n;
    c_plot = zeros(size(n_values));
    
    for i = 1:length(n_values)
        if n_values(i) == 0
            c_plot(i) = abs(c_values.c0);
        elseif n_values(i) > 0
            c_plot(i) = abs(c_values.(sprintf('c%d', n_values(i))));
        else
            c_plot(i) = abs(c_values.(sprintf('cm%d', abs(n_values(i)))));
        end
    end
    
    % Plot amplitudespektrum
    stem(n_values, c_plot, 'filled', 'LineWidth', 2);
    grid on;
    title('Amplitudespektrum |cₙ|');
    xlabel('n');
    ylabel('|cₙ|');
end