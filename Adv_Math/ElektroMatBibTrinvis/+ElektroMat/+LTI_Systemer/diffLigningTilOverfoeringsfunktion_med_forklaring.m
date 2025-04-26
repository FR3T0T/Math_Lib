function [num, den, forklaringsOutput] = diffLigningTilOverfoeringsfunktionMedForklaring(b, a)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % DIFFLIGNINGTILOVERFØRINGSFUNKTION_MED_FORKLARING Konverterer differentialligning til overføringsfunktion med trinvis forklaring
    %
    % Syntax:
    %   [num, den, forklaringsOutput] = ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktionMedForklaring(b, a)
    %
    % Input:
    %   b - koefficienter for input [b_m, b_{m-1}, ..., b_0]
    %   a - koefficienter for output [a_n, a_{n-1}, ..., a_0]
    % 
    % Output:
    %   num - tæller polynomium
    %   den - nævner polynomium
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Konvertering af Differentialligning til Overføringsfunktion');
    
    % Vis koefficienterne
    a_str = 'a = [';
    for i = 1:length(a)
        if i == 1
            a_str = [a_str num2str(a(i))];
        else
            a_str = [a_str ', ' num2str(a(i))];
        end
    end
    a_str = [a_str ']'];
    
    b_str = 'b = [';
    for i = 1:length(b)
        if i == 1
            b_str = [b_str num2str(b(i))];
        else
            b_str = [b_str ', ' num2str(b(i))];
        end
    end
    b_str = [b_str ']'];
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer differentialligningen', ...
        'Vi starter med koefficienterne for differentialligningen.', ...
        [a_str ' (output koefficienter)\n' b_str ' (input koefficienter)']);
    
    % Opbyg differentialligningen som tekst
    diff_equation = '';
    for i = 1:length(a)
        if i == 1
            diff_equation = [diff_equation 'a_0 · y^(' num2str(length(a)-i) ')'];
        else
            diff_equation = [diff_equation ' + a_' num2str(i-1) ' · y^(' num2str(length(a)-i) ')'];
        end
    end
    diff_equation = [diff_equation ' = '];
    
    for i = 1:length(b)
        if i == 1
            diff_equation = [diff_equation 'b_0 · x^(' num2str(length(b)-i) ')'];
        else
            diff_equation = [diff_equation ' + b_' num2str(i-1) ' · x^(' num2str(length(b)-i) ')'];
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Opskriv differentialligningen', ...
        'Differentialligningen har følgende form:', ...
        diff_equation);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Tag Laplacetransformationen af begge sider', ...
        'Vi anvender Laplacetransformationen på hele ligningen under antagelse af nulbetingelser.', ...
        'L{y^(n)} = s^n·Y(s) - s^(n-1)·y(0) - ... - y^(n-1)(0)');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Antag nulbetingelser', ...
        'Vi antager at alle startbetingelser er nul: y(0) = y''(0) = ... = y^(n-1)(0) = 0.', ...
        'Dette giver: L{y^(n)} = s^n·Y(s)');
    
    % Laplacetransformationen af ligningen
    laplace_equation = '';
    for i = 1:length(a)
        if i == 1
            laplace_equation = [laplace_equation 'a_0 · s^' num2str(length(a)-i) ' · Y(s)'];
        else
            laplace_equation = [laplace_equation ' + a_' num2str(i-1) ' · s^' num2str(length(a)-i) ' · Y(s)'];
        end
    end
    laplace_equation = [laplace_equation ' = '];
    
    for i = 1:length(b)
        if i == 1
            laplace_equation = [laplace_equation 'b_0 · s^' num2str(length(b)-i) ' · X(s)'];
        else
            laplace_equation = [laplace_equation ' + b_' num2str(i-1) ' · s^' num2str(length(b)-i) ' · X(s)'];
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Opskriv ligningen i Laplace-domæne', ...
        'Efter Laplacetransformation får vi:', ...
        laplace_equation);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Isolér overføringsfunktionen', ...
        'Vi omskriver ligningen til at have Y(s) på venstre side og X(s) på højre side.', ...
        'Derefter kan vi definere overføringsfunktionen H(s) = Y(s)/X(s)');
    
    % Opbyg polynomier i symbolsk form
    syms s;
    den_sym = 0;
    for i = 1:length(a)
        den_sym = den_sym + a(i) * s^(length(a)-i);
    end
    
    num_sym = 0;
    for i = 1:length(b)
        num_sym = num_sym + b(i) * s^(length(b)-i);
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
        'Opskriv overføringsfunktionen', ...
        'Overføringsfunktionen er forholdet mellem output og input i Laplace-domæne.', ...
        ['H(s) = Y(s)/X(s) = ' char(num_sym) ' / ' char(den_sym)]);
    
    % Sørg for at a og b har korrekt format
    if isempty(a) || a(1) == 0
        error('Koefficienten a_n må ikke være 0');
    end
    
    % Normaliser så højeste koefficient i a er 1
    if a(1) ~= 1
        b_norm = b / a(1);
        a_norm = a / a(1);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
            'Normaliser overføringsfunktionen', ...
            'Vi normaliser koefficienterne så den højeste koefficient i nævneren er 1.', ...
            ['H(s) = ' char(num_sym/a(1)) ' / ' char(den_sym/a(1))]);
    else
        b_norm = b;
        a_norm = a;
    end
    
    % Returner tæller og nævner
    num = b_norm;
    den = a_norm;
    
    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['H(s) = ' char(poly2sym(num, s)) ' / ' char(poly2sym(den, s))]);
end