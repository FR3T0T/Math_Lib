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
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring('Beregning af Fourierkoefficienter');
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den periodiske funktion', ...
        ['Vi starter med den periodiske funktion f(t) med periode T = ' num2str(T) '.'], ...
        ['f(t) = ' char(f)]);
    
    % Beregn grundfrekvensen
    omega = 2*pi/T;
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Definer grundfrekvensen', ...
        ['Grundfrekvensen beregnes som omega_0 = 2pi/T.'], ...
        ['omega_0 = 2pi/' num2str(T) ' = ' num2str(omega) ' rad/s']);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Definer formlen for Fourierkoefficienter', ...
        ['Fourierkoefficienten c_n er defineret som:'], ...
        ['c_n = (1/T) * int(f(t) * e^(-jn*omega_0*t) dt) fra -T/2 til T/2']);
    
    % Beregn koefficienter
    syms n;
    cn_expr = (1/T) * int(f * exp(-1i*n*omega*t), t, -T/2, T/2);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
        'Opsaet integralet', ...
        ['Vi indsaetter funktionen i formlen:'], ...
        ['c_n = (1/' num2str(T) ') * int(' char(f) ' * e^(-jn*' num2str(omega) '*t) dt) fra -' num2str(T/2) ' til ' num2str(T/2)]);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
        'Loes integralet symbolsk', ...
        ['Vi integrerer udtrykket med hensyn til t:'], ...
        ['c_n = ' char(cn_expr)]);
    
    % Beregn specifikke koefficienter
    max_n = 7; % Oget til 7 for at vise flere koefficienter
    c_values = struct();
    
    % RETTELSE: Brug try-catch til at håndtere mulige fejl ved n=0
    try
        c_values.c0 = double(subs(cn_expr, n, 0));
    catch
        % Hvis indsætning af n=0 fejler (fx ved division med nul), beregn c0 direkte
        c0_direct = (1/T) * int(f, t, -T/2, T/2);
        c_values.c0 = double(c0_direct);
        % Tilføj et forklaringstrin om den særlige beregning
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5.5, ...
            'Saerlig beregning for c_0', ...
            ['Da det generelle udtryk ikke kan evalueres ved n=0, beregner vi c_0 direkte:'], ...
            ['c_0 = (1/T) * int(f(t) dt) fra -T/2 til T/2 = ' num2str(double(c0_direct))]);
    end
    
    % RETTELSE: Anvend formatComplexNumber funktion til korrekt formatering
    coef_text = ['c_0 = ' formatComplexNumber(c_values.c0)];
    
    for k = 1:max_n
        % RETTELSE: Brug også try-catch for andre koefficienter, selvom det normalt ikke er nødvendigt
        try
            c_values.(sprintf('c%d', k)) = double(subs(cn_expr, n, k));
        catch
            warning(['Kunne ikke beregne c' num2str(k) ' fra generelt udtryk. Forsoeger at beregne direkte.']);
            c_values.(sprintf('c%d', k)) = double((1/T) * int(f * exp(-1i*k*omega*t), t, -T/2, T/2));
        end
        
        try
            c_values.(sprintf('cm%d', k)) = double(subs(cn_expr, n, -k));
        catch
            warning(['Kunne ikke beregne c-' num2str(k) ' fra generelt udtryk. Forsoeger at beregne direkte.']);
            c_values.(sprintf('cm%d', k)) = double((1/T) * int(f * exp(1i*k*omega*t), t, -T/2, T/2));
        end
        
        % RETTELSE: Brug formatComplexNumber for korrekt formatering
        coef_text = [coef_text '\nc_-' num2str(k) ' = ' formatComplexNumber(c_values.(sprintf('cm%d', k)))];
        coef_text = [coef_text '\nc_' num2str(k) ' = ' formatComplexNumber(c_values.(sprintf('c%d', k)))];
    end
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 6, ...
        'Beregn specifikke koefficienter', ...
        ['Vi beregner koefficienterne c_0, c_1, c_-1, ..., c_' num2str(max_n) ', c_-' num2str(max_n) ':'], ...
        coef_text);
    
    % Symmetriegenskaber
    if isreal(f)
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 7, ...
            'Undersoeg symmetriegenskaber', ...
            ['Da f(t) er en reel funktion, gaelder: c_-n = c_n*'], ...
            ['Hvor * angiver den komplekst konjugerede.']);
        
        % Tjek for lige/ulige symmetri
        try
            f_even = subs(f, t, -t);
            if isequal(f_even, f)
                forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 8, ...
                    'Identificer lige symmetri', ...
                    ['Funktionen har lige symmetri: f(-t) = f(t)'], ...
                    ['Dette giver reelle Fourierkoefficienter.']);
            elseif isequal(f_even, -f)
                forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 8, ...
                    'Identificer ulige symmetri', ...
                    ['Funktionen har ulige symmetri: f(-t) = -f(t)'], ...
                    ['Dette giver rent imaginaere Fourierkoefficienter.']);
            end
        catch
            % Kunne ikke undersøge symbolsk
        end
    end
    
    % Tjek for relation mellem c_-n og c_n
    are_negative_negated = true;
    for k = 1:min(3, max_n)  % Tjek de første 3 par
        c_pos = c_values.(sprintf('c%d', k));
        c_neg = c_values.(sprintf('cm%d', k));
        
        % Undgå division med meget små tal
        if abs(c_pos) > 1e-10 && abs(c_neg) > 1e-10
            ratio = c_neg / c_pos;
            % Tjek om forholdet er tæt på -1 (med en vis tolerance pga. numeriske fejl)
            if abs(ratio - (-1)) > 0.01
                are_negative_negated = false;
                break;
            end
        elseif abs(c_pos) > 1e-10 || abs(c_neg) > 1e-10
            % Hvis kun en af dem er ikke-nul
            are_negative_negated = false;
            break;
        end
        % Hvis begge er tæt på nul, tjek næste par
    end
    
    if are_negative_negated
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 8.5, ...
            'Saerlig symmetriegenskab', ...
            ['For denne funktion ser vi, at c_-n = -c_n'], ...
            ['Dette er typisk for funktioner med saerlige symmetriegenskaber.']);
    end
    
    % Returnér koefficienter
    cn = c_values;
    
    % Afslut
    forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
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
    title('Amplitudespektrum |c_n|');
    xlabel('n');
    ylabel('|c_n|');
end

% Hjælpefunktion til formatering af komplekse tal med korrekt 'i'
function str = formatComplexNumber(z)
    % Formaterer et komplekst tal til tekst med korrekt ASCII 'i'
    re = real(z);
    im = imag(z);
    
    % Tilføj en lille buffer for at undgå numeriske fejl
    eps = 1e-10;
    
    if abs(re) < eps && abs(im) < eps
        % Nul
        str = '0.000000';
    elseif abs(re) < eps
        % Rent imaginært
        if abs(im - 1) < eps
            str = 'i';  % Bare 'i' for i
        elseif abs(im + 1) < eps
            str = '-i'; % Bare '-i' for -i
        else
            str = sprintf('%.6fi', im);  % Bruger ASCII 'i'
        end
    elseif abs(im) < eps
        % Rent reelt
        str = sprintf('%.6f', re);
    else
        % Blandet komplekst tal
        if im > 0
            str = sprintf('%.6f+%.6fi', re, im);  % Bruger ASCII 'i'
        else
            str = sprintf('%.6f%.6fi', re, im);   % Bruger ASCII 'i' (minus kommer automatisk)
        end
    end
end