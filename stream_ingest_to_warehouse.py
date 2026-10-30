import os
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from dotenv import load_dotenv
import pathlib

load_dotenv()

CONFIG_FILE = { 'user': os.getenv('SNOWFLAKE_USER') ,
                'password': os.getenv('SNOWFLAKE_PASSWORD'),
                'database': os.getenv('SNOWFLAKE_DATABASE'),
                'warehouse': os.getenv('SNOWFLAKE_WAREHOUSE'),
                'schema': os.getenv('SNOWFLAKE_SCHEMA'),
                'account': os.getenv('SNOWFLAKE_ACCOUNT')
                }

conn = snowflake.connector.connect(**CONFIG_FILE)
connect = conn.cursor()

def build_table():
    ddl_statement = """
                CREATE TABLE IF NOT EXISTS WATCH_EVENTS_FLAT(
                EVENT_ID VARCHAR(20) PRIMARY KEY,
                USER_ID VARCHAR(20) NOT NULL,
                USER_NAME VARCHAR(50),
                USER_COUNTRY VARCHAR(50),
                USER_SUBSCRIPTION_TIER VARCHAR(20),
                CONTENT_ID VARCHAR(30),
                CONTENT_TITLE VARCHAR(100),
                CONTENT_GENRE VARCHAR(30),
                CONTENT_RELEASE_DATE VARCHAR,
                CONTENT_DURATION_MINUTES INT,
                WATCH_DATE VARCHAR,
                DEVICE_TYPE VARCHAR,
                MINUTES_WATCHED INT,
                COMPLETED_FLAG INT,
                RATING_GIVEN FLOAT
                );
                """
    connect.execute(ddl_statement)

def load_data():
    data_path = pathlib.Path('raw_data/watch_events_flat.csv')
    df = pd.read_csv(data_path, encoding='cp1252')
    df.columns = [col.strip().upper().replace(" ", "_").replace("-", "_")
                for col in df.columns]

    success, nchunks, nrows, _ = write_pandas(
        conn = conn,
        table_name = 'WATCH_EVENTS_FLAT',
        auto_create_table = False,
        df = df
        )
    if success:
        print(f'{success} for {nrows}')
    else:
        print('Failed to load data.')

def main():
    build_table()
    load_data()

main()