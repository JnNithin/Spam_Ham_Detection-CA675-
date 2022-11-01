--pig -x mapreduce datacleaning.pig

--To load data into pig
--Using piggybank.jar file to store data in 'CSVExcelStorage' (data with multiple delimiters) 
--REGISTER /usr/lib/pig/piggybank.jar (register piggybank jar)
loadData = Load '/user/jayamnithin27/pigscripttest/' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',');     

--Cleaning Dataset
--Step 1. Filtering the columns

generateData =FOREACH loadData GENERATE $2 AS reviewerID, $4 AS reviewerName, $6 AS reviewText, $7 AS overall, 
$8 AS summary, $11 AS category;

--Step 2. Filtering N/A values in the data

filterData = FILTER generateData  by NOT ((reviewerID=='NA') OR (reviewerName =='NA') OR (reviewText =='NA') OR 
(overall=='NA')   OR (summary =='NA') OR  (category=='NA') OR (reviewerID=='na') OR (reviewerName =='na') OR 
(reviewText =='na') OR (overall=='na')   OR (summary =='na') OR  (category=='na'));

--Step 3. Storing the filtered data into HDFS
STORE filterData INTO '/user/jayamnithin27/cleaneddata' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',');
