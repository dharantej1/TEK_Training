-- 1. change db
create database if not exists hivexmldb;
use hivexmldb;

-- 2. create xml table
drop table if exists ebayxmltable;
create table if not exists ebayxmltable(seller_name STRING, seller_rating BIGINT, bidder_name STRING, location STRING, bid_history  						map<STRING, STRING>, item_info map<STRING, STRING>)
row format serde 'com.ibm.spss.hive.serde2.xml.XmlSerDe'
with serdeproperties(
	"column.xpath.seller_name"="/listing/seller_info/seller_name/text()",
	"column.xpath.seller_rating"= "/listing/seller_info/seller_rating/text()",
	"column.xpath.bidder_name"="/listing/auction_info/high_bidder/bidder_name/text()",
	"column.xpath.location"="/listing/auction_info/location/text()",
	"column.xpath.bid_history"="/listing/bid_history/*",
	"column.xpath.item_info"="/listing/item_info/*"
	)
STORED AS
INPUTFORMAT 'com.ibm.spss.hive.serde2.xml.XmlInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat'
TBLPROPERTIES (
	"xmlinput.start"="<listing>",
	"xmlinput.end"="</listing>"
	);
-- 3. insert data
load data local inpath '/home/hadoop/Downloads/ebay.xml'
overwrite into table ebayxmltable;

select * from ebayxmltable;

select count(*) from ebayxmltable;

select seller_name, bidder_name, location, bid_history["highest_bid_amount"], item_info["cpu"], item_info["memory"] from ebayxmltable;
