
RUN;PROC CONTENTS DATA=LAB.SALES; RUN;

title 'Null values in the dataset'; 
proc means data=LAB.SALES nmiss;
RUN;

PROC PRINT DATA=LAB.SALES (OBS=10);
RUN;

/* Step 1: Calculate missing price_per_unit where total_sales and units_sold are available */
data LAB.SALES;
    set LAB.SALES; 
    if missing(price_per_unit) and not missing(total_sales) and not missing(units_sold) then
        price_per_unit = total_sales / units_sold;
run;

/* Review the updated dataset */
proc print data=LAB.SALES(obs=10);
    var product total_sales units_sold price_per_unit;
run;

/* Step 1: Calculate missing units_sold where total_sales and price_per_unit are available */
data LAB.SALES;
    set LAB.SALES; 
    if missing(units_sold) and not missing(total_sales) and not missing(price_per_unit) then
        units_sold = total_sales / price_per_unit;
run;

/* Review the updated dataset */
proc print data=LAB.SALES(obs=10);
    var product total_sales units_sold price_per_unit;
run;

/* Step 1: Calculate missing total_sales where price_per_unit and units_sold are available */
data LAB.SALES;
    set LAB.SALES; 
    /* Calculate total_sales for missing values */
    if missing(total_sales) and not missing(price_per_unit) and not missing(units_sold) then
        total_sales = price_per_unit * units_sold;
run;


/* Review the updated dataset */
proc print data=LAB.SALES(obs=10);
    var product total_sales units_sold price_per_unit;
run;

/* Create a Histogram for Operating Profit */
ods graphics / width=4in height=3in; /* Set the size of the graph */
proc sgplot data=LAB.SALES;
    histogram operating_profit / binwidth=500 transparency=0.5 scale=count;
    density operating_profit / type=normal lineattrs=(pattern=solid color=red);
    xaxis label="Operating Profit";
    yaxis label="Frequency";
    title "Distribution of Operating Profit";
run;


/* Step 1: Calculate the Median of Operating Profit */
proc univariate data=LAB.SALES noprint;
    var operating_profit;
    output out=median_dataset p50=median_op; 
run;

/* Step 2: Fill Missing Values with the Median */

/* Impute Missing Numeric Values with Median */
proc stdize data=LAB.SALES out=LAB.SALES reponly method=median;
    var operating_profit;
run;
/* Step 3: Verify Changes  */
proc print data=LAB.SALES(obs=10);
    title "Sample of LAB.SALES Dataset After Filling Missing Values";
run;

title 'Null values in the dataset'; 
proc means data=LAB.SALES nmiss;
RUN;

proc contents data=LAB.SALES;
run;
/*----------------------------------------------------*/
/*ensure consistency for total sales*/
/* Step 1: Add a calculated column for total sales */
data CheckSales;
    set LAB.SALES;
    calculated_total_sales = price_per_unit * units_sold;
    difference = total_sales - calculated_total_sales; /* Check the discrepancy */
run;

/* Step 2: Filter rows with discrepancies */
proc sql;
    create table Discrepancies as
    select *
    from CheckSales
    where calculated_total_sales ne total_sales;
quit;

/* Step 3: Print Discrepancies */
proc print data=Discrepancies;
    title "Rows with Discrepancies in Total Sales";
run;
/*----------------------------------------------------*/
/* Step 1: Fix total_sales */
data LAB.SALES_FIXED;
    set LAB.SALES;
    /* Recalculate total_sales */
    total_sales = price_per_unit * units_sold;
run;

/* Step 2: Validate the Fix */
proc sql;
    select count(*) as Total_Discrepancies_After_Fix
    from LAB.SALES_FIXED
    where total_sales ne price_per_unit * units_sold;
quit;

/* Step 3: (Optional) Recalculate price_per_unit */
data LAB.SALES_FIXED;
    set LAB.SALES_FIXED;
    /* Recalculate price_per_unit if needed */
    if units_sold > 0 then price_per_unit = total_sales / units_sold;
    else price_per_unit = .; /* Avoid division by zero */
run;

/* Step 4: Print Updated Dataset */
proc print data=LAB.SALES_FIXED;
    title "Corrected Dataset with Updated Total Sales and Price Per Unit";
