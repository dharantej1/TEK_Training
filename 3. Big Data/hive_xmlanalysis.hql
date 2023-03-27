-- 1. change database
create database if not exists hivexmldb;
use hivexmldb;

-- 2. create XML table
create table if not exists ebayxmltable(seller_name STRING, seller_rating BIGINT, bidder_name STRING, location STRING,
					bid_history map<STRING, STRING>, item_info map<STRING, STRING>)
row format serde 'com.ibm.spss.hive.serde2.xml.XmlSerDe'
with serdeproperties(
	"column.xpath.seller_name"="/listing/seller_info/seller_name/text()",
	"column.xpath.seller_rating"="/listing/seller_info/seller_rating/text()",
	"column.xpath.bidder_name"="/listing/auction_info/high_bidder/bidder_name/text()",
	"column.xpath.location"="/listing/auction_info/location/text()",
	"column.xpath.bid_history"="/listing/bid_history/text()",
	"column.xpath.item_info"="/listing/item_info/*"
	)
stored as 
INPUTFORMAT 'com.ibm.spss.hive.serde2.xml.XmlInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat'
TBLPROPERTIES (
	"xmlinput.start"="<listing>",
	"xmloutput.end"="</listing>"
	);

-- here map is a data type provided by the HIVE

-- 3.
