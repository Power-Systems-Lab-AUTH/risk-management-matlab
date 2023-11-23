% Base directory where the CSV files are located
baseDir = 'HistoricalData/';

% List of base names for the CSV files
baseNames = [7321, 7323, 91815, 352070, 352071, 352074];

% Initialize a structure to hold all data
allData = struct();

% Loop through each base name
for i = 1:length(baseNames)
    % Construct file names with full path
    priceFileName = fullfile(baseDir, sprintf('%d_price.csv', baseNames(i)));
    datesFileName = fullfile(baseDir, sprintf('%d_dates.csv', baseNames(i)));

    % Read data from CSV files
    priceData = readtable(priceFileName); % Assuming the data is in table format
    datesData = readtable(datesFileName); % Adjust read function if format differs

    % Store data in the structure
    allData.(sprintf('num%d', baseNames(i))).price = priceData;
    allData.(sprintf('num%d', baseNames(i))).dates = datesData;
end

% Create a .mat file name
matFileName = fullfile(baseDir, 'allData.mat');

% Save the structure to a .mat file
save(matFileName, 'allData');
