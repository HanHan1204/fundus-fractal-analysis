
% SCRIPT_BOXPLOT_FRACTAL_DIMENSION_FOR_EACH_LABEL
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------

% configure the environment
config_boxplot_fractal_dimension_for_each_label

%% load labels and features

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');

% load features accordingly
switch extract_from
    case 'vessels' 
        % prepare input tag
        input_tag = 'from-vessels';
    case 'skeleton' 
        % prepare input tag
        input_tag = 'from-skeleton';    
end

% switch for fractal dimension
switch fractal_dimension
    case 'box'
        fractal_dim_tag = '$D_B$';
    case 'information'
        fractal_dim_tag = '$D_I$';
    case 'correlation'
        fractal_dim_tag = '$D_C$';
end

% load features
load(fullfile(input_folder, strcat(fractal_dimension, '-fractal-dimension-', input_tag, '.mat')));

% load labels
load(fullfile(dataset_path, dataset_name, 'labels', 'labels.mat'));

%% retrieve features per each label

% retrieve unique labels
unique_labels = unique(labels.dr);

% initialize the array of features per label
features_per_r = cell(length(unique_labels), 1);
% initialize an array of groups
grouping_var = zeros(length(labels.dr), 1);
% initialize an array of legends
legend_array = cell(size(unique_labels));

% for each of the labels
iterator = 1;
for i = 1 : length(unique_labels)
    
    % retrieve features with current label
    features_per_r{i} = features(labels.dr == unique_labels(i), :);
    % assign grouping variables
    grouping_var(iterator : iterator + length(features_per_r{i}) - 1) = i;
    % update iterator
    iterator = iterator + length(features_per_r{i});
    
    % assign grade
    legend_array{i} = ['R', num2str(i-1)];
    
end

%% plot boxplots

% transform cell array to classic array
features_per_r = cell2mat(features_per_r);

% plot the boxplot
figure('Position',[200 200 400 447]), boxplot(features_per_r, grouping_var, 'notch', 'on');
set(gca,'ygrid','on');
% assign labels
set(gca,'XTick',1:length(unique_labels),'XTickLabel',legend_array);
ah=copyobj(gca,gcf);
set(ah,'YAxisLocation','right');
ylabel(fractal_dim_tag, 'Interpreter','LaTex');
set(findall(gcf,'-property','FontSize'),'FontSize',14)

% initialize output folder
figure_output_folder = fullfile(output_path, 'box-plots');
mkdir(figure_output_folder);

% save it
%savefig(fullfile(figure_output_folder, strcat(fractal_dimension, '-fractal-dimension-', input_tag)));

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fullfile(figure_output_folder, strcat(fractal_dimension, '-fractal-dimension-', input_tag, '.pdf')), '-dpdf');