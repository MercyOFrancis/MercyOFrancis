# HR Data Cleaning and Analysis Project

## Overview
This project demonstrates my ability to clean, analyze, and visualize HR data to support workforce planning, resource optimization, and employee engagement. I processed a dataset of 239 employees using Microsoft Excel and Power Query, standardizing data, generating key metrics, and creating visualizations to provide actionable insights for HR decision-making. The project showcases my skills in data management, process optimization, and HR analytics, aligning with administrative and HR support roles.

## Objectives
- Clean and standardize an HR dataset to ensure accuracy and consistency.
- Analyze employee metrics to inform workforce planning and engagement strategies.
- Create visualizations to highlight trends in headcount, salaries, tenure, and performance.

## Dataset
The dataset contains 239 employee records with fields including:
- `first_name`, `last_name`, `staff_name` (concatenated full name)
- `department`, `job_role`, `basic_salary`, `date_of_birth`, `hire_date`
- `performance_score`

## Interactive Dashboard

<img width="956" height="550" alt="image" src="https://github.com/user-attachments/assets/d7a5c307-40fb-4a8e-8840-81888ea4ccab" />


## Methodology

### Data Cleaning
1. **Data Type Standardization**  
   - Converted columns to appropriate formats (Text, Numbers, Currency in Naira) for analysis.  
   - Set `basic_salary` to Currency format for accurate financial reporting.

2. **Column Removal and Validation**  
   - Removed `staff_name` after verifying it was redundant (validated using Excel formula: `=IF(TRIM(staff_name) = TRIM(last_name & "," & first_name), "OK", "MISMATCH")`).  
   - Deleted an unnamed column with irrelevant formula-based data (calculated length of `division`).

3. **Standardizing Entries**  
   - Used Power Query to standardize department names (e.g., "R & C" to "Risk and Compliance", "Designs" to "Design").  
   - Unified job roles (e.g., "Asst Production Scheduler" to "Asst. Production Scheduler").

4. **Calculated Columns**  
   - Added `Age` using `=DATEDIF(date_of_birth, TODAY(), "Y")`.  
   - Created `Age Range` using XLOOKUP referencing an Age Range sheet.  
   - Added `Length of Stay (LOS)` using `=DATEDIF(hire_date, TODAY(), "Y")`.  
   - Created `LOS Range` using XLOOKUP referencing an LOS Range sheet.

5. **Conditional Formatting**  
   - Highlighted employees with LOS > 20 years (green) and Age < 30 (blue) for retention and talent programs.  
   - Applied gradient bars for department headcounts and color gradients for average salaries.

### Analysis
- Used pivot tables and Excel formulas (e.g., COUNTA, MAX, MIN) to answer key HR questions:  
  - Total employees: 239  
  - Total salary: ₦117,234,156.62  
  - Highest/lowest salaries: ₦3,999,999.99 / ₦101,581.20  
  - Employees with performance score > 80: 66  
  - Average tenure: 12 years  
  - Department with longest average tenure: Communications  
- Created visualizations (gradient bars for headcounts, color gradients for salaries) to highlight trends.

## Tools Used
- **Microsoft Excel**: Data cleaning, calculations, pivot tables, and conditional formatting.
- **Power Query**: Standardizing department and role names.
- **GitHub**: Repository hosting and documentation.

## Results and Insights
- **Workforce Planning**: Identified department headcounts and tenure trends to guide staffing decisions.
- **Resource Optimization**: Highlighted salary distributions to support budgeting and equity reviews.
- **Employee Engagement**: Flagged 66 high-performing employees (score > 80) and younger staff (Age < 30) for targeted programs.
- **Visualizations**: Gradient-based visuals enabled quick identification of high/low headcounts and salaries.

## How to View the Project
1. Clone this repository:  
   ```bash
   git clone https://github.com/MercyOFrancis/MercyOFrancis.git
   ```
2. Open the Excel file (HR analysis job shadowing dataset.xlsx`) in the repository to explore the cleaned dataset, pivot tables, and visualizations.
3. Review the `README.md` for a detailed project overview.

## Future Improvements
- Integrate Power BI for interactive dashboards to enhance HR reporting.
- Automate data cleaning with Python scripts for scalability.
- Expand analysis to include employee turnover and diversity metrics.

## Contact
For questions or collaboration, reach me at:  
- **Email**: mercyfrancis18@gmail.com  
- 
- **GitHub**: [Mercy Francis](#)
