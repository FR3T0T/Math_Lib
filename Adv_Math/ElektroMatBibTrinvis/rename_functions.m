% rename_functions.m - Script til at omdøbe funktioner fra underscore_separation til camelCase

% Find den aktuelle mappe, hvor scriptet kører fra
current_dir = pwd;
fprintf('Søger fra mappe: %s\n', current_dir);

% Liste over funktioner, der skal omdøbes
old_names = {
    'fourier_med_forklaring',
    'laplace_med_forklaring',
    'inversLaplace_med_forklaring',
    'diffLaplace_med_forklaring',
    'foldning_med_forklaring',
    'foldningssaetning_med_forklaring',
    'fourierAfledt_med_forklaring',
    'fourierTidMultiplikation_med_forklaring',
    'fourierSkalering_med_forklaring',
    'fourierIntegral_med_forklaring',
    'fourierAfFourier_med_forklaring',
    'diffLigningTilOverfoeringsfunktion_med_forklaring',
    'beregnSteprespons_med_forklaring',
    'deltaFunktion_med_forklaring',
    'enhedsTrin_med_forklaring',
    'forsinkelsesRegel_med_forklaring',
    'fourierKoefficienter_med_forklaring',
    'fourierRaekke_med_forklaring',
    'parsevalTeorem_med_forklaring',
    'energiTaethed_med_forklaring',
    'effektTaethed_med_forklaring',
    'analyserDifferentialligning_med_forklaring',
    'visBodeDiagram_med_forklaring',
    'beregnUdgangssignal_med_forklaring'
};

% Opret nye navne ved at erstatte underscore med camelCase
new_names = cell(size(old_names));
for i = 1:length(old_names)
    parts = split(old_names{i}, '_');
    if length(parts) > 1
        new_name = parts{1};
        for j = 2:length(parts)
            part = parts{j};
            part(1) = upper(part(1));
            new_name = [new_name, part];
        end
        new_names{i} = new_name;
    else
        new_names{i} = old_names{i};
    end
end

% Find alle .m filer rekursivt
disp('Søger efter filer...');
all_files = [];
dirs_to_process = {current_dir};

while ~isempty(dirs_to_process)
    current = dirs_to_process{1};
    dirs_to_process(1) = [];
    
    % Få indhold af denne mappe
    items = dir(current);
    
    % Behandl hver item
    for i = 1:length(items)
        name = items(i).name;
        full_path = fullfile(items(i).folder, name);
        
        % Spring over '.' og '..'
        if strcmp(name, '.') || strcmp(name, '..')
            continue;
        end
        
        % Hvis det er en mappe, tilføj den til listen
        if items(i).isdir
            dirs_to_process{end+1} = full_path;
        % Hvis det er en .m fil, tilføj den til listen
        elseif endsWith(name, '.m')
            all_files(end+1).name = name;
            all_files(end).folder = items(i).folder;
        end
    end
end

fprintf('Fundet %d MATLAB-filer\n', length(all_files));

% Søg efter funktionsdefinitioner og kald
disp('Gennemgår filer for at finde funktioner...');
function_definitions = {};
function_calls = {};

for i = 1:length(all_files)
    file_path = fullfile(all_files(i).folder, all_files(i).name);
    try
        file_content = fileread(file_path);
        
        % Søg efter funktionsdefinitioner
        for j = 1:length(old_names)
            % Mønster for funktionsdefinition: function [output] = navn(input)
            def_pattern = ['function\s+(?:\[.*?\]\s*=\s*|\w+\s*=\s*|)(?:[\w\.]+\.)*', old_names{j}, '\s*\('];
            if regexp(file_content, def_pattern)
                entry = struct('type', 'definition', 'function_name', old_names{j}, 'new_name', new_names{j}, 'file', file_path);
                function_definitions{end+1} = entry;
                fprintf('Fandt funktionsdefinition for %s i %s\n', old_names{j}, file_path);
            end
        end
        
        % Søg efter funktionskald
        for j = 1:length(old_names)
            % Mønster for funktionskald: navn(... eller pakke.navn(
            call_pattern = ['(?<![A-Za-z0-9_\.])(?:[\w\.]+\.)*', old_names{j}, '\s*\('];
            if regexp(file_content, call_pattern)
                entry = struct('type', 'call', 'function_name', old_names{j}, 'new_name', new_names{j}, 'file', file_path);
                function_calls{end+1} = entry;
                fprintf('Fandt funktionskald til %s i %s\n', old_names{j}, file_path);
            end
        end
        
    catch err
        fprintf('Fejl ved behandling af fil %s: %s\n', file_path, err.message);
    end
end

fprintf('\nOpsummering:\n');
fprintf('Fundet %d funktionsdefinitioner\n', length(function_definitions));
fprintf('Fundet %d funktionskald\n', length(function_calls));

% Vil du gennemføre omdøbningerne?
choice = input('Vil du gennemføre omdøbningerne? (y/n): ', 's');
if lower(choice) ~= 'y'
    fprintf('Afbryder uden at ændre filer.\n');
    return;
end

% Udfør omdøbningerne
modified_count = 0;

% Først funktionsdefinitioner
for i = 1:length(function_definitions)
    file_path = function_definitions{i}.file;
    old_name = function_definitions{i}.function_name;
    new_name = function_definitions{i}.new_name;
    
    try
        file_content = fileread(file_path);
        % Erstat funktionsdefinitionen
        def_pattern = ['(function\s+(?:\[.*?\]\s*=\s*|\w+\s*=\s*|)(?:[\w\.]+\.)*)' old_name '(\s*\()'];
        new_content = regexprep(file_content, def_pattern, ['$1' new_name '$2']);
        
        if ~strcmp(file_content, new_content)
            % Skriv filen tilbage
            fid = fopen(file_path, 'w');
            if fid > 0
                fprintf(fid, '%s', new_content);
                fclose(fid);
                fprintf('Opdateret funktionsdefinition i %s\n', file_path);
                modified_count = modified_count + 1;
            else
                fprintf('Kunne ikke åbne filen til skrivning: %s\n', file_path);
            end
        end
    catch err
        fprintf('Fejl ved opdatering af fil %s: %s\n', file_path, err.message);
    end
end

% Derefter funktionskald
for i = 1:length(function_calls)
    file_path = function_calls{i}.file;
    old_name = function_calls{i}.function_name;
    new_name = function_calls{i}.new_name;
    
    try
        file_content = fileread(file_path);
        % Erstat funktionskald
        call_pattern = ['((?<![A-Za-z0-9_\.])(?:[\w\.]+\.)*)' old_name '(\s*\()'];
        new_content = regexprep(file_content, call_pattern, ['$1' new_name '$2']);
        
        if ~strcmp(file_content, new_content)
            % Skriv filen tilbage
            fid = fopen(file_path, 'w');
            if fid > 0
                fprintf(fid, '%s', new_content);
                fclose(fid);
                fprintf('Opdateret funktionskald i %s\n', file_path);
                modified_count = modified_count + 1;
            else
                fprintf('Kunne ikke åbne filen til skrivning: %s\n', file_path);
            end
        end
    catch err
        fprintf('Fejl ved opdatering af fil %s: %s\n', file_path, err.message);
    end
end

fprintf('\nAfsluttet med %d opdaterede filer.\n', modified_count);