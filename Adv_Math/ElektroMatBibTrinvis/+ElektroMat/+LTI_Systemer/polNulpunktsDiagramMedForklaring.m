function [poler, nulpunkter, stabilitet, forklaringsOutput] = polNulpunktsDiagramMedForklaring(num, den, system_navn)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % POLNULPUNKTSDIAGRAM_MED_FORKLARING Analyserer og visualiserer poler og nulpunkter med trinvis forklaring
    %
    % Syntax:
    %   [poler, nulpunkter, stabilitet, forklaringsOutput] = polNulpunktsDiagramMedForklaring(num, den, system_navn)
    %
    % Input:
    %   num - tæller polynomium (koefficienter eller symbolsk)
    %   den - nævner polynomium (koefficienter eller symbolsk)
    %   system_navn - navn på systemet (valgfrit)
    % 
    % Output:
    %   poler - array med systemets poler
    %   nulpunkter - array med systemets nulpunkter
    %   stabilitet - struktur med stabilitetsinformation
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Default system navn
    if nargin < 3
        system_navn = 'LTI System';
    end
    
    % Starter forklaring
    forklaringsOutput = startForklaring(['Pol-Nulpunktsanalyse af ' system_navn]);
    
    % Håndter input - konverter til koefficienter hvis nødvendigt
    if ~isnumeric(num)
        try
            syms s;
            num = sym2poly(num);
        catch
            error('Kunne ikke konvertere tæller til polynomium koefficienter');
        end
    end
    
    if ~isnumeric(den)
        try
            syms s;
            den = sym2poly(den);
        catch
            error('Kunne ikke konvertere nævner til polynomium koefficienter');
        end
    end
    
    % Vis overføringsfunktionen
    syms s;
    H_num = poly2sym(num, s);
    H_den = poly2sym(den, s);
    H_s = H_num / H_den;
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer overføringsfunktionen', ...
        'Vi starter med systemets overføringsfunktion H(s).', ...
        ['H(s) = ' char(H_s)]);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Definér poler og nulpunkter', ...
        'Poler er rødder af nævnerpolynomiet (hvor H(s) → ∞). Nulpunkter er rødder af tællerpolynomiet (hvor H(s) = 0).', ...
        '');
    
    %% FIND NULPUNKTER
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Find nulpunkter', ...
        'Nulpunkter findes ved at løse tællerpolynomiet = 0.', ...
        ['Tæller: ' char(H_num) ' = 0']);
    
    nulpunkter = roots(num);
    if isempty(nulpunkter)
        nulpunkter = [];
        nul_tekst = 'Ingen nulpunkter (konstant tæller)';
    else
        nul_tekst = 'Nulpunkter:';
        for i = 1:length(nulpunkter)
            if abs(imag(nulpunkter(i))) < 1e-10
                nul_tekst = [nul_tekst char(10) 'z' num2str(i) ' = ' num2str(real(nulpunkter(i)), '%.6f') ' (reel)'];
            else
                nul_tekst = [nul_tekst char(10) 'z' num2str(i) ' = ' num2str(real(nulpunkter(i)), '%.6f') ' ± j' num2str(abs(imag(nulpunkter(i))), '%.6f') ' (kompleks par)'];
            end
        end
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        'Resultater - nulpunkter', ...
        'Vi har beregnet følgende nulpunkter:', ...
        nul_tekst);
    
    %% FIND POLER
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
        'Find poler', ...
        'Poler findes ved at løse nævnerpolynomiet = 0.', ...
        ['Nævner: ' char(H_den) ' = 0']);
    
    poler = roots(den);
    pol_tekst = 'Poler:';
    for i = 1:length(poler)
        if abs(imag(poler(i))) < 1e-10
            pol_tekst = [pol_tekst char(10) 'p' num2str(i) ' = ' num2str(real(poler(i)), '%.6f') ' (reel pol)'];
        else
            pol_tekst = [pol_tekst char(10) 'p' num2str(i) ' = ' num2str(real(poler(i)), '%.6f') ' ± j' num2str(abs(imag(poler(i))), '%.6f') ' (kompleks pol par)'];
        end
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 6, ...
        'Resultater - poler', ...
        'Vi har beregnet følgende poler:', ...
        pol_tekst);
    
    %% STABILITETSVURDERING
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 7, ...
        'Analysér systemets stabilitet', ...
        'Et LTI-system er stabilt hvis alle poler ligger i venstre halvplan (negative realdele).', ...
        'Vi undersøger realdelen af hver pol:');
    
    real_dele = real(poler);
    ustabile_poler = sum(real_dele >= 0);
    marginal_stabile = sum(abs(real_dele) < 1e-10);
    
    if ustabile_poler == 0
        stabilitet.status = 'STABILT';
        stabilitet.besked = 'Alle poler har negative realdele';
        stabilitet.margin = abs(max(real_dele));
        stab_tekst = ['✓ SYSTEMET ER STABILT' char(10) ...
                     'Alle poler ligger i venstre halvplan' char(10) ...
                     'Stabilitet margin: ' num2str(stabilitet.margin, '%.6f')];
    elseif marginal_stabile > 0 && ustabile_poler == marginal_stabile
        stabilitet.status = 'MARGINALT STABILT';
        stabilitet.besked = 'Poler på imaginær akse';
        stabilitet.margin = 0;
        stab_tekst = ['⚠ SYSTEMET ER MARGINALT STABILT' char(10) ...
                     'Poler ligger på imaginær aksen' char(10) ...
                     'Systemet oscillerer vedvarende'];
    else
        stabilitet.status = 'USTABILT';
        stabilitet.besked = ['Mindst ' num2str(ustabile_poler) ' pol(er) i højre halvplan'];
        stabilitet.margin = max(real_dele);
        stab_tekst = ['✗ SYSTEMET ER USTABILT' char(10) ...
                     'Antal ustabile poler: ' num2str(ustabile_poler) char(10) ...
                     'Største realdel: ' num2str(stabilitet.margin, '%.6f')];
    end
    
    stabilitet.poler = poler;
    stabilitet.real_dele = real_dele;
    stabilitet.ustabile_antal = ustabile_poler;
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 8, ...
        'Stabilitetsvurdering', ...
        'Baseret på polernes placering konkluderer vi:', ...
        stab_tekst);
    
    %% TEGN POL-NULPUNKTSDIAGRAM
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 9, ...
        'Visualiser pol-nulpunktsdiagram', ...
        'Vi plotter polerne (×) og nulpunkterne (○) i det komplekse plan for at give et visuelt overblik.', ...
        '');
    
    % Opret figur
    figure('Name', ['Pol-Nulpunktsdiagram: ' system_navn], 'Position', [100 100 900 700]);
    
    % Beregn aksegrænser
    alle_punkter = [poler; nulpunkter];
    if isempty(alle_punkter)
        axis_limit = 2;
    else
        max_abs = max(abs([real(alle_punkter); imag(alle_punkter)]));
        axis_limit = max(max_abs * 1.3, 0.5);
    end
    
    hold on; grid on;
    
    % Plot poler som røde kryds
    if ~isempty(poler)
        plot(real(poler), imag(poler), 'rx', 'MarkerSize', 15, 'LineWidth', 4, 'DisplayName', 'Poler');
        
        % Tilføj labels til poler
        for i = 1:length(poler)
            if imag(poler(i)) >= 0 || abs(imag(poler(i))) < 1e-10  % Undgå dubletter for komplekse par
                label_offset = axis_limit * 0.05;
                text(real(poler(i)) + label_offset, imag(poler(i)) + label_offset, ...
                     ['p' num2str(i)], 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'red');
            end
        end
    end
    
    % Plot nulpunkter som blå cirkler
    if ~isempty(nulpunkter)
        plot(real(nulpunkter), imag(nulpunkter), 'bo', 'MarkerSize', 12, 'LineWidth', 3, 'DisplayName', 'Nulpunkter');
        
        % Tilføj labels til nulpunkter
        for i = 1:length(nulpunkter)
            if imag(nulpunkter(i)) >= 0 || abs(imag(nulpunkter(i))) < 1e-10
                label_offset = axis_limit * 0.05;
                text(real(nulpunkter(i)) + label_offset, imag(nulpunkter(i)) + label_offset, ...
                     ['z' num2str(i)], 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'blue');
            end
        end
    end
    
    % Tegn koordinatsystem (RETTET - uden Alpha property)
    line([0 0], [-axis_limit axis_limit], 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 0.5);
    line([-axis_limit axis_limit], [0 0], 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 0.5);
    
    % Markér stabilitet områder
    patch([-axis_limit 0 0 -axis_limit], [-axis_limit -axis_limit axis_limit axis_limit], ...
          'g', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Stabilt område');
    patch([0 axis_limit axis_limit 0], [-axis_limit -axis_limit axis_limit axis_limit], ...
          'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Ustabilt område');
    
    % Formatering
    xlabel('Real del', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Imaginær del', 'FontSize', 12, 'FontWeight', 'bold');
    title(['Pol-Nulpunktsdiagram: ' system_navn], 'FontSize', 14, 'FontWeight', 'bold');
    
    % Legend
    legend_entries = {};
    if ~isempty(poler), legend_entries{end+1} = 'Poler (×)'; end
    if ~isempty(nulpunkter), legend_entries{end+1} = 'Nulpunkter (○)'; end
    legend_entries{end+1} = 'Stabilt område';
    legend_entries{end+1} = 'Ustabilt område';
    legend(legend_entries, 'Location', 'best', 'FontSize', 10);
    
    % Akser
    axis equal;
    axis([-axis_limit axis_limit -axis_limit axis_limit]);
    
    % Tilføj stabilitet tekst på plot
    text(0.02, 0.98, stabilitet.status, 'Units', 'normalized', 'FontSize', 12, ...
         'FontWeight', 'bold', 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
         'VerticalAlignment', 'top');
    
    %% SAMMENFATNING
    sammenfatning_tekst = ['SAMMENFATNING:' char(10) ...
                          '==============' char(10) ...
                          'Antal poler: ' num2str(length(poler)) char(10) ...
                          'Antal nulpunkter: ' num2str(length(nulpunkter)) char(10) ...
                          'Stabilitet: ' stabilitet.status char(10) ...
                          'System orden: ' num2str(length(den)-1)];
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 10, ...
        'Sammenfatning af pol-nulpunktsanalyse', ...
        'Systemets vigtigste karakteristika:', ...
        sammenfatning_tekst);
    
    % Afslut forklaring
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        ['Pol-nulpunktsanalyse færdig. System er ' stabilitet.status]);
end