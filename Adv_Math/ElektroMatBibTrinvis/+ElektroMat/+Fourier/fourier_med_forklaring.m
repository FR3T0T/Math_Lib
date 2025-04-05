function [F, forklaringsOutput] = fourier_med_forklaring(f, t, omega)
    % FOURIER_MED_FORKLARING Beregner Fouriertransformationen med trinvis forklaring
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.fourier_med_forklaring(f, t, omega)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    % 
    % Output:
    %   F - Fouriertransformationen F(omega)
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Fouriertransformation');

    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere den funktion, der skal transformeres.', ...
        ['f(t) = ' char(f)]);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Definér Fouriertransformationen', ...
        'Fouriertransformationen er defineret som:',  ...
        ['F(ω) = ∫ f(t) · e^(-jωt) dt fra -∞ til ∞']);

    % Analyser funktionen (lignende den eksisterende analyserFunktion)
    [ftype, params] = ElektroMatBibTrinvis.analyserFunktion(f, t);

    % Baseret på funktionstypen, anvend forskellige tilgange
    switch ftype
        case 'konstant'
            const_val = params.value;
            F = 2*pi*const_val*dirac(omega);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Fouriertransformation af konstant funktion', ...
                ['Fouriertransformationen af en konstant funktion ' char(const_val) ' er:'], ...
                ['F(ω) = 2π · ' char(const_val) ' · δ(ω), hvor δ er Dirac delta-funktionen']);
        
        case 'exp'
            a = params.a;
            if isreal(a)
                if a < 0
                    F = 1/(1j*omega - a);
                    
                    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                        'Fouriertransformation af eksponentialfunktion', ...
                        ['Fouriertransformationen af e^(' char(a) 't) for ' char(a) ' < 0 er:'], ...
                        ['F(ω) = 1/(jω - ' char(a) ')']);
                else
                    F = sym('Function not transformable with standard FT');
                    
                    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                        'Fouriertransformation eksisterer ikke', ...
                        ['Fouriertransformationen af e^(' char(a) 't) for ' char(a) ' > 0 eksisterer ikke i standardforstand'], ...
                        ['Funktionen vokser for hurtigt når t → ∞']);
                end
            else
                % Kompleks eksponentialfunktion
                % e^(i*a*t) → 2π*δ(ω-a)
                F = 2*pi*dirac(omega - imag(a));
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                    'Fouriertransformation af kompleks eksponentialfunktion', ...
                    ['Fouriertransformationen af e^(j' char(imag(a)) 't) er:'], ...
                    ['F(ω) = 2π · δ(ω - ' char(imag(a)) ')']);
            end
            
        case 'sin'
            a = params.a;
            F = pi*1j*(dirac(omega + a) - dirac(omega - a));
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Fouriertransformation af sinusfunktion', ...
                ['Fouriertransformationen af sin(' char(a) 't) er:'], ...
                ['F(ω) = πj · (δ(ω + ' char(a) ') - δ(ω - ' char(a) '))']);
            
        case 'cos'
            a = params.a;
            F = pi*(dirac(omega + a) + dirac(omega - a));
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Fouriertransformation af cosinusfunktion', ...
                ['Fouriertransformationen af cos(' char(a) 't) er:'], ...
                ['F(ω) = π · (δ(ω + ' char(a) ') + δ(ω - ' char(a) '))']);
        
        otherwise
            % For generelle funktioner, brug symbolsk beregning hvis muligt
            try
                F = fourier(f, t, omega);
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                    'Beregn Fouriertransformationen symbolsk', ...
                    'Vi beregner integralet symbolsk:', ...
                    ['F(ω) = ' char(F)]);
            catch
                F = sym('Complex Fourier Transform');
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                    'Kompleks Fouriertransformation', ...
                    'Denne funktion kræver specialteknikker for at transformere.', ...
                    'Ofte involverer det tabelopslag eller specielle integrationsteknikker.');
            end
    end

    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['F(ω) = ' char(F)]);
end