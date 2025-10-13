function test_excel_functionality()
    % TEST_EXCEL_FUNCTIONALITY Specifik test af Excel-indlæsning
    
    fprintf('=== TEST AF EXCEL INDLÆSNING ===\n');
    
    % Test kun Excel mode
    try
        kabel_database = ElDim.Database.indlaesKabelData(true); % true = brug Excel
        
        fprintf('\n=== ANALYSE AF NYM DATA ===\n');
        if isfield(kabel_database, 'NYM')
            nym_data = kabel_database.NYM;
            
            fprintf('Antal kabler: %d\n', length(nym_data.tvaersnit));
            fprintf('Tværsnit: %s\n', strjoin(nym_data.tvaersnit, ', '));
            fprintf('Producent første kabel: %s\n', nym_data.producent{1});
            
            % Vis første par kabler detaljeret
            fprintf('\nDetaljer for første 3 kabler:\n');
            for i = 1:min(3, length(nym_data.tvaersnit))
                fprintf('  %s mm²: Iz=%.1f A, R=%.3f Ω/m, Prod=%s\n', ...
                    nym_data.tvaersnit{i}, ...
                    nym_data.belastningsevne(i), ...
                    nym_data.modstand(i), ...
                    nym_data.producent{i});
            end
        else
            fprintf('NYM data ikke fundet i database!\n');
        end
        
        % Test dimensionering med Excel data
        fprintf('\n=== TEST DIMENSIONERING MED EXCEL DATA ===\n');
        [resultat, ~] = ElDimensioneringCalculator.dimensionerKabel(16, 20, 0.94, 0.8, 1.0, 1);
        
        if strcmp(resultat.producent, 'Nexans')
            fprintf('✓ SUCCESS: Excel data blev brugt!\n');
            fprintf('Producent: %s (fra Excel)\n', resultat.producent);
        else
            fprintf('⚠ Excel data blev ikke brugt - bruger: %s\n', resultat.producent);
        end
        
        fprintf('Resultat: %s mm² %s (Iz = %.1f A)\n', ...
            resultat.areal, resultat.kabeltype, resultat.Iz);
        
    catch ME
        fprintf('✗ FEJL: %s\n', ME.message);
        fprintf('Stack trace:\n');
        for i = 1:length(ME.stack)
            fprintf('  %s (linje %d)\n', ME.stack(i).name, ME.stack(i).line);
        end
    end
    
    fprintf('\n=== SAMMENLIGNING: EXCEL vs STANDARD ===\n');
    
    % Test med Excel
    try
        db_excel = ElDim.Database.indlaesKabelData(true);
        [res_excel, ~] = ElDimensioneringCalculator.dimensionerKabel(16, 20, 0.94, 0.8, 1.0, 1);
        fprintf('Excel mode:    %s mm² fra %s\n', res_excel.areal, res_excel.producent);
    catch
        fprintf('Excel mode:    FEJL\n');
    end
    
    % Test med standard
    db_standard = ElDim.Database.indlaesKabelData(false);
    [res_standard, ~] = ElDimensioneringCalculator.dimensionerKabel(16, 20, 0.94, 0.8, 1.0, 1);
    fprintf('Standard mode: %s mm² fra %s\n', res_standard.areal, res_standard.producent);
end