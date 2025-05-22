% +ElektroMat/+Fourier/fourier_med_forklaring.m
function [F, forklaringsOutput] = fourierMedForklaring(f, t, omega)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % FOURIER_MED_FORKLARING Beregner Fouriertransformationen med trinvis forklaring
    %
    % Syntax:
    %   [F, forklaringsOutput] = fourierMedForklaring(f, t, omega)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    % 
    % Output:
    %   F - Fouriertransformationen F(omega)
    %   forklaringsOutput - Struktur med forklaringstrin

    % INPUT VALIDERING
    if ~isa(f, 'sym') || ~isa(t, 'sym') || ~isa(omega, 'sym')
        error('Alle input skal være symbolske variable');
    end
    
    if ~has(f, t)
        error('f skal være en funktion af t');
    end

    % Start forklaring
    forklaringsOutput = startForklaring('Fouriertransformation');

    % Vis den oprindelige funktion
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere den funktion, der skal transformeres.', ...
        ['f(t) = ' char(f)]);

    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Definér Fouriertransformationen', ...
        'Fouriertransformationen er defineret som:',  ...
        ['F(ω) = ∫ f(t) · e^(-jωt) dt fra -∞ til ∞']);

    % Analyser funktionen med forbedret fejlhåndtering
    try
        [ftype, params] = ElektroMat.Funktionsanalyse.analyserFunktion(f, t);
    catch ME
        warning('Funktionsanalyse fejlede: %s', ME.message);
        ftype = 'generel';
        params = struct();
    end

    % Baseret på funktionstypen, anvend forskellige tilgange
    switch ftype
        case 'konstant'
            const_val = params.value;
            F = 2*pi*const_val*dirac(omega);
            
            forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                'Fouriertransformation af konstant funktion', ...
                ['Fouriertransformationen af en konstant funktion ' char(const_val) ' er:'], ...
                ['F(ω) = 2π · ' char(const_val) ' · δ(ω), hvor δ er Dirac delta-funktionen']);
        
        case 'exp'
            a = params.a;
            if isreal(a)
                if real(a) < 0  % RETTET: Brug real() for at håndtere komplekse a
                    F = 1/(1j*omega - a);
                    
                    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                        'Fouriertransformation af eksponentialfunktion', ...
                        ['Fouriertransformationen af e^(' char(a) 't) for Re{' char(a) '} < 0 er:'], ...
                        ['F(ω) = 1/(jω - ' char(a) ')']);
                else
                    F = sym('TransformationEksistererIkke_UstabilFunktion');
                    
                    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                        'Fouriertransformation eksisterer ikke', ...
                        ['Fouriertransformationen af e^(' char(a) 't) for Re{' char(a) '} ≥ 0 eksisterer ikke i standardforstand'], ...
                        ['Funktionen vokser for hurtigt når t → ∞']);
                end
            else
                % Kompleks eksponentialfunktion
                % e^(i*a*t) → 2π*δ(ω-a)
                if isreal(imag(a))
                    F = 2*pi*dirac(omega - imag(a));
                    
                    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                        'Fouriertransformation af kompleks eksponentialfunktion', ...
                        ['Fouriertransformationen af e^(j' char(imag(a)) 't) er:'], ...
                        ['F(ω) = 2π · δ(ω - ' char(imag(a)) ')']);
                else
                    % Generel kompleks eksponentialfunktion
                    F = 2*pi*dirac(omega - a);
                    
                    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                        'Fouriertransformation af generel kompleks eksponentialfunktion', ...
                        ['Fouriertransformationen er:'], ...
                        ['F(ω) = 2π · δ(ω - ' char(a) ')']);
                end
            end
            
        case 'sin'
            a = params.a;
            F = pi*1j*(dirac(omega + a) - dirac(omega - a));
            
            forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                'Fouriertransformation af sinusfunktion', ...
                ['Fouriertransformationen af sin(' char(a) 't) er:'], ...
                ['F(ω) = πj · (δ(ω + ' char(a) ') - δ(ω - ' char(a) '))']);
            
        case 'cos'
            a = params.a;
            F = pi*(dirac(omega + a) + dirac(omega - a));
            
            forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                'Fouriertransformation af cosinusfunktion', ...
                ['Fouriertransformationen af cos(' char(a) 't) er:'], ...
                ['F(ω) = π · (δ(ω + ' char(a) ') + δ(ω - ' char(a) '))']);
        
        otherwise
            % For generelle funktioner, brug symbolsk beregning med forbedret fejlhåndtering
            try
                F = fourier(f, t, omega);
                
                forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                    'Beregn Fouriertransformationen symbolsk', ...
                    'Vi beregner integralet symbolsk:', ...
                    ['F(ω) = ' char(F)]);
                    
            catch ME
                % Hvis symbolsk beregning fejler
                warning('Symbolsk Fouriertransformation fejlede: %s', ME.message);
                F = sym('KompleksFourierTransformation_KraeverSpecielleTeknikker');
                
                forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
                    'Kompleks Fouriertransformation', ...
                    ['Denne funktion kræver specialteknikker for at transformere. Fejl: ' ME.message], ...
                    'Konsulter tabeller over Fouriertransformationer eller brug numeriske metoder.');
            end
    end

    % Tilføj bemærkning om kausalitet for tidsfunktioner
    if ~contains(char(f), 'heaviside') && ~contains(char(f), 'u(')
        forklaringsOutput = tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
            'Bemærkning om kausalitet', ...
            'Hvis f(t) er en kausalt signal (f(t) = 0 for t < 0), skal dette specificeres eksplicit.', ...
            'For kausale signaler: f(t) · u(t)');
    end

    % Afslut forklaring
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        ['F(ω) = ' char(F)]);
end