run;
/*----------------------------------------------------*/
/* Box Plot for Price Per Unit */
ods graphics / width=4in height=3in;

proc sgplot data=LAB.SALES;
    vbox price_per_unit;
    title "Box Plot for Price Per Unit";
run;

/* Reset graphics size to default */
ods graphics / reset=all;
/*----------------------------------------------------*/

/* Step 1: Perform Robust Statistical Analysis */
proc univariate data=LAB.SALES robustscale;
    var price_per_unit;
    title "Robust Statistical Summary for price_per_unit";
run;
/*----------------------------------------------------*/
/* Adjust the size of the output graph to make it smaller */
ods graphics / width=3in height=2in;

/* Box Plot for Units Sold */
proc sgplot data=LAB.SALES;
    vbox units_sold;
    title "Box Plot for Units Sold";
run;

/* Reset graphics size to default */
ods graphics / reset=all;
/*----------------------------------------------------*/

/* Step 1: Perform Robust Statistical Analysis */
proc univariate data=LAB.SALES robustscale;
    var units_sold;
    title "Robust Statistical Summary for units_sold";
run;
/*----------------------------------------------------*/


/* Adjust the size of the output graph to make it smaller */
ods graphics / width=3in height=2in;

/* Box Plot for Total Sales */
proc sgplot data=LAB.SALES;
    vbox total_sales;
    title "Box Plot for Total Sales";
run;

/*----------------------------------------------------*/


/* Step 1: Perform Robust Statistical Analysis */
proc univariate data=LAB.SALES robustscale;
    var total_sales;
    title "Robust Statistical Summary for total_sales";
run;


/*----------------------------------------------------*/
/* Reset graphics size to default */
ods graphics / reset=all;


/* Adjust the size of the output graph to make it smaller */
ods graphics / width=3in height=2in;

/* Box Plot for Operating Profit */
proc sgplot data=LAB.SALES;
    vbox operating_profit;
    title "Box Plot for Operating Profit";
run;

/* Reset graphics size to default */
ods graphics / reset=all;


/* Step 1: Perform Robust Statistical Analysis */
proc univariate data=LAB.SALES robustscale;
    var operating_profit;
    title "Robust Statistical Summary for Operating Profit";
run;
/*----------------------------------------------------*/
/* histogram*/
proc sgplot data=LAB.SALES;
   histogram price_per_unit / transparency=0.3;
   density price_per_unit;
   title "Distribution of Price per Unit";
run;

proc sgplot data=LAB.SALES;
   histogram units_sold / transparency=0.3;
   density units_sold;
   title "Distribution of Units Sold";
run;

proc sgplot data=LAB.SALES;
   histogram total_sales / transparency=0.3;
   density total_sales;
   title "Distribution of Total Sales";
run;

proc sgplot data=LAB.SALES;
   histogram operating_profit / transparency=0.3;
   density operating_profit;
   title "Distribution of Operating Profit";
run;


/*----------------------------------------------------*/

PROC SGPLOT DATA=LAB.SALES;
    VBAR region / RESPONSE=total_sales STAT=SUM CATEGORYORDER=RESPDESC;
    TITLE "Total Sales by Region (Descending Order)";
    XAXIS LABEL="region";
    YAXIS LABEL="total_sales";
RUN;
/*----------------------------------------------------*/
PROC SGPLOT DATA=LAB.SALES;
    VBAR product / RESPONSE=total_sales STAT=SUM CATEGORYORDER=RESPDESC;
    TITLE "Total Sales by Product (Descending Order)";
    XAXIS LABEL="product";
    YAXIS LABEL="total_sales";
RUN; 
/*----------------------------------------------------*/
PROC MEANS DATA=LAB.SALES NOPRINT;
    CLASS product;
    VAR units_sold;
    OUTPUT OUT=ProductSummary SUM=TotalUnitsSold MEAN=AverageUnitsSold;
RUN;

PROC PRINT DATA=ProductSummary;
    TITLE "Summary of Units Sold by Product";
RUN;




PROC GCHART DATA=LAB.SALES;
    PIE product / SUMVAR=units_sold
                 PERCENT=OUTSIDE
                 VALUE=OUTSIDE
                 SLICE=OUTSIDE;
    TITLE "Proportion of Units Sold by Product";
