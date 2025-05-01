function fix_library()
    % Find biblioteksmappen
    current_dir = pwd;
    
    % Søg efter inversLaplaceMedForklaring.m filen
    ilmf_path = findFile(current_dir, 'inversLaplaceMedForklaring.m');
    
    if isempty(ilmf_path)
        disp('Kunne ikke finde inversLaplaceMedForklaring.m');
        return;
    end
    
    % Åbn filen og erstat forkerte referencer
    content = fileread(ilmf_path);
    
    % Erstat ElektroMat.Forklaringssystem.startForklaring med ElektroMat.Forklaringssystem.startForklaring
    content = strrep(content, 'ElektroMat.Forklaringssystem.startForklaring', 'ElektroMat.Forklaringssystem.startForklaring');
    content = strrep(content, 'ElektroMat.Forklaringssystem.tilfoejTrin', 'ElektroMat.Forklaringssystem.tilfoejTrin');
    content = strrep(content, 'ElektroMat.Forklaringssystem.afslutForklaring', 'ElektroMat.Forklaringssystem.afslutForklaring');
    
    % Skriv den rettede fil
    fid = fopen(ilmf_path, 'w');
    fprintf(fid, '%s', content);
    fclose(fid);
    
    disp(['Fil rettet: ' ilmf_path]);
    
    % Find alle .m filer i biblioteket og erstat lignende referencer
    fixAllFiles(current_dir);
    
    disp('Bibliotek rettelser gennemført');
end

function file_path = findFile(dir_path, file_name)
    file_path = '';
    files = dir(fullfile(dir_path, '**', file_name));
    
    if ~isempty(files)
        file_path = fullfile(files(1).folder, files(1).name);
    end
end

function fixAllFiles(dir_path)
    files = dir(fullfile(dir_path, '**', '*.m'));
    
    for i = 1:length(files)
        if ~files(i).isdir
            file_path = fullfile(files(i).folder, files(i).name);
            
            % Læs filindhold
            content = fileread(file_path);
            
            % Tjek om der er referencer der skal rettes
            if contains(content, 'ElektroMat.Forklaringssystem.startForklaring') || ...
               contains(content, 'ElektroMat.Forklaringssystem.tilfoejTrin') || ...
               contains(content, 'ElektroMat.Forklaringssystem.afslutForklaring')
                
                % Erstat referencer
                content = strrep(content, 'ElektroMat.Forklaringssystem.startForklaring', 'ElektroMat.Forklaringssystem.startForklaring');
                content = strrep(content, 'ElektroMat.Forklaringssystem.tilfoejTrin', 'ElektroMat.Forklaringssystem.tilfoejTrin');
                content = strrep(content, 'ElektroMat.Forklaringssystem.afslutForklaring', 'ElektroMat.Forklaringssystem.afslutForklaring');
                
                % Skriv den rettede fil
                fid = fopen(file_path, 'w');
                fprintf(fid, '%s', content);
                fclose(fid);
                
                disp(['Rettet: ' file_path]);
            end
        end
    end
end