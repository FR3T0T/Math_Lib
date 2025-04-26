function setup_paths()
    % Remove any old paths
    oldPath = path;
    if contains(oldPath, 'ElektroMatBibTrinvis')
        rmpath(genpath('C:\Users\frede\Documents\MATLAB\Math_Lib\Adv_Math\ElektroMatBibTrinvis'));
    end
    
    % Just add the base directory - MATLAB automatically searches package folders
    addpath('C:\Users\frede\Documents\MATLAB\Math_Lib');
    
    % Add ElektroMatBib if it exists
    elektromat_dir = 'C:\Users\frede\Documents\MATLAB\Math_Lib\Adv_Math\ElektroMatBib';
    if exist(elektromat_dir, 'dir')
        addpath(elektromat_dir);
    end
    
    disp('Paths set up successfully!');
end