RUN;
QUIT;

/*----------------------------------------------------*/

PROC MEANS DATA=LAB.SALES NOPRINT;
    CLASS sales_method;
    VAR total_sales;
    OUTPUT OUT=SalesMethodSummary SUM=TotalSalesByMethod MEAN=AverageSalesByMethod;
RUN;

PROC PRINT DATA=SalesMethodSummary;
    TITLE "Summary of Total Sales by Sales Method";
RUN;



PROC GCHART DATA=LAB.SALES;
    PIE sales_method / SUMVAR=total_sales
                      PERCENT=OUTSIDE
                      VALUE=OUTSIDE
                      SLICE=OUTSIDE;
    TITLE "Proportion of Total Sales by Sales Method";
RUN;
QUIT;
/*----------------------------------------------------*/
PROC MEANS DATA=LAB.SALES NOPRINT;
    CLASS product sales_method;
    VAR total_sales;
    OUTPUT OUT=ProductSalesMethodSummary SUM=TotalSalesByCombination MEAN=AverageSalesByCombination;
RUN;

PROC PRINT DATA=ProductSalesMethodSummary;
    TITLE "Summary of Total Sales by Product and Sales Method";
RUN;


PROC SGPLOT DATA=LAB.SALES;
    VBAR product / RESPONSE=total_sales GROUP=sales_method STAT=SUM GROUPDISPLAY=STACK;
    TITLE "Total Sales by Product and Sales Method (Stacked)";
    XAXIS LABEL="Product";
    YAXIS LABEL="Total Sales";
RUN;


/*----------------------------------------------------*/
PROC SGPLOT DATA=LAB.SALES;
    SCATTER X=price_per_unit Y=total_sales / MARKERATTRS=(SIZE=12 COLOR=BLUE);
    TITLE "Relationship Between Price Per Unit and Total Sales";
    XAXIS LABEL="Price Per Unit";
    YAXIS LABEL="Total Sales";
RUN;



/*----------------------------------------------------*/


/* Correlation Analysis for Numerical Variables */
proc corr data=LAB.SALES;
    var price_per_unit units_sold total_sales operating_profit;
run;

--------------
/* Step 1: Calculate Correlations and Save as a Dataset */
proc corr data=LAB.SALES outp=corr_output noprint;
    var price_per_unit units_sold total_sales operating_profit;
run;

/* Step 2: Transform Correlation Matrix into Long Format */
data corr_long;
    set corr_output;
    array vars {*} price_per_unit units_sold total_sales operating_profit;
    do i = 1 to dim(vars);
        if _type_ = "CORR" and _name_ ne vname(vars[i]) then do;
            variable1 = _name_;
            variable2 = vname(vars[i]);
            corr_value = vars[i];
            output;
        end;
    end;
    keep variable1 variable2 corr_value;
run;

/* Step 3: Plot Heatmap Using Custom Colors */
proc sgplot data=corr_long;
    heatmapparm x=variable1 y=variable2 colorresponse=corr_value / colormodel=(darkblue white gold);
    gradlegend / title="Correlation";
    title "Heatmap of Correlations Between Numerical Variables";
run;


/*----------------------------------------------------*/

proc univariate data=LAB.SALES;
    var Units_Sold;
    histogram Units_Sold / normal kernel;
    inset mean std skewness kurtosis / position=ne;
run;

data LAB.SALES;  /* Modify the original dataset */
    set LAB.SALES;
    if Units_Sold > 0 then Log_Units_Sold = log(Units_Sold); /* Apply log only for positive values */
    else Log_Units_Sold = .; /* Handle non-positive values (if any) */
run;

/* Check the skewness again after transformation */
proc univariate data=LAB.SALES;
    var Log_Units_Sold;
    histogram Log_Units_Sold / normal kernel;
    inset mean std skewness kurtosis / position=ne;
run;

/* Display the updated dataset */
proc print data=LAB.SALES (obs=20); /* Show the first 20 rows */
    var Units_Sold Log_Units_Sold;
    title "Original and Log-Transformed Units_Sold";
run;

/*----------------------------------------------------*/
/* Step 1: Check skewness and distribution of Total_Sales */
proc univariate data=LAB.SALES;
    var Total_Sales;
    histogram Total_Sales / normal kernel;
    inset mean std skewness kurtosis / position=ne;
