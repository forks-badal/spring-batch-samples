CREATE TABLE SDN_NAME(
  UID INTEGER PRIMARY KEY,
  NAME VARCHAR(255),
  SDN_TYPE VARCHAR(64),
  PROGRAM VARCHAR(64),
  TITLE VARCHAR(255),
  VESSEL_CALL_SIGN VARCHAR(64),
  VESSEL_TYPE VARCHAR(255),
  VESSEL_TONNAGE FLOAT,
  VESSEL_GROSS_REGISTERED_TONNAGE FLOAT,
  VESSEL_FLAG VARCHAR(64),
  VESSEL_OWNER VARCHAR(255),
  INFO VARCHAR(1024)
) AS SELECT * FROM CSVREAD(
  'src/main/resources/META-INF/database/sdn_names.csv',
  'UID,NAME,SDN_TYPE,PROGRAM,TITLE,VESSEL_CALL_SIGN,VESSEL_TYPE,VESSEL_TONNAGE,VESSEL_GROSS_REGISTERED_TONNAGE,VESSEL_FLAG,VESSEL_OWNER,INFO'
);


CREATE TABLE SDN_ADDRESS(
  ENTITY_UID INTEGER,
  ADDRESS_UID INTEGER PRIMARY KEY,
  ADDRESS VARCHAR(255),
  CITY VARCHAR(255),
  COUNTRY VARCHAR(64),
  EXT VARCHAR(255),
  FOREIGN KEY(ENTITY_UID) REFERENCES SDN_NAME(UID)
) AS SELECT * FROM CSVREAD(
  'src/main/resources/META-INF/database/sdn_addresses.csv',
  'ENTITY_UID,ADDRESS_UID,ADDRESS,CITY,COUNTRY,EXT'
);


CREATE TABLE SDN_ALTERNATE_NAME(
  ENTITY_UID INTEGER,
  ALTERNATE_NAME_UID INTEGER PRIMARY KEY,
  TYPE VARCHAR(64),
  NAME VARCHAR(255),
  FOREIGN KEY(ENTITY_UID) REFERENCES SDN_NAME(UID)
) AS SELECT * FROM CSVREAD(
  'src/main/resources/META-INF/database/sdn_alternate_names.csv',
  'ENTITY_UID,ALTERNATE_NAME_UID,TYPE,NAME'
);


CREATE VIEW SDN_ENTITY
AS
SELECT
  SDN_NAME.UID AS ID,
  SDN_NAME.NAME AS NAME,
  CONCAT_WS(' ', SDN_ADDRESS.ADDRESS, SDN_ADDRESS.CITY, SDN_ADDRESS.COUNTRY) AS ADDRESS,
  SDN_ALTERNATE_NAME.NAME AS ALTERNATE_NAME
FROM
  SDN_NAME JOIN SDN_ADDRESS ON SDN_NAME.UID = SDN_ADDRESS.ENTITY_UID
  JOIN SDN_ALTERNATE_NAME ON SDN_NAME.UID = SDN_ALTERNATE_NAME.ENTITY_UID;


CREATE TABLE ELIXIR0_TX (
  ID BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  STATUS varchar(16),
  ADDITIONAL_CASE_ID varchar(64),
  AMOUNT decimal(19,2),
  BENEFICIARY_ACCOUNT_NUMBER varchar(32),
  BENEFICIARY_ADDRESS varchar(255),
  BENEFICIARY_NAME varchar(255),
  BENEFICIARY_SORT_CODE varchar(16),
  CLIENT_BANK_INFORMATION varchar(255),
  IDENTIFIER_TYPE varchar(64),
  ORDERING_PARTY_ACCOUNT_NUMBER varchar(32),
  ORDERING_PARTY_ADDRESS varchar(255),
  ORDERING_PARTY_NAME varchar(255),
  ORDERING_PARTY_SORT_CODE varchar(16),
  PAYERS_IDENTIFICATION varchar(32),
  PAYERS_NIP varchar(16),
  PAYMENT_CODE integer,
  PAYMENT_DATE timestamp,
  PAYMENT_DETAILS varchar(255),
  PAYMENT_PERIOD timestamp,
  PAYMENT_TYPE varchar(16),
  PERIOD_FORM_NUMBER varchar(16),
  TRANSACTION_CODE varchar(255)
);


CREATE TABLE SANCTION_MATCH(
  ID BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  TRANSACTION_ID BIGINT,
  SDN_ENTITY_ID BIGINT,
  FOREIGN KEY(TRANSACTION_ID) REFERENCES ELIXIR0_TX(ID),
  FOREIGN KEY(SDN_ENTITY_ID) REFERENCES SDN_NAME(UID)
);