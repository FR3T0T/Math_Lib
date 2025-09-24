function test_excel_system()
    fprintf('=== TEST AF EXCEL KABELDATABASE ===\n');
    
    % Test indlæsning af database
    kabel_database = ElDim.Database.indlaesKabelData();
    
    % Vis tilgængelige kabeltyper
    kabel_typer = fieldnames(kabel_database);
    fprintf('Tilgængelige kabeltyper:\n');
    for i = 1:length(kabel_typer)
        type = kabel_typer{i};
        data = kabel_database.(type);
        fprintf('- %s: %d kabler (%.1f-%.1f mm²)\n', type, length(data.tvaersnit), ...
                str2double(data.tvaersnit{1}), str2double(data.tvaersnit{end}));
    end
    
    % Test kabeldimensionering med Excel data
    fprintf('\n=== TEST KABELDIMENSIONERING ===\n');
    [resultat, forklaring] = ElDimensioneringCalculator.dimensionerKabel(16, 20, 0.94, 0.8, 1.0, 1);
    
    fprintf('Resultat: %s mm² %s fra %s\n', resultat.areal, resultat.kabeltype, resultat.producent);
end