run;

/* Step 2: Apply log transformation directly to the original dataset */
data LAB.SALES;  /* Modify the original dataset */
    set LAB.SALES;
    if Total_Sales > 0 then Log_Total_Sales = log(Total_Sales); /* Apply log only for positive values */
    else Log_Total_Sales = .; /* Handle non-positive values (if any) */
run;

/* Step 3: Check skewness of the log-transformed Total_Sales column */
proc univariate data=LAB.SALES;
    var Log_Total_Sales;
    histogram Log_Total_Sales / normal kernel;
    inset mean std skewness kurtosis / position=ne;
run;

/* Step 4: Display the original and transformed columns */
proc print data=LAB.SALES (obs=20); /* Show the first 20 rows */
    var Total_Sales Log_Total_Sales;
    title "Original and Log-Transformed Total_Sales";
run;

/*----------------------------------------------------*/

/* Step 1: Check skewness and distribution of Operating_Profit */
proc univariate data=LAB.SALES;
    var Operating_Profit;
    histogram Operating_Profit / normal kernel;
    inset mean std skewness kurtosis / position=ne;
run;

/* Step 2: Apply log transformation directly to the original dataset */
data LAB.SALES;  /* Modify the original dataset */
    set LAB.SALES;
    if Operating_Profit > 0 then Log_Operating_Profit = log(Operating_Profit); /* Apply log only for positive values */
    else Log_Operating_Profit = .; /* Handle non-positive values (if any) */
run;

/* Step 3: Check skewness of the log-transformed Operating_Profit column */
proc univariate data=LAB.SALES;
    var Log_Operating_Profit;
    histogram Log_Operating_Profit / normal kernel;
    inset mean std skewness kurtosis / position=ne;
run;

/* Step 4: Display the original and log-transformed columns */
proc print data=LAB.SALES (obs=20); /* Show the first 20 rows */
    var Operating_Profit Log_Operating_Profit;
    title "Original and Log-Transformed Operating Profit";
run;


/*----------------------------------------------------*/

/* Step 1: One-hot encode the retailer column in the same dataset */
data LAB.SALES;
    set LAB.SALES;

    /* Initialize one-hot encoded columns */
    Foot_Locker = 0;
    West_Gear = 0;
    Walmart = 0;
    Sports_Direct = 0;
    Kohls = 0;
    Amazon = 0;

    /* Apply one-hot encoding */
    if retailer = 'Foot Locker' then Foot_Locker = 1;
    if retailer = 'West Gear' then West_Gear = 1;
    if retailer = 'Walmart' then Walmart = 1;
    if retailer = 'Sports Direct' then Sports_Direct = 1;
    if retailer = 'Kohl''s' then Kohls = 1;
    if retailer = 'Amazon' then Amazon = 1;

run;

/* Step 2: View the dataset with one-hot encoded columns */
proc print data=LAB.SALES (obs=10);
run;

/*----------------------------------------------------*/
/* Step 1: One-hot encode the region column in the same dataset */
data LAB.SALES;
    set LAB.SALES;

    /* Initialize one-hot encoded columns */
    Southeast = 0;
    Northeast = 0;
    West = 0;
    South = 0;
    Midwest = 0;

    /* Apply one-hot encoding */
    if region = 'Southeast' then Southeast = 1;
    if region = 'Northeast' then Northeast = 1;
    if region = 'West' then West = 1;
    if region = 'South' then South = 1;
    if region = 'Midwest' then Midwest = 1;

run;

/* Step 2: View the dataset with one-hot encoded columns */
proc print data=LAB.SALES (obs=10);
run;


/*----------------------------------------------------*/
/* Step 1: One-hot encode the product column in the same dataset */
data LAB.SALES;
    set LAB.SALES;

    /* Initialize one-hot encoded columns */
    Mens_Street_Footwear = 0;
    Mens_Athletic_Footwear = 0;
    Mens_Apparel = 0;
    Womens_Street_Footwear = 0;
    Womens_Athletic_Footwear = 0;
    Womens_Apparel = 0;

    /* Apply one-hot encoding */
    if product = "Men's Street Footwear" then Mens_Street_Footwear = 1;
    if product = "Men's Athletic Footwear" then Mens_Athletic_Footwear = 1;
    if product = "Men's Apparel" then Mens_Apparel = 1;
    if product = "Women's Street Footwear" then Womens_Street_Footwear = 1;
    if product = "Women's Athletic Footwear" then Womens_Athletic_Footwear = 1;
    if product = "Women's Apparel" then Womens_Apparel = 1;

