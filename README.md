Analytics for small data 
========================

## Purpose

Automated descriptive analysis and predictive modeling for data sets that can fit into a memory using R and shell scripts

## API

    run.sh <input file path> -n <name of project> -d <dependent variable> -t <time variable>

All -n, -d, -t options are optional. When not given, \<name of projects\> will be project_\<time\> where \<time\> is in the YYYYmmddHHMMSS format. Not relevant analyses will not be run if dependent and time variables are not given.

## Types of analyses to run

<table>
	<tr>
		<th rowspan="2">Independent variable type</th>
		<th rowspan="2">Default</th>
		<th colspan="2">Dependent variable type</th>
	</tr>
	<tr>
		<th>Categorical</th>
		<th>Numeric</th>
	</tr>
	<tr>
		<td>Categorical</td>
		<td>
			<ul>
				<li>Value frequencies</li>
			</ul>
		</td>
		<td>
			<ul>
				<li>Value frequencies by dependent variable value</li>
				<li>Value frequencies by independent variable value</li>
				<li>ChiSq test</li>
			</ul>
		</td>
		<td>
			<ul>
				<li>Histogram by independent variable value</li>
				<li>Box plot by independent variable value</li>
				<li>Regression</li>
			</ul>
		</td>
	</tr>
	<tr>
		<td>Numerical</td>
		<td>
			<ul>
				<li>Box plot</li>
				<li>Histogram</li>
			</ul>
		</td>
		<td>
			<ul>
				<li>Box plot</li>
				<li>Histogram</li>
				<li>Stack plot</li>
			</ul>
		</td>
		<td>
			<ul>
				<li>Scatter plot</li>
				<li>Regression</li>
			</ul>
		</td>
	</tr>
</table>

## Output

For each dependent variable, it will create the following structure.

    <project name>
        * stdout.txt
        * stderr.txt
        * variable_categorization_result.txt
        - descriptive
            - dep_<dependent variable type>_<dependent variable>
                # If numeric
                    * dep_<dependent variable type>_<dependent variable>_box_plot_<yaxis type i>_<time unit p>_<time period q>.png
                    * dep_<dependent variable type>_<dependent variable>_box_plot_<yaxis type i>_<time unit p>_<time period q>.txt
                    * dep_<dependent variable type>_<dependent variable>_histogram_<axis type i>_<time unit p>_<time period q>.png
                    * dep_<dependent variable type>_<dependent variable>_histogram_<axis type i>_<time unit p>_<time period q>.txt
                # If categorical
                    * dep_<dependent variable type>_<dependent variable>_freq_dist_<time unit p>_<time period q>.png
                    * dep_<dependent variable type>_<dependent variable>_freq_dist_<time unit p>_<time period q>.txt
            - ind_cat_<independent categorical variable i>
                * ind_cat_<independent variable i>_freq_dist_<time unit p>_<time period q>.png
                * ind_cat_<independent variable i>_freq_dist_<time unit p>_<time period q>.txt
                # If <dependent variable> is categorical                    
                    * ind_cat_<independent variable i>_freq_dist_<dependent variable>_<value j>_<time unit p>_<time period q>.png
                    * ind_cat_<independent variable i>_freq_dist_<dependent variable>_<value j>_<time unit p>_<time period q>.txt
                    * ind_cat_<independent variable i>_chisq_test_<dependent variable>_<value j>_<time unit p>_<time period q>.png
                    * ind_cat_<independent variable i>_chisq_test_<dependent variable>_<value j>_<time unit p>_<time period q>.txt
                # If <dependent variable> is integer or float
                    * ind_cat_<independent variable i>_histogram_<dependent variable>_<value j>_<time unit p>_<time period q>.png
                    * ind_cat_<independent variable i>_histogram_<dependent variable>_<value j>_<time unit p>_<time period q>.txt
                    * ind_cat_<independent variable i>_regression_<time unit p>_<time period q>.png
                    * ind_cat_<independent variable i>_regression_<time unit p>_<time period q>.txt
            - ind_num_<independent numerical variable i>
                * ind_num_<independent variable i>_box_plot_<yaxis type k>_<time unit p>_<time period q>.png
                * ind_num_<independent variable i>_box_plot_<yaxis type k>_<time unit p>_<time period q>.txt
                * ind_num_<independent variable i>_histogram_<axis type k>_<time unit p>_<time period q>.png
                * ind_num_<independent variable i>_histogram_<axis type k>_<time unit p>_<time period q>.txt
                # If <dependent variable> is categorical
                    * ind_num_<independent variable i>_box_plot_<dependent variable>_<yaxis type k>_<time unit p>_<time period q>.png
                    * ind_num_<independent variable i>_box_plot_<dependent variable>_<yaxis type k>_<time unit p>_<time period q>.txt
                    * ind_num_<independent variable i>_histogram_<dependent variable>_<value k>_<time unit p>_<time period q>.png
                    * ind_num_<independent variable i>_histogram_<dependent variable>_<value k>_<time unit p>_<time period q>.txt
                    * ind_num_<independent variable i>_stack_plot_<time unit p>_<time period q>.png
                    * ind_num_<independent variable i>_stack_plot_<time unit p>_<time period q>.txt
                # If <dependent variable> is integer or float
                    * ind_num_<independent variable i>_scatter_plot_<axis type k>_<time unit p>_<time period q>.png
                    * ind_num_<independent variable i>_regression_<order k>_<time unit p>_<time period q>.png
                    * ind_num_<independent variable i>_regression_<order k>_<time unit p>_<time period q>.txt
        - predictive
            # If <dependent variable> is categorical
                * <dependent variable>_roc_curve_<time unit p>_<time period q>.png
                * <dependent variable>_roc_curve_<time unit p>_<time period q>.txt
            # If <dependent variable> is numeric
                * <dependent variable>_ks_curve_<time unit p>_<time period q>.png
                * <dependent variable>_ks_curve_<time unit p>_<time period q>.txt
            - <algorithm i>
                * <dependent variable>_<algorithm i>_graphical_representation.png
                * <dependent variable>_<algorithm i>_textual_representation.txt
                # If <dependent variable> is categorical
                    * <dependent variable>_roc_curve_<algorithm i>_<time unit p>_<time period q>.png
                    * <dependent variable>_roc_curve_<algorithm i>_<time unit p>_<time period q>.txt
                # If <dependent variable> is numeric
                    * <dependent variable>_ks_curve_<algorithm i>_<time unit p>_<time period q>.png
                    * <dependent variable>_ks_curve_<algorithm i>_<time unit p>_<time period q>.txt

## Non-time variable category

* Numeric
* Categorical: less than or equal to 10 unique values
* Textual: more than 10 unique values

## Time variable category

It depends on the most granural unit that a time variable contains. It ignores minutes and seconds.

* Yearly
* Monthly
* Daily
* Hourly

## Yaxis type

* Linear
* Log

## Axis type

* Linear
* Log x axis
* Log y axis
* Log

## Time unit

* Yearly
* Monthly
* Weekly

## Constraints

* It does not distinguish between numeric and ordinary variables; all ordinary variables will be treated as integer variables.
* It does not analyze textual variables; in other words, it will skip any procedure when it encounters a textual variable.
