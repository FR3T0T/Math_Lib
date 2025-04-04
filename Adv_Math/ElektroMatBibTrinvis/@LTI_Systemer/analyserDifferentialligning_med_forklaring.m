function forklaringsOutput = analyserDifferentialligning_med_forklaring(a)
    % ANALYSERDIFFERENTIALLIGNING_MED_FORKLARING Analyserer en differentialligning med trinvis forklaring
    %
    % Syntax:
    %   forklaringsOutput = ElektroMatBibTrinvis.analyserDifferentialligning_med_forklaring(a)
    %
    % Input:
    %   a - koefficienter [a_n, a_{n-1}, ..., a_0]
    %
    % Output:
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Analyse af Differentialligning');
    
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
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer differentialligningen', ...
        'Vi starter med koefficienterne for differentialligningen.', ...
        a_str);
    
    % Opbyg differentialligningen som tekst
    diff_equation = '';
    for i = 1:length(a)
        if i == 1
            diff_equation = [diff_equation num2str(a(i)) ' · y^(' num2str(length(a)-i) ')'];
        else
            diff_equation = [diff_equation ' + ' num2str(a(i)) ' · y^(' num2str(length(a)-i) ')'];
        end
    end
    diff_equation = [diff_equation ' = 0'];
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Opskriv den homogene differentialligning', ...
        'Den homogene differentialligning har følgende form:', ...
        diff_equation);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Opskriv det karakteristiske polynomium', ...
        'Det karakteristiske polynomium fås ved at erstatte y^(n) med λ^n.', ...
        'P(λ) = a_n·λ^n + a_(n-1)·λ^(n-1) + ... + a_1·λ + a_0');
    
    % Opbyg det karakteristiske polynomium
    char_poly = '';
    for i = 1:length(a)
        if i == 1
            char_poly = [char_poly num2str(a(i)) ' · λ^' num2str(length(a)-i)];
        else
            char_poly = [char_poly ' + ' num2str(a(i)) ' · λ^' num2str(length(a)-i)];
        end
    end
    char_poly = [char_poly ' = 0'];
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Opskriv det karakteristiske polynomium', ...
        'Det karakteristiske polynomium for denne differentialligning er:', ...
        char_poly);
    
    % Find rødder i det karakteristiske polynomium
    p = roots(a);
    
    roots_text = 'Rødderne i det karakteristiske polynomium er:';
    for i = 1:length(p)
        if imag(p(i)) == 0
            roots_text = [roots_text '\nλ_' num2str(i) ' = ' num2str(p(i),'%.4f') ' (reel)'];
        else
            roots_text = [roots_text '\nλ_' num2str(i) ' = ' num2str(real(p(i)),'%.4f') ' + ' num2str(imag(p(i)),'%.4f') 'i (kompleks)'];
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Find rødderne i det karakteristiske polynomium', ...
        'Rødderne bestemmer systemets opførsel.', ...
        roots_text);
    
    % Klassificer løsningstypen for andenordens ligning
    if length(a) == 3
        discriminant = a(2)^2 - 4*a(1)*a(3);
        
        if discriminant > 0
            damp_type = 'Dette er en overdæmpet løsning (reelle forskellige rødder).\nSystemet vil nå sin ligevægtstilstand uden oscillation, med to forskellige tidskonstanter.';
        elseif discriminant == 0
            damp_type = 'Dette er en kritisk dæmpet løsning (dobbeltrod).\nSystemet vil nå sin ligevægtstilstand uden oscillation så hurtigt som muligt.';
        else
            damp_type = 'Dette er en underdæmpet løsning (komplekse rødder).\nSystemet vil oscillere omkring ligevægtstilstanden med aftagende amplitude.';
            
            % Beregn dæmpningsforhold og naturlig frekvens
            zeta = -a(2) / (2 * sqrt(a(1) * a(3)));
            omega_n = sqrt(a(3) / a(1));
            damp_type = [damp_type '\n\nDæmpningsforhold: ζ = ' num2str(zeta,'%.4f')];
            damp_type = [damp_type '\nNaturlig frekvens: ω_n = ' num2str(omega_n,'%.4f') ' rad/s'];
            
            % Tilføj information om overshoot og settling time
            if zeta < 1
                percent_overshoot = 100 * exp(-pi * zeta / sqrt(1 - zeta^2));
                settling_time = 4 / (zeta * omega_n);
                damp_type = [damp_type '\nForventet oversving: ' num2str(percent_overshoot,'%.2f') '%'];
                damp_type = [damp_type '\nForventet indsvingningstid (4%): ' num2str(settling_time,'%.4f') ' sekunder'];
            end
        end
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
            'Klassificér løsningstypen', ...
            'For en andenordens ligning kan vi klassificere løsningstypen baseret på diskriminanten.', ...
            damp_type);
    end
    
    % Opskriv den generelle løsning baseret på rødderne
    soln_text = 'Den generelle løsning til den homogene ligning har formen:';
    soln_text = [soln_text '\ny(t) = C₁e^(λ₁t) + C₂e^(λ₂t) + ... + C_ne^(λ_nt)'];
    soln_text = [soln_text '\n\nHvor C₁, C₂, ... C_n er konstanter der bestemmes ud fra begyndelsesbetingelserne.'];
    
    % Tilføj specifik løsningsform for de forskellige rodtyper
    if length(a) == 3
        if discriminant > 0
            % Reelle forskellige rødder
            soln_text = [soln_text '\n\nFor denne differentialligning med overdæmpet respons:'];
            soln_text = [soln_text '\ny(t) = C₁e^(' num2str(p(1),'%.4f') 't) + C₂e^(' num2str(p(2),'%.4f') 't)'];
        elseif discriminant == 0
            % Dobbeltrod
            soln_text = [soln_text '\n\nFor denne differentialligning med kritisk dæmpet respons:'];
            soln_text = [soln_text '\ny(t) = (C₁ + C₂t)e^(' num2str(p(1),'%.4f') 't)'];
        else
            % Komplekse rødder
            soln_text = [soln_text '\n\nFor denne differentialligning med underdæmpet respons:'];
            soln_text = [soln_text '\ny(t) = e^(' num2str(real(p(1)),'%.4f') 't)[C₁cos(' num2str(abs(imag(p(1))),'%.4f') 't) + C₂sin(' num2str(abs(imag(p(1))),'%.4f') 't)]'];
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
        'Opskriv den generelle løsning', ...
        'Baseret på rødderne kan vi opskrive den generelle løsning til den homogene ligning.', ...
        soln_text);
    
    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Analysen er færdig. Rødderne og deres typer bestemmer systemets respons.');
end