% convert_to_files.m
% Konverterer den oprindelige ElektroMatBibTrinvis.m til separate filer
%
% Dette script opdeler den oprindelige ElektroMatBibTrinvis.m klasse i separate 
% metode-filer. Kør dette script i samme mappe som den originale fil.

% Opret hovedmappe hvis den ikke eksisterer
if ~exist('ElektroMatBibTrinvis', 'dir')
    mkdir('ElektroMatBibTrinvis');
end

% Opret @ElektroMatBibTrinvis-mappen
method_dir = fullfile('ElektroMatBibTrinvis', '@ElektroMatBibTrinvis');
if ~exist(method_dir, 'dir')
    mkdir(method_dir);
end

% Læs original fil
original_file = 'ElektroMatBibTrinvis.m';
fid = fopen(original_file, 'r');
if fid == -1
    error('Kunne ikke åbne den originale fil.');
end

content = fscanf(fid, '%c', inf);
fclose(fid);

% Opret hovedklassefil
fprintf('Opretter hovedklassefil...\n');
% Find klassedefinition og ekstraher metodedefinitioner
class_pattern = 'classdef ElektroMatBibTrinvis\s*methods\(Static\)(.*?)end\s*end';
[class_match, ~] = regexp(content, class_pattern, 'tokens', 'match', 'dotall');

if isempty(class_match)
    error('Kunne ikke finde klassedefinitionen.');
end

% Ekstraher metodedefinitoner
method_section = class_match{1}{1};

% Find alle metodedefinitioner
method_pattern = '\s*function\s+(.*?=\s*)?([a-zA-Z0-9_]+)\s*\((.*?)\).*?end';
[method_matches, method_full_matches] = regexp(content, method_pattern, 'tokens', 'match', 'dotall');

fprintf('Fandt %d metoder.\n', length(method_matches));

% Opret hovedklassefil først
class_content = [ ...
    '% ElektroMatBibTrinvis.m - MATLAB Matematisk Bibliotek med Trinvise Forklaringer\n' ...
    '% Dette bibliotek er en udvidelse af ElektroMatBib og tilføjer detaljerede\n' ...
    '% trinvise forklaringer til matematiske operationer.\n' ...
    '%\n' ...
    '% Forfatter: Udvidelse af Frederik Tots'' bibliotek\n' ...
    '% Version: 1.0\n' ...
    '% Dato: 4/4/2025\n\n' ...
    'classdef ElektroMatBibTrinvis\n' ...
    '    methods(Static)\n'];

% Ekstraher og generer metodeerklæringer
current_section = '';
for i = 1:length(method_matches)
    % Find metodenavnet
    method_name = method_matches{i}{2};
    
    % Se efter sektionsoverskrifter
    section_pattern = '%%(.*?)%%';
    [section_matches, ~] = regexp(content, section_pattern, 'tokens', 'match');
    
    for j = 1:length(section_matches)
        section_pos = strfind(content, ['%%' section_matches{j}{1} '%%']);
        method_pos = strfind(content, method_full_matches{i});
        
        % Hvis en sektion kommer før metoden og efter den forrige sektion
        if section_pos < method_pos && (isempty(current_section) || section_pos > strfind(content, ['%%' current_section '%%']))
            % Tilføj sektionsoverskriften
            class_content = [class_content '        %%' section_matches{j}{1} '%%\n'];
            current_section = section_matches{j}{1};
        end
    end
    
    % Udled returværdier og parametre
    return_values = '';
    if ~isempty(method_matches{i}{1})
        return_values = strtrim(method_matches{i}{1});
        return_values = strrep(return_values, '=', '');
    end
    
    parameters = strtrim(method_matches{i}{3});
    
    % Tilføj metodedeklaration
    class_content = [class_content '        ' return_values method_name '(' parameters ')\n'];
end

% Afslut klassen
class_content = [class_content '    end\nend\n'];

% Skriv hovedklassefilen
main_file = fullfile('ElektroMatBibTrinvis', 'ElektroMatBibTrinvis.m');
fid = fopen(main_file, 'w');
fprintf(fid, '%s', class_content);
fclose(fid);

fprintf('Hovedklassefil oprettet: %s\n', main_file);

% Proces hver metode og opret separat fil
for i = 1:length(method_matches)
    % Find metodenavnet og indhold
    method_name = method_matches{i}{2};
    method_content = method_full_matches{i};
    
    % Opret fil
    method_file = fullfile(method_dir, [method_name '.m']);
    fid = fopen(method_file, 'w');
    fprintf(fid, '%s', method_content);
    fclose(fid);
    
    fprintf('Metodefil oprettet: %s\n', method_file);
end

% Erstat de sidste linjer i scriptet med:
try
    readme_content = fileread('README.md');
    readme_file = fullfile('ElektroMatBibTrinvis', 'README.md');
    fid = fopen(readme_file, 'w');
    fprintf(fid, '%s', readme_content);
    fclose(fid);
catch
    fprintf('README.md blev ikke fundet, men det er ikke kritisk.\n');
end

fprintf('Konvertering fuldført. Filerne er placeret i mappen "ElektroMatBibTrinvis".\n');