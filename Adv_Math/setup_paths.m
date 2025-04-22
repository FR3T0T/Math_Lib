function setup_paths()
    % Fjern eventuelle gamle stier
    oldPath = path;
    if contains(oldPath, 'ElektroMatBibTrinvis')
        rmpath(genpath(fullfile(pwd, 'ElektroMatBibTrinvis')));
    end
    
    % Find den aktuelle mappe
    current_dir = pwd;
    
    % Tilføj hovedbiblioteket (ikke genpath da MATLAB automatisk søger i package-mapper)
    addpath(current_dir);
    
    % Tilføj ElektroMatBib hvis det findes
    elektromat_dir = fullfile(current_dir, 'ElektroMatBibTrinvis');
    if exist(elektromat_dir, 'dir')
        addpath(elektromat_dir);
    end
    
    disp('Stier konfigureret korrekt!');
end