CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (cc_num VARCHAR(20), amount DOUBLE, num_trans_last_10m DOUBLE, 
                                                   avg_amt_last_10m DOUBLE, datetime timestamp);
-- CREATE OR REPLACE PUMP to insert into output
CREATE OR REPLACE PUMP "STREAM_PUMP" AS 
    INSERT INTO "DESTINATION_SQL_STREAM" 
        SELECT STREAM "cc_num",
                        "amount",
                        COUNT(*) OVER LAST_10_MINUTES,
                        AVG("amount") OVER LAST_10_MINUTES,
                        "ROWTIME"
        FROM SOURCE_SQL_STREAM_001 WINDOW LAST_10_MINUTES AS (PARTITION BY "cc_num" RANGE INTERVAL '10' MINUTE PRECEDING)
