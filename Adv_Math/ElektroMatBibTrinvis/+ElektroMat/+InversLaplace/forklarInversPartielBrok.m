function [f, forklaringsOutput] = forklarInversPartielBrok(F, s, t, params, forklaringsOutput)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % Forklaring for partiel brøkopløsning
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Identificer funktionstypen som en rationel funktion', ...
        'Funktionen er en rationel funktion, der kan opløses i partialbrøker.', ...
        ['F(s) = ' char(F)]);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Brug partiel brøkopløsning', ...
        'Vi opløser den rationelle funktion i en sum af simplere brøker.', ...
        'F(s) = A₁/(s-p₁) + A₂/(s-p₂) + ... + B₁/((s-q₁)²+r₁²) + ...');
    
    % FORBEDRET: Faktisk beregning af partialbrøkopløsning med bedre fejlhåndtering
    partialFractionSuccess = false;
    
    try
        % Udtræk tæller og nævner
        [num_coeffs, den_coeffs] = numden(F);
        
        % Konverter til polynomium koefficienter
        if isa(num_coeffs, 'sym')
            num_poly = sym2poly(num_coeffs);
        else
            num_poly = double(num_coeffs);
        end
        
        if isa(den_coeffs, 'sym')
            den_poly = sym2poly(den_coeffs);
        else
            den_poly = double(den_coeffs);
        end
        
        % Brug MATLAB's residue funktion for partialbrøkopløsning
        [r, p, k] = residue(num_poly, den_poly);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
            'Beregn partialbrøkopløsning', ...
            ['Vi finder residuerne og polerne:'], ...
            ['Antal poler: ' num2str(length(p)) char(10) 'Polerne er rødder af nævnerpolynomiet']);
        
        % Vis polerne med forbedret formatering
        pol_tekst = 'Poler og residuer:';
        for i = 1:length(p)
            if abs(imag(p(i))) < 1e-10
                pol_tekst = [pol_tekst char(10) 'p' num2str(i) ' = ' num2str(real(p(i)), '%.6f') ', residue = ' num2str(real(r(i)), '%.6f')];
            else
                pol_tekst = [pol_tekst char(10) 'p' num2str(i) ' = ' num2str(real(p(i)), '%.6f') ' ± j' num2str(abs(imag(p(i))), '%.6f') ', residue = ' num2str(real(r(i)), '%.6f') ' ± j' num2str(imag(r(i)), '%.6f')];
            end
        end
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Resultater af partialbrøkopløsning', ...
            'Vi har fundet følgende poler og residuer:', ...
            pol_tekst);
        
        partialFractionSuccess = true;
        
    catch ME
        % Forbedret fejlhåndtering - vis specifik fejl
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
            'Partialbrøkopløsning kræver numeriske metoder', ...
            ['Automatisk partialbrøkopløsning fejlede: ' ME.message], ...
            'Vi fortsætter med MATLAB''s symbolske beregning.');
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 6, ...
        'Anvend invers transformation på hver delbrøk', ...
        'Vi transformerer hver delbrøk separat ved hjælp af standardformler.', ...
        ['L^(-1){1/(s-a)} = e^(at) · u(t)' char(10) 'L^(-1){b/((s+a)²+b²)} = e^(-at)sin(bt) · u(t)' char(10) 'L^(-1){(s+a)/((s+a)²+b²)} = e^(-at)cos(bt) · u(t)']);
    
    % FORBEDRET: Faktisk beregning af invers Laplace-transformation
    try
        % Brug MATLAB's ilaplace funktion
        f_result = ilaplace(F, s, t);
        
        % Simplifiser hvis muligt
        f_simplified = simplify(f_result);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 7, ...
            'Beregn den inverse Laplace-transformation', ...
            'Vi anvender inverse Laplace-transformation på partialbrøkerne:', ...
            ['Resultat: ' char(f_simplified)]);
        
        f = f_simplified;
        
    catch ME
        % Hvis symbolsk beregning fejler, giv en struktureret besked med specifik fejl
        warning('Invers Laplace-transformation fejlede: %s', ME.message);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 7, ...
            'Kompleks beregning kræver specialiserede metoder', ...
            ['Den inverse Laplace-transformation er kompleks for dette udtryk.', char(10), 'Fejl: ', ME.message], ...
            'Brug numeriske metoder eller konsulter tabeller over Laplace-transformationer.');
        
        f = sym('KompleksUdtryk_KraeverNumeriskBeregning');
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 8, ...
        'Kombiner delresultater', ...
        'Det endelige resultat er summen af alle delresultater.', ...
        ['f(t) = ' char(f) ' for t ≥ 0']);
    
    return;
end