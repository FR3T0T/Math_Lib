function kabel_data = getStandardKabelData(kabel_type)
    % Standard data hvis Excel-filer ikke findes
    
    switch kabel_type
        case 'NYM'
            kabel_data.tvaersnit = {'1.5', '2.5', '4', '6', '10', '16', '25', '35'};
            kabel_data.belastningsevne = [18.5, 25, 32, 41, 57, 76, 101, 125];
            kabel_data.modstand = [12.1, 7.41, 4.61, 3.08, 1.83, 1.15, 0.72, 0.524];
            
        case 'PFXP'
            kabel_data.tvaersnit = {'1.5', '2.5', '4', '6', '10', '16', '25', '35'};
            kabel_data.belastningsevne = [15.5, 21, 27, 35, 48, 63, 84, 104];
            kabel_data.modstand = [12.1, 7.41, 4.61, 3.08, 1.83, 1.15, 0.72, 0.524];
            
        case 'NYY-J'
            kabel_data.tvaersnit = {'1.5', '2.5', '4', '6', '10', '16', '25', '35'};
            kabel_data.belastningsevne = [13.5, 18, 24, 31, 42, 56, 73, 90];
            kabel_data.modstand = [12.1, 7.41, 4.61, 3.08, 1.83, 1.15, 0.72, 0.524];
            
        otherwise
            % Minimum data
            kabel_data.tvaersnit = {'2.5', '4', '6'};
            kabel_data.belastningsevne = [20, 25, 32];
            kabel_data.modstand = [7.41, 4.61, 3.08];
    end
    
    % Tilføj standard felter
    n_kabler = length(kabel_data.tvaersnit);
    kabel_data.maksimal_temperatur = repmat(70, 1, n_kabler);
    kabel_data.producent = repmat({'Standard'}, 1, n_kabler);
end