# SOREstudy
Data and code for SOREstudy
Authors: Richard Pearson , Oliver O'Sullivan,Stefan Kluzek.
## Contact
For any questions, please contact Stefan (mailto:stefan.kluzek@ndorms.ox.ac.uk).

## Contributing
Contributions are welcome! Please open an issue or submit a pull request.
The SORE Study .do file contains code written for Stata 18 to manage, clean, analyze, and visualize data for a research project. Below is a breakdown of the variables and code structure used in the analysis:

## Key Variables
Study Variables:

#### studyid: Unique identifier for each sample (e.g., "17A2").
id: Extracted from the first two characters of studyid, representing the participant ID.
code: Represents the sampling location and time relative to exercise:
#### 1: Arm before exercise (A1)
#### 2: Arm after exercise (A2)
#### 3: Knee before exercise (K1)
Group: Represents participant grouping (e.g., "injury," "control," "OA").
Biomarker Variables:

#### IL1BngL: Interleukin-1β levels (ng/L).
#### IL6ngL: Interleukin-6 levels (ng/L).
#### CTXIIugL: C-terminal telopeptide of type II collagen (µg/L).
#### LeptugL: Leptin levels (µg/L).
#### COMPugL: Cartilage oligomeric matrix protein (µg/L).
#### PIIANPugL: N-terminal propeptide of type IIA collagen (µg/L).
Categorization Variables:

location: Derived variable to distinguish between sampling sites (e.g., "ARM," "KNEE").
exercise: Represents pre/post-exercise state:
1: Pre-exercise.
2: Post-exercise.
group: Identifies outliers based on biomarker thresholds.
#### Code Overview
Setup
global datapath and global outputpath define paths for data input and graph output.
import excel reads the raw data from an Excel file into Stata.
Data Cleaning
#### Missing or erroneous studyid values are corrected.
#### Biomarker values below thresholds are replaced with specific numbers (e.g., "<0.10" becomes "0.09").
#### Non-essential variables (e.g., dates, sample numbers) are dropped to streamline the dataset.
Labeling
Variables:
Each biomarker variable is labeled with descriptive names indicating sampling site and exercise state (e.g., IL1BngL1 = "IL1B Arm before Exercise").
Values:
Labels for code and Group provide meaningful descriptions for easier interpretation (e.g., 1 = "arm 1").
Data Reshaping
##### The data is reshaped to switch between "wide" and "long" formats for different analyses:
Wide Format: Used for pre/post comparisons within individual participants.
Long Format: Used for visualizations or group comparisons across all samples.
Visualization
##### Scatter Plots:
Created for biomarkers (e.g., IL1BngL, IL6ngL) with sampling location (ARM, KNEE) or exercise state (Pre, Post) on the x-axis.
##### high values / Outliers are categorized and displayed separately.
Combined Graphs:
Main and outlier graphs are combined for each biomarker to depict trends clearly.
