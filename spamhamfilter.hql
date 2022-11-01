--Create a database
Create database spamandham;

use spamandham;

--A table to load dataset from external location
CREATE external TABLE IF not exists datasets(reviewerID string, reviewerName string, reviewText varchar(65535), overall bigint, 
summary varchar(65535), category string)            
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ("separatorChar" = ",", "quoteChar" = "\"") 
LOCATION '/home/jayamnithin27/CleanedData'
tblproperties("skip.header.line.count"="1");

SET hive.cli.print.header =true;

--Table for Bag of Words (to detect ham/spam)
CREATE external TABLE IF not exists bow (BOW string);

--Loading data to the table
Load data local inpath '/home/jayamnithin27/bow/bagtxt1.csv' overwrite into table bow;

-- Table to filter punctuation from the reviewtext cloumn by using Explode View
create table wordcount as select word from 
(select explode (split(LCASE(REGEXP_REPLACE(reviewtext,'[\\p{Punct},\\p{Cntrl}]','')),' ')) as word from datasets) words;

--Table for word counter compared with bag of words
create table counter as select word, COUNT(*) AS count FROM 
(SELECT * FROM wordcount LEFT OUTER JOIN bow on (wordcount.word = bow.bow) WHERE bow IS NULL) removestopwords 
GROUP BY word ORDER BY count DESC, word ASC;

--Displaying words with counter after comparing with bag of words
SELECT CONCAT_WS(',', CONCAT("\(",word), CONCAT(count,"\)")) FROM counter where length(word)>6 ORDER BY count DESC limit 10;

--Tables for SPAM & HAM
--Spam Table

create table spamfilter AS select reviewerid, reviewername, reviewtext, overall from datasets 
where (LOWER(reviewtext) LIKE '%problems%' OR LOWER(reviewtext) LIKE '%recommend%' OR LOWER(reviewtext) LIKE '%dont%') OR 
LOWER(reviewtext) LIKE  '%pleased%'  OR LOWER(reviewtext) LIKE '%makemoney%' AND 
overall in('3','5');


--Ham Table

create table hamfilter AS select reviewerid, reviewername, reviewtext, overall from datasets 
where reviewerid NOT IN (select reviewerid from spamfilter);

--Top 10 of ham id’s

select reviewerid, reviewername from hamfilter order by overall desc limit 10;

--Top 10 of spam id’s

select reviewerid, reviewername from spamfilter order by overall desc limit 10;

