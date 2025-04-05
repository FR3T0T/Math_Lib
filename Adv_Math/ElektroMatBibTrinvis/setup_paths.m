% In setup_paths.m - replace your function with this
function setup_paths()
    % Remove any existing paths first to clear warnings
    rmpath(genpath('C:\Users\frede\Documents\MATLAB\Math_Lib\Adv_Math\ElektroMatBibTrinvis'));
    
    % Add only the main directories, not the @ folders
    addpath('C:\Users\frede\Documents\MATLAB\Math_Lib');
    addpath('C:\Users\frede\Documents\MATLAB\Math_Lib\Adv_Math');
    addpath('C:\Users\frede\Documents\MATLAB\Math_Lib\Adv_Math\ElektroMatBibTrinvis');
    
    % Make sure ElektroMatBib is on the path (if it exists)
    elektromat_dir = 'C:\Users\frede\Documents\MATLAB\Math_Lib\Adv_Math\ElektroMatBib';
    if exist(elektromat_dir, 'dir')
        addpath(elektromat_dir);
    end
    
    disp('Paths set up successfully!');
end