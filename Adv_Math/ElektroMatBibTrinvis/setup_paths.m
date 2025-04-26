function setup_paths()
    % Find den aktuelle mappe
    current_dir = pwd;
    
    % Vi tilføjer kun den øverste mappe til stien - ikke undermapper med + tegn
    % (da disse er package-mapper som ikke kan tilføjes direkte)
    addpath(current_dir);
    
    % Brug "genpath" for at finde alle undermapper
    all_paths = genpath(current_dir);
    
    % Split streng af stier og filtrer uønskede elementer
    path_cell = split(all_paths, pathsep);
    valid_paths = {};
    
    % Filtrer mapper for at fjerne alle med + i navnet
    for i = 1:length(path_cell)
        if ~contains(path_cell{i}, '+')
            valid_paths{end+1} = path_cell{i};
        end
    end
    
    % Konverter tilbage til en sti-streng og tilføj
    valid_path_str = strjoin(valid_paths, pathsep);
    if ~isempty(valid_path_str)
        addpath(valid_path_str);
    end
    
    disp('Paths set up successfully!');
end