run;


/* Step 2: View the dataset with one-hot encoded columns */
proc print data=LAB.SALES (obs=10);
run;

/*----------------------------------------------------*/
/* Step 1: One-hot encode the sales_method column in the same dataset */
data LAB.SALES;
    set LAB.SALES;

    /* Initialize one-hot encoded columns */
    Online = 0;
    In_Store = 0;
    Outlet = 0;

    /* Apply one-hot encoding */
    if sales_method = 'Online' then Online = 1;
    if sales_method = 'In-store' then In_Store = 1;
    if sales_method = 'Outlet' then Outlet = 1;

run;

/* Step 2: View the dataset to check one-hot encoding */
proc print data=LAB.SALES (obs=10);
run;
/*----------------------------------------------------*/
data LAB.SALES;
    set LAB.SALES;

    /* Create a new column for state binning */
    length Region $15;

    /* Northeast */
    if state in ('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 
                 'Vermont', 'New Jersey', 'New York', 'Pennsylvania') then Region = 'Northeast';

    /* Midwest */
    else if state in ('Illinois', 'Indiana', 'Iowa', 'Kansas', 'Michigan', 'Minnesota', 
                      'Missouri', 'Nebraska', 'North Dakota', 'Ohio', 'South Dakota', 'Wisconsin') then Region = 'Midwest';

    /* South */
    else if state in ('Delaware', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina',
                      'Virginia', 'West Virginia', 'Alabama', 'Kentucky', 'Mississippi', 'Tennessee', 
                      'Arkansas', 'Louisiana', 'Oklahoma', 'Texas') then Region = 'South';

    /* West */
    else if state in ('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 
                      'Wyoming', 'Alaska', 'California', 'Hawaii', 'Oregon', 'Washington') then Region = 'West';

    /* Other (Optional if needed) */
   
    else Region = 'Other';
run;

data LAB.SALES;
    set LAB.SALES;

    /* Combine Region and State */
    state_binning = cats(Region, '_', state);
run;


/*----------------------------------------------------*/
/* Step 1: Standardize price_per_unit using Z-Score Scaling within the same dataset */
proc standard data=LAB.SALES mean=0 std=1 out=TEMP_SALES;
    var price_per_unit; /* The column to standardize */
run;

/* Step 2: Overwrite LAB.SALES with standardized values */
data LAB.SALES;
    merge LAB.SALES TEMP_SALES(keep=price_per_unit rename=(price_per_unit=price_per_unit_standardized));
run;

/* Step 3: Display the standardized column */
proc print data=LAB.SALES (obs=20); /* Display first 20 rows */
    var price_per_unit price_per_unit_standardized;
    title "Standardized price_per_unit (Z-Score)";
run;

/* Step 4: Statistical analysis of standardized column */
proc univariate data=LAB.SALES;
    var price_per_unit_standardized;
    histogram price_per_unit_standardized / normal;
    inset mean std / position=ne;
run;



/*----------------------------------------------------*/

/* Step 1: Standardize Units_Sold using Z-Score Scaling */
proc standard data=LAB.SALES mean=0 std=1 out=TEMP_SALES;
    var Units_Sold; /* The column to standardize */
run;

/* Step 2: Overwrite LAB.SALES with standardized values */
data LAB.SALES;
    merge LAB.SALES TEMP_SALES(keep=Units_Sold rename=(Units_Sold=Units_Sold_Standardized));
run;

/* Step 3: Display the standardized column */
proc print data=LAB.SALES (obs=20); /* Display first 20 rows */
    var Units_Sold Units_Sold_Standardized;
    title "Standardized Units_Sold (Z-Score)";
run;

/* Step 4: Analyze the standardized Units_Sold column */
proc univariate data=LAB.SALES;
    var Units_Sold_Standardized;
    histogram Units_Sold_Standardized / normal;
    inset mean std / position=ne;
    title "Distribution of Standardized Units_Sold";
