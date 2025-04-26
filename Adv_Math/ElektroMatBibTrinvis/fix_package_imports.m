function fix_package_imports()
    % Find all .m files in the current directory and subdirectories
    files = findAllMatlabFiles('.');
    
    % Initialize counters for reporting
    total_files = length(files);
    files_changed = 0;
    total_changes = 0;
    
    % Process each file
    for i = 1:total_files
        file_path = files{i};
        
        % Skip the main class file and specific files that should use dot notation
        if contains(file_path, 'ElektroMatBibTrinvis.m')
            continue;
        end
        
        % Read file content
        content = readFileContent(file_path);
        
        % Check if file has any ElektroMat.Forklaringssystem references
        if contains(content, 'ElektroMat.Forklaringssystem')
            % Get the existing file header (first line or function declaration)
            lines = regexp(content, '\n', 'split');
            
            % Find the function line
            func_line_idx = 0;
            for j = 1:length(lines)
                if contains(lines{j}, 'function')
                    func_line_idx = j;
                    break;
                end
            end
            
            if func_line_idx > 0
                % Add import statement right after the function declaration
                import_statement = 'import ElektroMat.Forklaringssystem.*';
                
                % Don't add import if it already exists
                if ~contains(content, import_statement)
                    % Insert import after function line and before actual code
                    new_content = '';
                    for j = 1:func_line_idx
                        new_content = [new_content, lines{j}, newline];
                    end
                    
                    % Add a blank line after the function declaration for readability
                    new_content = [new_content, '    % Import forklaringssystem functions', newline, '    ', import_statement, newline, newline];
                    
                    for j = (func_line_idx+1):length(lines)
                        new_content = [new_content, lines{j}];
                        if j < length(lines)
                            new_content = [new_content, newline];
                        end
                    end
                    
                    % Replace dotted calls with direct calls
                    new_content = strrep(new_content, 'ElektroMat.Forklaringssystem.startForklaring', 'startForklaring');
                    new_content = strrep(new_content, 'ElektroMat.Forklaringssystem.tilfoejTrin', 'tilfoejTrin');
                    new_content = strrep(new_content, 'ElektroMat.Forklaringssystem.afslutForklaring', 'afslutForklaring');
                    
                    % Write changes
                    writeFileContent(file_path, new_content);
                    files_changed = files_changed + 1;
                    total_changes = total_changes + 1;
                    fprintf('Updated %s: Added import and replaced dotted calls\n', file_path);
                end
            end
        end
    end
    
    % Report results
    fprintf('\nSummary:\n');
    fprintf('Total files scanned: %d\n', total_files);
    fprintf('Files modified: %d\n', files_changed);
    
    % Provide instructions for any manual fixes
    fprintf('\nNext steps:\n');
    fprintf('1. Run your test script to verify the fixes\n');
    fprintf('2. If any errors remain, check the specific function files manually\n');
    fprintf('3. Ensure the main ElektroMatBibTrinvis.m file correctly delegates to the package functions\n');
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