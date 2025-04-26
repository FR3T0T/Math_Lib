% This script will help fix function references in the ElektroMatBibTrinvis library
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

% Run this in your library root directory

function fix_function_references()
    % Find all .m files in the current directory and subdirectories
    files = findAllMatlabFiles('.');
    
    % Initialize counters for reporting
    total_files = length(files);
    files_changed = 0;
    total_changes = 0;
    
    % Process each file
    for i = 1:total_files
        file_path = files{i};
        [changes, new_content] = processFile(file_path);
        
        if changes > 0
            % Write the modified content back to the file
            writeFileContent(file_path, new_content);
            files_changed = files_changed + 1;
            total_changes = total_changes + changes;
            fprintf('Updated %s: %d changes\n', file_path, changes);
        end
    end
    
    % Report results
    fprintf('\nSummary:\n');
    fprintf('Total files scanned: %d\n', total_files);
    fprintf('Files modified: %d\n', files_changed);
    fprintf('Total function references fixed: %d\n', total_changes);
end

% Helper function to count the number of changes between two strings
function count = countMatches(original, new_content)
    if strcmp(original, new_content)
        count = 0;
    else
        % Simple approach: count the number of instances of ElektroMat.Forklaringssystem
        % that didn't exist in the original
        orig_count = length(strfind(original, 'ElektroMat.Forklaringssystem'));
        new_count = length(strfind(new_content, 'ElektroMat.Forklaringssystem'));
        count = new_count - orig_count;
    end
end

function files = findAllMatlabFiles(root_dir)
    % Recursively find all .m files
    files = {};
    items = dir(root_dir);
    
    for i = 1:length(items)
        item = items(i);
        
        % Skip '.' and '..' directories
        if strcmp(item.name, '.') || strcmp(item.name, '..')
            continue;
        end
        
        full_path = fullfile(root_dir, item.name);
        
        if item.isdir
            % Recursively search subdirectories
            sub_files = findAllMatlabFiles(full_path);
            files = [files, sub_files];
        elseif endsWith(item.name, '.m')
            % Add .m files to the list
            files{end+1} = full_path;
        end
    end
end

function [changes, new_content] = processFile(file_path)
    % Read the file content
    content = readFileContent(file_path);
    new_content = content;
    changes = 0;
    
    % Use separate approach for counting changes because some versions of MATLAB
    % don't support the second output from regexprep
    
    % Pattern 1: forklaringsOutput = startForklaring
    original = new_content;
    new_content = regexprep(new_content, ...
        '(forklaringsOutput\s*=\s*)startForklaring', ...
        '$1startForklaring');
    count1 = countMatches(original, new_content);
    
    % Pattern 2: forklaringsOutput = tilfoejTrin
    original = new_content;
    new_content = regexprep(new_content, ...
        '(forklaringsOutput\s*=\s*)tilfoejTrin', ...
        '$1tilfoejTrin');
    count2 = countMatches(original, new_content);
    
    % Pattern 3: forklaringsOutput = afslutForklaring
    original = new_content;
    new_content = regexprep(new_content, ...
        '(forklaringsOutput\s*=\s*)afslutForklaring', ...
        '$1afslutForklaring');
    count3 = countMatches(original, new_content);
    
    % Additional pattern: ElektroMatBibTrinvis.startForklaring
    original = new_content;
    new_content = regexprep(new_content, ...
        '(ElektroMatBibTrinvis\.)startForklaring', ...
        '$1startForklaring');
    count4 = countMatches(original, new_content);
    
    % Additional pattern: ElektroMatBibTrinvis.tilfoejTrin
    original = new_content;
    new_content = regexprep(new_content, ...
        '(ElektroMatBibTrinvis\.)tilfoejTrin', ...
        '$1tilfoejTrin');
    count5 = countMatches(original, new_content);
    
    % Additional pattern: ElektroMatBibTrinvis.afslutForklaring
    original = new_content;
    new_content = regexprep(new_content, ...
        '(ElektroMatBibTrinvis\.)afslutForklaring', ...
        '$1afslutForklaring');
    count6 = countMatches(original, new_content);
    
    % Count total changes
    changes = count1 + count2 + count3 + count4 + count5 + count6;
end

function content = readFileContent(file_path)
    % Read file content
    fid = fopen(file_path, 'r');
    if fid == -1
        error('Could not open file: %s', file_path);
    end
    
    content = fread(fid, '*char')';
    fclose(fid);
end

function writeFileContent(file_path, content)
    % Write content to file
    fid = fopen(file_path, 'w');
    if fid == -1
        error('Could not open file for writing: %s', file_path);
    end
    
    fprintf(fid, '%s', content);
    fclose(fid);
end