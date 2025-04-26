function [E, forklaringsOutput] = energiTaethed_med_forklaring(F, omega)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % ENERGITAETHED_MED_FORKLARING Beregner og forklarer energitæthedsspektrum
    %
    % Syntax:
    %   [E, forklaringsOutput] = ElektroMatBibTrinvis.energiTaethed_med_forklaring(F, omega)
    %
    % Input:
    %   F - Fouriertransformeret signal som symbolsk udtryk eller numerisk vektor
    %   omega - frekvensvariabel eller frekvensvektor for numerisk beregning
    % 
    % Output:
    %   E - energitæthedsspektrum
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Energitæthedsspektrum');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér energitæthedsspektrum', ...
        ['Energitæthedsspektret for et signal med Fouriertransformationen F(ω) er defineret som:'], ...
        ['Φ_e(ω) = |F(ω)|²/π for ω ≥ 0']);
    
    if isnumeric(F) && isnumeric(omega)
        % Numerisk beregning
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
            'Numerisk beregning', ...
            ['Vi har Fouriertransformationen givet numerisk.'], ...
            ['Beregner |F(ω)|² for alle frekvenser ω.']);
        
        % Beregn energitæthed
        E = abs(F).^2 / pi;
        
        % Total energi (numerisk integration)
        domega = mean(diff(omega));
        E_total = sum(E) * domega;
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
            'Beregn total energi', ...
            ['Den totale energi i signalet kan beregnes ved at integrere energitæthedsspektret:'], ...
            ['E = ∫ Φ_e(ω) dω ≈ ' num2str(E_total)]);
    else
        % Symbolsk beregning
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
            'Symbolsk beregning', ...
            ['Vi har Fouriertransformationen F(ω) = ' char(F)], ...
            ['Beregner |F(ω)|² symbolsk.']);
        
        % Beregn energitæthed
        E_sym = simplify(F * conj(F) / pi);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
            'Energitæthedsspektrum', ...
            ['Energitæthedsspektret er:'], ...
            ['Φ_e(ω) = ' char(E_sym)]);
        
        % Forsøg at beregne total energi
        try
            E_total = int(E_sym, omega, 0, inf);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Beregn total energi', ...
                ['Den totale energi i signalet kan beregnes ved at integrere energitæthedsspektret:'], ...
                ['E = ∫ Φ_e(ω) dω = ' char(E_total)]);
        catch
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Total energi', ...
                ['Den totale energi beregnes ved at integrere energitæthedsspektret:'], ...
                ['E = ∫ Φ_e(ω) dω fra 0 til ∞']);
        end
        
        E = E_sym;
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Fortolk energitæthedsspektrum', ...
        ['Energitæthedsspektret viser, hvordan signalets energi er fordelt over forskellige frekvenser.'], ...
        ['Høje værdier ved bestemte frekvenser indikerer, at signalet har betydelige komponenter ved disse frekvenser.']);
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Energitæthedsspektrum er beregnet.');
    
    % Visualiser hvis data er numerisk
    if isnumeric(F) && isnumeric(omega)
        figure;
        plot(omega, E, 'LineWidth', 2);
        grid on;
        title('Energitæthedsspektrum Φ_e(ω)');
        xlabel('Frekvens ω (rad/s)');
        ylabel('Φ_e(ω)');
    end
end