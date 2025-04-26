function setup_paths()
    % Remove any old paths if needed
    oldPath = path;
    if contains(oldPath, 'ElektroMatBibTrinvis')
        rmpath(genpath(fullfile(userpath, 'MATLAB Drive\Math_Lib\Adv_Math\ElektroMatBibTrinvis')));
    end
    
    % Add the Math_Lib base directory
    addpath(fullfile(userpath, 'MATLAB Drive\Math_Lib'));
    
    % Add the ElektroMatBib library
    addpath(fullfile(userpath, 'MATLAB Drive\Math_Lib\Adv_Math\ElektroMatBib'));
    
    % Add the ElektroMatBibTrinvis library and all subdirectories
    addpath(genpath(fullfile(userpath, 'MATLAB Drive\Math_Lib\Adv_Math\ElektroMatBibTrinvis')));
    
    disp('Paths set up successfully!');
end