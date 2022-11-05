--tfidf data extraction after mapper and reducer
use spamandham;
create external table if not exists tfidf(reviewtext string) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
create table outtfidf as select word from (select explode (split(LCASE(REGEXP_REPLACE(reviewtext,'[\\p{Punct},\\p{Cntrl}]','')),' ')) as word from tfidf) wording;
select * from outtfidf limit 10;