run;

/*----------------------------------------------------*/
/* Step 1: Standardize Total_Sales using Z-Score Scaling */
proc standard data=LAB.SALES mean=0 std=1 out=TEMP_SALES;
    var Total_Sales; /* The column to standardize */
run;

/* Step 2: Overwrite LAB.SALES with standardized values */
data LAB.SALES;
    merge LAB.SALES TEMP_SALES(keep=Total_Sales rename=(Total_Sales=Total_Sales_Standardized));
run;

/* Step 3: Display the standardized column */
proc print data=LAB.SALES (obs=20); /* Display first 20 rows */
    var Total_Sales Total_Sales_Standardized;
    title "Standardized Total_Sales (Z-Score)";
run;

/* Step 4: Analyze the standardized Total_Sales column */
proc univariate data=LAB.SALES;
    var Total_Sales_Standardized;
    histogram Total_Sales_Standardized / normal;
    inset mean std / position=ne;
    title "Distribution of Standardized Total_Sales";
run;


/*----------------------------------------------------*/
/* Step 1: Standardize Operating_Profit using Z-Score Scaling */
proc standard data=LAB.SALES mean=0 std=1 out=TEMP_SALES;
    var Operating_Profit; /* The column to standardize */
run;

/* Step 2: Overwrite LAB.SALES with standardized values */
data LAB.SALES;
    merge LAB.SALES TEMP_SALES(keep=Operating_Profit rename=(Operating_Profit=Operating_Profit_Standardized));
run;

/* Step 3: Display the standardized column */
proc print data=LAB.SALES (obs=20); /* Display first 20 rows */
    var Operating_Profit Operating_Profit_Standardized;
    title "Standardized Operating_Profit (Z-Score)";
run;

/* Step 4: Analyze the standardized Operating_Profit column */
proc univariate data=LAB.SALES;
    var Operating_Profit_Standardized;
    histogram Operating_Profit_Standardized / normal;
    inset mean std / position=ne;
    title "Distribution of Standardized Operating_Profit";
run;


/*----------------------------------------------------*/

proc anova data=LAB.SALES;
    class sales_method; /* Three groups: Online, Outlet, In-Store */
    model total_sales = sales_method; /* Compare total_sales across groups */
    title "ANOVA Test for Total Sales Across Sales Methods";
run;

/*----------------------------------------------------*/
/* Step 1: Filter data to include only West and South regions */
data LAB.SALES_CLEAN;
    set LAB.SALES;
    if region in ("West", "South");
run;

/* Step 2: Perform a t-test */
proc ttest data=LAB.SALES_CLEAN;
    class region; /* Two groups: West and South */
    var price_per_unit; /* Numeric variable to compare */
    title "Two-Sample t-Test for Price Per Unit (West vs. South)";
run;

/*----------------------------------------------------*/
PROC ANOVA DATA=LAB.SALES;
    CLASS sales_method; /* Categorical variable */
    MODEL price_per_unit = sales_method; /* Dependent variable */
    MEANS sales_method / TUKEY; /* Post-hoc test if needed */
    TITLE "One-Way ANOVA for Price Per Unit Across Sales Methods";
RUN;
QUIT;
/*----------------------------------------------------*/
DATA filtered_sales;
    SET LAB.SALES;
    /* Create a new product category column */
    IF product IN ("Men's Street Footwear", "Men's Apparel", "Men's Athletic Footwear") THEN product_category = "Men";
    ELSE IF product IN ("Women's Apparel", "Women's Street Footwear", "Women's Athletic Footwear") THEN product_category = "Women";
RUN;

PROC TTEST DATA=filtered_sales;
    CLASS product_category;
    VAR units_sold;
    TITLE "Independent t-Test for Units Sold Between Men's and Women's Product Categories";
RUN;
QUIT;


/*----------------------------------------------------*/
PROC ANOVA DATA=LAB.SALES;
    CLASS retailer; /* Categorical variable (Retailer) */
    MODEL total_sales = retailer; /* Dependent variable (Total Sales) */
    MEANS retailer / TUKEY; /* Post-hoc test to compare retailer groups */
    TITLE "One-Way ANOVA for Total Sales Between Retailers";
RUN;
QUIT;

