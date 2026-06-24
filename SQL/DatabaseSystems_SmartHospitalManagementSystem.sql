---|------------------------------------------------------------------------|---
---|---------------- DATABASE SYSTEMS SEMESTER LAB PROJECT -----------------|---
---|------------------------------------------------------------------------|---
---|------------------ Smart Hospital  Management System -------------------|---
---|------------------------------------------------------------------------|---

-- Group Members:

-- 24F-0008 – Eesha Saqib
-- 24F-0001 – Rameen Ahmad

DROP TABLE Lab_Test CASCADE CONSTRAINTS;
DROP TABLE Prescription CASCADE CONSTRAINTS;
DROP TABLE Medicine CASCADE CONSTRAINTS;
DROP TABLE Medical_Record CASCADE CONSTRAINTS;
DROP TABLE Handles_Billing CASCADE CONSTRAINTS;
DROP TABLE Handles_Appointment CASCADE CONSTRAINTS;
DROP TABLE Pays CASCADE CONSTRAINTS;
DROP TABLE Billing CASCADE CONSTRAINTS;
DROP TABLE Leads_To CASCADE CONSTRAINTS;
DROP TABLE Attends CASCADE CONSTRAINTS;
DROP TABLE Appointment CASCADE CONSTRAINTS;
DROP TABLE Treatment CASCADE CONSTRAINTS;
DROP TABLE Assists CASCADE CONSTRAINTS;
DROP TABLE Receives CASCADE CONSTRAINTS;
DROP TABLE Admitted_To CASCADE CONSTRAINTS;
DROP TABLE Assigned_To CASCADE CONSTRAINTS;
DROP TABLE Ward CASCADE CONSTRAINTS;
DROP TABLE Works_In CASCADE CONSTRAINTS;
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Receptionist CASCADE CONSTRAINTS;
DROP TABLE Nurse CASCADE CONSTRAINTS;
DROP TABLE Doctor CASCADE CONSTRAINTS;
DROP TABLE Patient CASCADE CONSTRAINTS;
DROP TABLE Person CASCADE CONSTRAINTS;

---|------------------------------------------------------------------------|---
---|________________________________ TABLES ________________________________|---
---|------------------------------------------------------------------------|---

CREATE TABLE Person (
personID NUMBER PRIMARY KEY,
name VARCHAR2(50) NOT NULL,
DOB DATE NOT NULL,
gender VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
contact VARCHAR2(15) UNIQUE,
address VARCHAR2(100)
);

CREATE TABLE Patient (
personID NUMBER PRIMARY KEY,
blood_group VARCHAR2(5) CHECK (blood_group IN
    ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
medical_history VARCHAR2(100),
patient_type VARCHAR2(20) DEFAULT 'Outpatient'
    CHECK (patient_type IN ('Outpatient', 'Inpatient')),

CONSTRAINT fk_patient_person
FOREIGN KEY (personID)
REFERENCES Person(personID)
ON DELETE CASCADE
);

CREATE TABLE Doctor (
personID NUMBER PRIMARY KEY,
specialisation VARCHAR2(50) NOT NULL,
salary NUMBER CHECK (salary > 0),

CONSTRAINT fk_doctor_person
FOREIGN KEY (personID)
REFERENCES Person(personID)
ON DELETE CASCADE
);

CREATE TABLE Nurse (
personID NUMBER PRIMARY KEY,
experience NUMBER DEFAULT 0 CHECK (experience >= 0),
shift VARCHAR2(20) CHECK (shift IN ('Morning', 'Evening', 'Night')),

CONSTRAINT fk_nurse_person
FOREIGN KEY(personID)
REFERENCES Person(personID)
ON DELETE CASCADE
);

CREATE TABLE Receptionist (
personID NUMBER PRIMARY KEY,
salary NUMBER CHECK (Salary > 0),
shift VARCHAR2(20) CHECK (shift IN ('Morning', 'Evening', 'Night')),

CONSTRAINT fk_receptionist_person
FOREIGN KEY (personID)
REFERENCES Person(personID)
ON DELETE CASCADE
);

CREATE TABLE Department (
deptID NUMBER PRIMARY KEY,
dept_name VARCHAR2(50) UNIQUE NOT NULL,
location VARCHAR2(100)
);

CREATE TABLE Works_In (
personID NUMBER,
deptID NUMBER,

CONSTRAINT pk_worksin
PRIMARY KEY (personID, deptID),

CONSTRAINT fk_worksin_person
FOREIGN KEY (personID)
REFERENCES Person(personID),

CONSTRAINT fk_worksin_dept
FOREIGN KEY (deptID)
REFERENCES Department(deptID)
);

CREATE TABLE Ward (
wardNo NUMBER PRIMARY KEY,
type VARCHAR2(20)
    CHECK (type IN ('General', 'ICU', 'Emergency', 'Private')),
capacity NUMBER CHECK (capacity > 0),
deptID NUMBER,

CONSTRAINT fk_ward_department
FOREIGN KEY (deptID)
REFERENCES Department(deptID)
);

CREATE TABLE Assigned_To (
nurseID NUMBER,
wardNo NUMBER,

CONSTRAINT pk_assigned
PRIMARY KEY (nurseID, wardNo),

CONSTRAINT fk_assigned_nurse
FOREIGN KEY (nurseID)
REFERENCES Nurse(personID),

CONSTRAINT fk_assigned_ward
FOREIGN KEY (wardNo)
REFERENCES Ward(wardNo)
);

CREATE TABLE Admitted_To (
patientID NUMBER,
wardNo NUMBER,
admit_date DATE DEFAULT SYSDATE,

CONSTRAINT pk_admitted
PRIMARY KEY (patientID, wardNo),

CONSTRAINT fk_admitted_patient
FOREIGN KEY (patientID)
REFERENCES Patient(personID),

CONSTRAINT fk_admitted_ward
FOREIGN KEY (wardNo)
REFERENCES Ward(wardNo)
);

CREATE TABLE Receives (
doctorID NUMBER,
patientID NUMBER,

CONSTRAINT pk_receives
PRIMARY KEY (doctorID, patientID),

CONSTRAINT fk_receives_doctor
FOREIGN KEY (doctorID)
REFERENCES Doctor(personID),

CONSTRAINT fk_receives_patient
FOREIGN KEY (patientID)
REFERENCES Patient(personID)
);

CREATE TABLE Assists (
nurseID NUMBER,
doctorID NUMBER,

CONSTRAINT pk_assists
PRIMARY KEY (nurseID, doctorID),

CONSTRAINT fk_assists_nurse
FOREIGN KEY (nurseID)
REFERENCES Nurse(personID),

CONSTRAINT fk_assists_doctor
FOREIGN KEY (doctorID)
REFERENCES Doctor(personID)
);

CREATE TABLE Treatment (
treatmentID NUMBER PRIMARY KEY,
diagnosis VARCHAR2(100),
treatment_details VARCHAR2(100),
treatment_date DATE DEFAULT SYSDATE,
doctorID NUMBER,

CONSTRAINT fk_treatment_doctor
FOREIGN KEY (doctorID)
REFERENCES Doctor(personID)
);

CREATE TABLE Appointment (
appointmentID NUMBER PRIMARY KEY,
appointment_date DATE NOT NULL,
appointment_time VARCHAR2(10),
status VARCHAR2(20) DEFAULT 'Scheduled'
    CHECK (status IN ('Scheduled','Completed','Cancelled')),
receptionistID NUMBER,

CONSTRAINT fk_appt_receptionist
FOREIGN KEY (receptionistID)
REFERENCES Receptionist(personID)
);

CREATE TABLE Attends (
patientID NUMBER,
appointmentID NUMBER,

CONSTRAINT pk_attends
PRIMARY KEY (patientID, appointmentID),

CONSTRAINT fk_attends_patient
FOREIGN KEY (patientID)
REFERENCES Patient(personID),

CONSTRAINT fk_attends_appointment
FOREIGN KEY (appointmentID)
REFERENCES Appointment(appointmentID)
);

CREATE TABLE Leads_To (
appointmentID NUMBER,
treatmentID NUMBER,

CONSTRAINT pk_leads
PRIMARY KEY (appointmentID, treatmentID),

CONSTRAINT fk_leads_appointment
FOREIGN KEY (appointmentID)
REFERENCES Appointment(appointmentID),

CONSTRAINT fk_leads_treatment
FOREIGN KEY (treatmentID)
REFERENCES Treatment(treatmentID)
);

CREATE TABLE Billing (
billID NUMBER PRIMARY KEY,
Amount NUMBER CHECK (Amount > 0),
payment_date DATE,
payment_status VARCHAR2(20) DEFAULT 'Pending'
    CHECK (payment_status IN ('Pending','Paid','Cancelled')),
treatmentID NUMBER,
receptionistID NUMBER,

CONSTRAINT fk_billing_treatment
FOREIGN KEY (treatmentID)
REFERENCES Treatment(treatmentID),

CONSTRAINT fk_bill_receptionist
FOREIGN KEY (receptionistID)
REFERENCES Receptionist(personID)
);

CREATE TABLE Pays (
patientID NUMBER,
billID NUMBER,

CONSTRAINT pk_pays
PRIMARY KEY (patientID, billID),

CONSTRAINT fk_pays_patient
FOREIGN KEY (patientID)
REFERENCES Patient(personID),

CONSTRAINT fk_pays_bill
FOREIGN KEY (billID)
REFERENCES Billing(billID)
);

CREATE TABLE Handles_Appointment (
receptionistID NUMBER,
appointmentID NUMBER,

CONSTRAINT pk_handles_appointment
PRIMARY KEY (receptionistID, appointmentID),

CONSTRAINT fk_handles_receptionist
FOREIGN KEY (receptionistID)
REFERENCES Receptionist(personID),

CONSTRAINT fk_handles_appointment
FOREIGN KEY (appointmentID)
REFERENCES Appointment(appointmentID)
);

CREATE TABLE Handles_Billing (
receptionistID NUMBER,
billID NUMBER,

CONSTRAINT pk_handles_billing
PRIMARY KEY (receptionistID, billID),

CONSTRAINT fk_handlesbill_receptionist
FOREIGN KEY (receptionistID)
REFERENCES Receptionist(personID),

CONSTRAINT fk_handlesbill_bill
FOREIGN KEY (billID)
REFERENCES Billing(billID)
);

CREATE TABLE Medical_Record (
recordID NUMBER PRIMARY KEY,
patientID NUMBER NOT NULL,
doctorID NUMBER,
treatmentID NUMBER,
record_date DATE DEFAULT SYSDATE,
description VARCHAR2(100),

CONSTRAINT fk_record_patient
FOREIGN KEY (patientID)
REFERENCES Patient(personID)
ON DELETE CASCADE,

CONSTRAINT fk_record_doctor
FOREIGN KEY (doctorID)
REFERENCES Doctor(personID),

CONSTRAINT fk_record_treatment
FOREIGN KEY (treatmentID)
REFERENCES Treatment(treatmentID)
);

CREATE TABLE Medicine (
medicineID NUMBER PRIMARY KEY,
medicine_name VARCHAR2(50) NOT NULL,
unit_price NUMBER CHECK (unit_price > 0),
stock_qty NUMBER DEFAULT 0 CHECK (stock_qty >= 0)
);

CREATE TABLE Prescription (
prescriptionID NUMBER PRIMARY KEY,
treatmentID NUMBER NOT NULL,
doctorID NUMBER NOT NULL,
medicineID NUMBER,
dosage VARCHAR2(20),
duration VARCHAR2(20),
date_issued DATE DEFAULT SYSDATE,

CONSTRAINT fk_prescription_treatment
FOREIGN KEY (treatmentID)
REFERENCES Treatment(treatmentID)
ON DELETE CASCADE,

CONSTRAINT fk_prescription_doctor
FOREIGN KEY (doctorID)
REFERENCES Doctor(personID),

CONSTRAINT fk_prescription_medicine
FOREIGN KEY (medicineID)
REFERENCES Medicine(medicineID)
);

CREATE TABLE Lab_Test (
testID NUMBER PRIMARY KEY,
treatmentID NUMBER,
test_name VARCHAR2(50) NOT NULL,
result VARCHAR2(100),
cost NUMBER CHECK (cost > 0),
test_date DATE DEFAULT SYSDATE,

CONSTRAINT fk_labtest_treatment
FOREIGN KEY (treatmentID)
REFERENCES Treatment(treatmentID)
ON DELETE CASCADE
);

---|------------------------------------------------------------------------|---
---|_______________________________ INSERTS ________________________________|---
---|------------------------------------------------------------------------|---

INSERT INTO Person VALUES (1,'Ali Khan',DATE '1980-05-10','Male','03001234561','Karachi');
INSERT INTO Person VALUES (2,'Sara Ahmed',DATE '1990-03-12','Female','03001234562','Lahore');
INSERT INTO Person VALUES (3,'Ahmed Raza',DATE '1985-09-21','Male','03001234563','Islamabad');
INSERT INTO Person VALUES (4,'Hina Malik',DATE '1992-01-14','Female','03001234564','Karachi');
INSERT INTO Person VALUES (5,'Usman Tariq',DATE '1978-07-19','Male','03001234565','Multan');
INSERT INTO Person VALUES (6,'Fatima Noor',DATE '1988-04-11','Female','03001234566','Lahore');
INSERT INTO Person VALUES (7,'Bilal Shah',DATE '1995-02-20','Male','03001234567','Peshawar');
INSERT INTO Person VALUES (8,'Zara Ali',DATE '1993-10-30','Female','03001234568','Quetta');
INSERT INTO Person VALUES (9,'Hamza Iqbal',DATE '1984-06-15','Male','03001234569','Karachi');
INSERT INTO Person VALUES (10,'Ayesha Khalid',DATE '1991-11-05','Female','03001234570','Lahore');
INSERT INTO Person VALUES (11,'Omar Hassan',DATE '1986-03-09','Male','03001234571','Karachi');
INSERT INTO Person VALUES (12,'Mariam Yousaf',DATE '1994-08-25','Female','03001234572','Islamabad');
INSERT INTO Person VALUES (13,'Saad Tariq',DATE '1983-12-01','Male','03001234573','Lahore');
INSERT INTO Person VALUES (14,'Noor Fatima',DATE '1996-02-13','Female','03001234574','Karachi');
INSERT INTO Person VALUES (15,'Talha Nadeem',DATE '1987-09-17','Male','03001234575','Multan');
INSERT INTO Person VALUES (16,'Laiba Khan',DATE '1998-06-28','Female','03001234576','Karachi');
INSERT INTO Person VALUES (17,'Hassan Rauf',DATE '1981-01-11','Male','03001234577','Lahore');
INSERT INTO Person VALUES (18,'Iqra Zahid',DATE '1997-03-19','Female','03001234578','Islamabad');
INSERT INTO Person VALUES (19,'Farhan Ali',DATE '1989-05-23','Male','03001234579','Peshawar');
INSERT INTO Person VALUES (20,'Rabia Javed',DATE '1993-07-02','Female','03001234580','Karachi');
INSERT INTO Person VALUES (21,'Imran Khan',DATE '1979-04-15','Male','03001234581','Lahore');
INSERT INTO Person VALUES (22,'Sadia Noor',DATE '1992-09-10','Female','03001234582','Islamabad');
INSERT INTO Person VALUES (23,'Danish Ali',DATE '1985-12-22','Male','03001234583','Karachi');
INSERT INTO Person VALUES (24,'Mehwish Khan',DATE '1990-06-05','Female','03001234584','Multan');
INSERT INTO Person VALUES (25,'Kamran Shah',DATE '1983-11-14','Male','03001234585','Peshawar');
INSERT INTO Person VALUES (26,'Sana Tariq',DATE '1995-01-29','Female','03001234586','Karachi');
INSERT INTO Person VALUES (27,'Noman Raza',DATE '1982-08-07','Male','03001234587','Lahore');
INSERT INTO Person VALUES (28,'Areeba Malik',DATE '1997-04-16','Female','03001234588','Islamabad');
INSERT INTO Person VALUES (29,'Shahid Iqbal',DATE '1986-10-03','Male','03001234589','Karachi');
INSERT INTO Person VALUES (30,'Anum Yousaf',DATE '1994-05-27','Female','03001234590','Lahore');

INSERT INTO Department VALUES (1,'Cardiology','Block A');
INSERT INTO Department VALUES (2,'Neurology','Block B');
INSERT INTO Department VALUES (3,'Orthopedics','Block C');
INSERT INTO Department VALUES (4,'Emergency','Ground Floor');
INSERT INTO Department VALUES (5,'Radiology','Block D');
INSERT INTO Department VALUES (6,'Pediatrics','Block E');
INSERT INTO Department VALUES (7,'Dermatology','Block F');
INSERT INTO Department VALUES (8,'Oncology','Block G');
INSERT INTO Department VALUES (9,'ENT','Block H');
INSERT INTO Department VALUES (10,'General Medicine','Block I');

INSERT INTO Patient VALUES (1,'A+','Diabetes','Outpatient');
INSERT INTO Patient VALUES (2,'B+','Hypertension','Inpatient');
INSERT INTO Patient VALUES (3,'O+','Asthma','Outpatient');
INSERT INTO Patient VALUES (4,'AB+','Heart Disease','Inpatient');
INSERT INTO Patient VALUES (5,'A-','None','Outpatient');
INSERT INTO Patient VALUES (6,'B-','Migraine','Outpatient');
INSERT INTO Patient VALUES (7,'O-','Allergy','Outpatient');
INSERT INTO Patient VALUES (8,'AB-','Skin Issues','Outpatient');
INSERT INTO Patient VALUES (9,'A+','Diabetes','Inpatient');
INSERT INTO Patient VALUES (10,'O+','Fracture','Inpatient');
INSERT INTO Patient VALUES (11,'B+','Hypertension','Outpatient');
INSERT INTO Patient VALUES (12,'A+','None','Outpatient');
INSERT INTO Patient VALUES (13,'O+','Asthma','Outpatient');
INSERT INTO Patient VALUES (14,'AB+','Heart Disease','Inpatient');
INSERT INTO Patient VALUES (15,'B-','Allergy','Outpatient');
INSERT INTO Patient VALUES (16,'O-','Migraine','Outpatient');
INSERT INTO Patient VALUES (17,'A+','Diabetes','Outpatient');
INSERT INTO Patient VALUES (18,'AB+','None','Outpatient');
INSERT INTO Patient VALUES (19,'O+','Asthma','Outpatient');
INSERT INTO Patient VALUES (20,'B+','Hypertension','Inpatient');

INSERT INTO Doctor VALUES (21,'Cardiologist',250000);
INSERT INTO Doctor VALUES (22,'Neurologist',240000);
INSERT INTO Doctor VALUES (23,'Orthopedic',230000);
INSERT INTO Doctor VALUES (24,'Emergency Specialist',220000);
INSERT INTO Doctor VALUES (25,'Radiologist',210000);
INSERT INTO Doctor VALUES (26,'Pediatrician',200000);
INSERT INTO Doctor VALUES (27,'Dermatologist',190000);
INSERT INTO Doctor VALUES (28,'Oncologist',260000);
INSERT INTO Doctor VALUES (29,'ENT Specialist',195000);
INSERT INTO Doctor VALUES (30,'General Physician',180000);

INSERT INTO Nurse VALUES (11,5,'Morning');
INSERT INTO Nurse VALUES (12,3,'Evening');
INSERT INTO Nurse VALUES (13,7,'Night');
INSERT INTO Nurse VALUES (14,2,'Morning');
INSERT INTO Nurse VALUES (15,4,'Evening');
INSERT INTO Nurse VALUES (16,6,'Night');
INSERT INTO Nurse VALUES (17,5,'Morning');
INSERT INTO Nurse VALUES (18,3,'Evening');
INSERT INTO Nurse VALUES (19,8,'Night');
INSERT INTO Nurse VALUES (20,4,'Morning');

INSERT INTO Receptionist VALUES (6,50000,'Morning');
INSERT INTO Receptionist VALUES (7,52000,'Evening');
INSERT INTO Receptionist VALUES (8,51000,'Night');
INSERT INTO Receptionist VALUES (9,53000,'Morning');
INSERT INTO Receptionist VALUES (10,54000,'Evening');

INSERT INTO Ward VALUES (101,'General',20,1);
INSERT INTO Ward VALUES (102,'ICU',10,4);
INSERT INTO Ward VALUES (103,'Emergency',15,4);
INSERT INTO Ward VALUES (104,'Private',8,2);
INSERT INTO Ward VALUES (105,'General',25,3);
INSERT INTO Ward VALUES (106,'ICU',12,1);
INSERT INTO Ward VALUES (107,'General',18,6);
INSERT INTO Ward VALUES (108,'Private',10,7);
INSERT INTO Ward VALUES (109,'Emergency',14,4);
INSERT INTO Ward VALUES (110,'General',22,10);

INSERT INTO Appointment VALUES (1,DATE '2025-05-01','10:00','Scheduled',6);
INSERT INTO Appointment VALUES (2,DATE '2025-05-02','11:00','Completed',7);
INSERT INTO Appointment VALUES (3,DATE '2025-05-03','12:00','Scheduled',8);
INSERT INTO Appointment VALUES (4,DATE '2025-05-04','09:30','Cancelled',9);
INSERT INTO Appointment VALUES (5,DATE '2025-05-05','14:00','Completed',10);
INSERT INTO Appointment VALUES (6,DATE '2025-05-06','10:30','Scheduled',6);
INSERT INTO Appointment VALUES (7,DATE '2025-05-07','13:00','Completed',7);
INSERT INTO Appointment VALUES (8,DATE '2025-05-08','15:00','Scheduled',8);
INSERT INTO Appointment VALUES (9,DATE '2025-05-09','09:00','Completed',9);
INSERT INTO Appointment VALUES (10,DATE '2025-05-10','16:00','Scheduled',10);
INSERT INTO Appointment VALUES (11,DATE '2025-05-11','10:00','Completed',6);
INSERT INTO Appointment VALUES (12,DATE '2025-05-12','11:00','Scheduled',7);
INSERT INTO Appointment VALUES (13,DATE '2025-05-13','12:00','Completed',8);
INSERT INTO Appointment VALUES (14,DATE '2025-05-14','13:30','Scheduled',9);
INSERT INTO Appointment VALUES (15,DATE '2025-05-15','15:30','Completed',10);
INSERT INTO Appointment VALUES (16,DATE '2025-05-16','10:45','Scheduled',6);
INSERT INTO Appointment VALUES (17,DATE '2025-05-17','11:15','Completed',7);
INSERT INTO Appointment VALUES (18,DATE '2025-05-18','12:30','Scheduled',8);
INSERT INTO Appointment VALUES (19,DATE '2025-05-19','14:45','Completed',9);
INSERT INTO Appointment VALUES (20,DATE '2025-05-20','16:30','Scheduled',10);

INSERT INTO Works_In VALUES (21,1);
INSERT INTO Works_In VALUES (22,2);
INSERT INTO Works_In VALUES (23,3);
INSERT INTO Works_In VALUES (24,4);
INSERT INTO Works_In VALUES (25,5);
INSERT INTO Works_In VALUES (26,6);
INSERT INTO Works_In VALUES (27,7);
INSERT INTO Works_In VALUES (28,8);
INSERT INTO Works_In VALUES (29,9);
INSERT INTO Works_In VALUES (30,10);
INSERT INTO Works_In VALUES (11,1);
INSERT INTO Works_In VALUES (12,2);
INSERT INTO Works_In VALUES (13,3);
INSERT INTO Works_In VALUES (14,4);
INSERT INTO Works_In VALUES (15,5);
INSERT INTO Works_In VALUES (16,6);
INSERT INTO Works_In VALUES (17,7);
INSERT INTO Works_In VALUES (18,8);
INSERT INTO Works_In VALUES (19,9);
INSERT INTO Works_In VALUES (20,10);

INSERT INTO Assigned_To VALUES (11,101);
INSERT INTO Assigned_To VALUES (12,102);
INSERT INTO Assigned_To VALUES (13,103);
INSERT INTO Assigned_To VALUES (14,104);
INSERT INTO Assigned_To VALUES (15,105);
INSERT INTO Assigned_To VALUES (16,106);
INSERT INTO Assigned_To VALUES (17,107);
INSERT INTO Assigned_To VALUES (18,108);
INSERT INTO Assigned_To VALUES (19,109);
INSERT INTO Assigned_To VALUES (20,110);
INSERT INTO Assigned_To VALUES (11,102);
INSERT INTO Assigned_To VALUES (12,103);
INSERT INTO Assigned_To VALUES (13,104);
INSERT INTO Assigned_To VALUES (14,105);
INSERT INTO Assigned_To VALUES (15,106);

INSERT INTO Admitted_To VALUES (2,101,DATE '2025-05-01');
INSERT INTO Admitted_To VALUES (4,102,DATE '2025-05-02');
INSERT INTO Admitted_To VALUES (9,103,DATE '2025-05-03');
INSERT INTO Admitted_To VALUES (10,104,DATE '2025-05-04');
INSERT INTO Admitted_To VALUES (14,105,DATE '2025-05-05');
INSERT INTO Admitted_To VALUES (20,106,DATE '2025-05-06');
INSERT INTO Admitted_To VALUES (2,107,DATE '2025-05-07');
INSERT INTO Admitted_To VALUES (4,108,DATE '2025-05-08');
INSERT INTO Admitted_To VALUES (9,109,DATE '2025-05-09');
INSERT INTO Admitted_To VALUES (10,110,DATE '2025-05-10');
INSERT INTO Admitted_To VALUES (14,101,DATE '2025-05-11');
INSERT INTO Admitted_To VALUES (20,102,DATE '2025-05-12');
INSERT INTO Admitted_To VALUES (9,105,DATE '2025-05-13');
INSERT INTO Admitted_To VALUES (10,106,DATE '2025-05-14');
INSERT INTO Admitted_To VALUES (2,104,DATE '2025-05-15');

INSERT INTO Receives VALUES (21,1);
INSERT INTO Receives VALUES (21,2);
INSERT INTO Receives VALUES (22,3);
INSERT INTO Receives VALUES (22,4);
INSERT INTO Receives VALUES (23,5);
INSERT INTO Receives VALUES (23,6);
INSERT INTO Receives VALUES (24,7);
INSERT INTO Receives VALUES (24,8);
INSERT INTO Receives VALUES (25,9);
INSERT INTO Receives VALUES (25,10);
INSERT INTO Receives VALUES (26,11);
INSERT INTO Receives VALUES (26,12);
INSERT INTO Receives VALUES (27,13);
INSERT INTO Receives VALUES (27,14);
INSERT INTO Receives VALUES (28,15);
INSERT INTO Receives VALUES (28,16);
INSERT INTO Receives VALUES (29,17);
INSERT INTO Receives VALUES (29,18);
INSERT INTO Receives VALUES (30,19);
INSERT INTO Receives VALUES (30,20);

INSERT INTO Assists VALUES (11,21);
INSERT INTO Assists VALUES (12,22);
INSERT INTO Assists VALUES (13,23);
INSERT INTO Assists VALUES (14,24);
INSERT INTO Assists VALUES (15,25);
INSERT INTO Assists VALUES (16,26);
INSERT INTO Assists VALUES (17,27);
INSERT INTO Assists VALUES (18,28);
INSERT INTO Assists VALUES (19,29);
INSERT INTO Assists VALUES (20,30);
INSERT INTO Assists VALUES (11,22);
INSERT INTO Assists VALUES (12,23);
INSERT INTO Assists VALUES (13,24);
INSERT INTO Assists VALUES (14,25);
INSERT INTO Assists VALUES (15,26);

INSERT INTO Treatment VALUES (1,'Heart Check','Medication',DATE '2025-05-01',21);
INSERT INTO Treatment VALUES (2,'Migraine','Painkillers',DATE '2025-05-02',22);
INSERT INTO Treatment VALUES (3,'Fracture','Plaster',DATE '2025-05-03',23);
INSERT INTO Treatment VALUES (4,'Burn Injury','Emergency Care',DATE '2025-05-04',24);
INSERT INTO Treatment VALUES (5,'X-Ray','Radiology Test',DATE '2025-05-05',25);
INSERT INTO Treatment VALUES (6,'Child Fever','Antibiotics',DATE '2025-05-06',26);
INSERT INTO Treatment VALUES (7,'Skin Rash','Cream',DATE '2025-05-07',27);
INSERT INTO Treatment VALUES (8,'Cancer Screening','Chemotherapy',DATE '2025-05-08',28);
INSERT INTO Treatment VALUES (9,'Ear Infection','Medication',DATE '2025-05-09',29);
INSERT INTO Treatment VALUES (10,'General Check','Observation',DATE '2025-05-10',30);
INSERT INTO Treatment VALUES (11,'Heart Disease','Surgery',DATE '2025-05-11',21);
INSERT INTO Treatment VALUES (12,'Stroke','Neurology Care',DATE '2025-05-12',22);
INSERT INTO Treatment VALUES (13,'Bone Fracture','Surgery',DATE '2025-05-13',23);
INSERT INTO Treatment VALUES (14,'Trauma','Emergency Surgery',DATE '2025-05-14',24);
INSERT INTO Treatment VALUES (15,'CT Scan','Imaging',DATE '2025-05-15',25);
INSERT INTO Treatment VALUES (16,'Child Infection','Medication',DATE '2025-05-16',26);
INSERT INTO Treatment VALUES (17,'Acne','Skin Treatment',DATE '2025-05-17',27);
INSERT INTO Treatment VALUES (18,'Tumor','Chemotherapy',DATE '2025-05-18',28);
INSERT INTO Treatment VALUES (19,'Sinus','Medication',DATE '2025-05-19',29);
INSERT INTO Treatment VALUES (20,'Checkup','Routine',DATE '2025-05-20',30);

INSERT INTO Attends VALUES (1,1);
INSERT INTO Attends VALUES (2,2);
INSERT INTO Attends VALUES (3,3);
INSERT INTO Attends VALUES (4,4);
INSERT INTO Attends VALUES (5,5);
INSERT INTO Attends VALUES (6,6);
INSERT INTO Attends VALUES (7,7);
INSERT INTO Attends VALUES (8,8);
INSERT INTO Attends VALUES (9,9);
INSERT INTO Attends VALUES (10,10);
INSERT INTO Attends VALUES (11,11);
INSERT INTO Attends VALUES (12,12);
INSERT INTO Attends VALUES (13,13);
INSERT INTO Attends VALUES (14,14);
INSERT INTO Attends VALUES (15,15);
INSERT INTO Attends VALUES (16,16);
INSERT INTO Attends VALUES (17,17);
INSERT INTO Attends VALUES (18,18);
INSERT INTO Attends VALUES (19,19);
INSERT INTO Attends VALUES (20,20);

INSERT INTO Leads_To VALUES (1,1);
INSERT INTO Leads_To VALUES (2,2);
INSERT INTO Leads_To VALUES (3,3);
INSERT INTO Leads_To VALUES (4,4);
INSERT INTO Leads_To VALUES (5,5);
INSERT INTO Leads_To VALUES (6,6);
INSERT INTO Leads_To VALUES (7,7);
INSERT INTO Leads_To VALUES (8,8);
INSERT INTO Leads_To VALUES (9,9);
INSERT INTO Leads_To VALUES (10,10);
INSERT INTO Leads_To VALUES (11,11);
INSERT INTO Leads_To VALUES (12,12);
INSERT INTO Leads_To VALUES (13,13);
INSERT INTO Leads_To VALUES (14,14);
INSERT INTO Leads_To VALUES (15,15);
INSERT INTO Leads_To VALUES (16,16);
INSERT INTO Leads_To VALUES (17,17);
INSERT INTO Leads_To VALUES (18,18);
INSERT INTO Leads_To VALUES (19,19);
INSERT INTO Leads_To VALUES (20,20);

INSERT INTO Billing VALUES (1,5000,DATE '2025-05-01','Paid',1,6);
INSERT INTO Billing VALUES (2,3000,DATE '2025-05-02','Paid',2,7);
INSERT INTO Billing VALUES (3,4500,DATE '2025-05-03','Pending',3,8);
INSERT INTO Billing VALUES (4,6000,DATE '2025-05-04','Paid',4,9);
INSERT INTO Billing VALUES (5,2500,DATE '2025-05-05','Paid',5,10);
INSERT INTO Billing VALUES (6,2000,DATE '2025-05-06','Pending',6,6);
INSERT INTO Billing VALUES (7,3500,DATE '2025-05-07','Paid',7,7);
INSERT INTO Billing VALUES (8,8000,DATE '2025-05-08','Pending',8,8);
INSERT INTO Billing VALUES (9,2200,DATE '2025-05-09','Paid',9,9);
INSERT INTO Billing VALUES (10,1500,DATE '2025-05-10','Paid',10,10);
INSERT INTO Billing VALUES (11,12000,DATE '2025-05-11','Pending',11,6);
INSERT INTO Billing VALUES (12,7000,DATE '2025-05-12','Paid',12,7);
INSERT INTO Billing VALUES (13,9000,DATE '2025-05-13','Pending',13,8);
INSERT INTO Billing VALUES (14,15000,DATE '2025-05-14','Paid',14,9);
INSERT INTO Billing VALUES (15,4000,DATE '2025-05-15','Paid',15,10);
INSERT INTO Billing VALUES (16,2800,DATE '2025-05-16','Pending',16,6);
INSERT INTO Billing VALUES (17,3100,DATE '2025-05-17','Paid',17,7);
INSERT INTO Billing VALUES (18,20000,DATE '2025-05-18','Pending',18,8);
INSERT INTO Billing VALUES (19,2600,DATE '2025-05-19','Paid',19,9);
INSERT INTO Billing VALUES (20,1800,DATE '2025-05-20','Paid',20,10);

INSERT INTO Pays VALUES (1,1);
INSERT INTO Pays VALUES (2,2);
INSERT INTO Pays VALUES (3,3);
INSERT INTO Pays VALUES (4,4);
INSERT INTO Pays VALUES (5,5);
INSERT INTO Pays VALUES (6,6);
INSERT INTO Pays VALUES (7,7);
INSERT INTO Pays VALUES (8,8);
INSERT INTO Pays VALUES (9,9);
INSERT INTO Pays VALUES (10,10);
INSERT INTO Pays VALUES (11,11);
INSERT INTO Pays VALUES (12,12);
INSERT INTO Pays VALUES (13,13);
INSERT INTO Pays VALUES (14,14);
INSERT INTO Pays VALUES (15,15);
INSERT INTO Pays VALUES (16,16);
INSERT INTO Pays VALUES (17,17);
INSERT INTO Pays VALUES (18,18);
INSERT INTO Pays VALUES (19,19);
INSERT INTO Pays VALUES (20,20);

INSERT INTO Handles_Appointment VALUES (6,1);
INSERT INTO Handles_Appointment VALUES (7,2);
INSERT INTO Handles_Appointment VALUES (8,3);
INSERT INTO Handles_Appointment VALUES (9,4);
INSERT INTO Handles_Appointment VALUES (10,5);
INSERT INTO Handles_Appointment VALUES (6,6);
INSERT INTO Handles_Appointment VALUES (7,7);
INSERT INTO Handles_Appointment VALUES (8,8);
INSERT INTO Handles_Appointment VALUES (9,9);
INSERT INTO Handles_Appointment VALUES (10,10);
INSERT INTO Handles_Appointment VALUES (6,11);
INSERT INTO Handles_Appointment VALUES (7,12);
INSERT INTO Handles_Appointment VALUES (8,13);
INSERT INTO Handles_Appointment VALUES (9,14);
INSERT INTO Handles_Appointment VALUES (10,15);
INSERT INTO Handles_Appointment VALUES (6,16);
INSERT INTO Handles_Appointment VALUES (7,17);
INSERT INTO Handles_Appointment VALUES (8,18);
INSERT INTO Handles_Appointment VALUES (9,19);
INSERT INTO Handles_Appointment VALUES (10,20);

INSERT INTO Handles_Billing VALUES (6,1);
INSERT INTO Handles_Billing VALUES (7,2);
INSERT INTO Handles_Billing VALUES (8,3);
INSERT INTO Handles_Billing VALUES (9,4);
INSERT INTO Handles_Billing VALUES (10,5);
INSERT INTO Handles_Billing VALUES (6,6);
INSERT INTO Handles_Billing VALUES (7,7);
INSERT INTO Handles_Billing VALUES (8,8);
INSERT INTO Handles_Billing VALUES (9,9);
INSERT INTO Handles_Billing VALUES (10,10);
INSERT INTO Handles_Billing VALUES (6,11);
INSERT INTO Handles_Billing VALUES (7,12);
INSERT INTO Handles_Billing VALUES (8,13);
INSERT INTO Handles_Billing VALUES (9,14);
INSERT INTO Handles_Billing VALUES (10,15);
INSERT INTO Handles_Billing VALUES (6,16);
INSERT INTO Handles_Billing VALUES (7,17);
INSERT INTO Handles_Billing VALUES (8,18);
INSERT INTO Handles_Billing VALUES (9,19);
INSERT INTO Handles_Billing VALUES (10,20);

INSERT INTO Medical_Record VALUES (1,1,21,1,DATE '2025-05-01','Routine heart check');
INSERT INTO Medical_Record VALUES (2,2,21,2,DATE '2025-05-02','High BP case');
INSERT INTO Medical_Record VALUES (3,3,22,3,DATE '2025-05-03','Migraine symptoms');
INSERT INTO Medical_Record VALUES (4,4,22,4,DATE '2025-05-04','Stroke observation');
INSERT INTO Medical_Record VALUES (5,5,23,5,DATE '2025-05-05','Minor fracture');
INSERT INTO Medical_Record VALUES (6,6,23,6,DATE '2025-05-06','Bone pain');
INSERT INTO Medical_Record VALUES (7,7,24,7,DATE '2025-05-07','Burn injury');
INSERT INTO Medical_Record VALUES (8,8,24,8,DATE '2025-05-08','Emergency trauma');
INSERT INTO Medical_Record VALUES (9,9,25,9,DATE '2025-05-09','X-ray diagnosis');
INSERT INTO Medical_Record VALUES (10,10,25,10,DATE '2025-05-10','Radiology case');

INSERT INTO Medicine VALUES (1,'Paracetamol',50,100);
INSERT INTO Medicine VALUES (2,'Ibuprofen',80,120);
INSERT INTO Medicine VALUES (3,'Amoxicillin',150,90);
INSERT INTO Medicine VALUES (4,'Aspirin',60,110);
INSERT INTO Medicine VALUES (5,'Cough Syrup',200,70);
INSERT INTO Medicine VALUES (6,'Insulin',500,40);
INSERT INTO Medicine VALUES (7,'Antihistamine',120,85);
INSERT INTO Medicine VALUES (8,'Antibiotic Cream',180,60);
INSERT INTO Medicine VALUES (9,'Vitamin D',100,130);
INSERT INTO Medicine VALUES (10,'Pain Relief Gel',140,75);

INSERT INTO Prescription VALUES (1,1,21,1,'2 times/day','5 days',DATE '2025-05-01');
INSERT INTO Prescription VALUES (2,2,22,2,'1 time/day','3 days',DATE '2025-05-02');
INSERT INTO Prescription VALUES (3,3,23,10,'Apply twice','7 days',DATE '2025-05-03');
INSERT INTO Prescription VALUES (4,4,24,4,'1 time/day','5 days',DATE '2025-05-04');
INSERT INTO Prescription VALUES (5,5,25,3,'2 times/day','7 days',DATE '2025-05-05');
INSERT INTO Prescription VALUES (6,6,26,1,'3 times/day','5 days',DATE '2025-05-06');
INSERT INTO Prescription VALUES (7,7,27,8,'Apply daily','10 days',DATE '2025-05-07');
INSERT INTO Prescription VALUES (8,8,28,6,'Injection','15 days',DATE '2025-05-08');
INSERT INTO Prescription VALUES (9,9,29,2,'2 times/day','5 days',DATE '2025-05-09');
INSERT INTO Prescription VALUES (10,10,30,9,'1 time/day','30 days',DATE '2025-05-10');

INSERT INTO Lab_Test VALUES (1,1,'Blood Test','Normal',500,DATE '2025-05-01');
INSERT INTO Lab_Test VALUES (2,2,'MRI','Minor Issue',3000,DATE '2025-05-02');
INSERT INTO Lab_Test VALUES (3,3,'X-Ray','Fracture Detected',1000,DATE '2025-05-03');
INSERT INTO Lab_Test VALUES (4,4,'CT Scan','Burn Depth',2500,DATE '2025-05-04');
INSERT INTO Lab_Test VALUES (5,5,'X-Ray','Clear',1200,DATE '2025-05-05');
INSERT INTO Lab_Test VALUES (6,6,'Blood Test','Infection',600,DATE '2025-05-06');
INSERT INTO Lab_Test VALUES (7,7,'Skin Test','Allergy',700,DATE '2025-05-07');
INSERT INTO Lab_Test VALUES (8,8,'Biopsy','Positive',4000,DATE '2025-05-08');
INSERT INTO Lab_Test VALUES (9,9,'Ear Test','Infection',800,DATE '2025-05-09');
INSERT INTO Lab_Test VALUES (10,10,'General Test','Normal',400,DATE '2025-05-10');

COMMIT;

---|------------------------------------------------------------------------|---
---|________________________________ VIEWS _________________________________|---
---|------------------------------------------------------------------------|---

-- This view will make is easier to retrieve and insert data into the
-- Patient table without having to write down the JOIN query every time.

CREATE OR REPLACE VIEW vw_Patient_Directory AS
SELECT 
    p.personID,
    pe.name,
    pe.DOB,
    pe.gender,
    pe.contact,
    p.blood_group,
    p.patient_type,
    p.medical_history
FROM Patient p
JOIN Person pe ON p.personID = pe.personID;

-- This view will make is easier to retrieve and insert data into the
-- Doctor table without having to write down the JOIN query every time.

CREATE OR REPLACE VIEW vw_Doctor_Profile AS
SELECT 
    p.personID, 
    p.name, 
    p.DOB, 
    p.gender, 
    p.contact, 
    p.address,
    d.specialisation, 
    d.salary,
    w.deptID
FROM Person p
JOIN Doctor d ON p.personID = d.personID
LEFT JOIN Works_In w ON d.personID = w.personID;

-- This view merges the appointment details and the patient ID. To actually
-- book a patient, you have to link them using the Attends junction table.

CREATE OR REPLACE VIEW vw_Appointment_Booking AS
SELECT 
    a.appointmentID, 
    a.appointment_date, 
    a.appointment_time, 
    a.status, 
    a.receptionistID,
    at.patientID
FROM Appointment a
JOIN Attends at ON a.appointmentID = at.appointmentID;

-- This view allows us to see which patients are admitted to which wards.

CREATE OR REPLACE VIEW vw_Patient_Admission_Status AS
SELECT 
    p.personID AS patientID,
    pe.name,
    a.wardNo,
    w.type AS ward_type,
    a.admit_date
FROM Patient p
JOIN Person pe ON p.personID = pe.personID
JOIN Admitted_To a ON p.personID = a.patientID
JOIN Ward w ON a.wardNo = w.wardNo;

-- This view provides a unified list of all hospital staff (Doctors, Nurses, Receptionists)
-- without exposing their salaries or specific personal contact details.

CREATE OR REPLACE VIEW vw_Secure_Staff_Directory AS
SELECT p.personID AS Staff_ID, p.name, 'Doctor' AS Role, d.specialisation AS Detail, NULL AS Shift
FROM Person p JOIN Doctor d ON p.personID = d.personID
UNION
SELECT p.personID, p.name, 'Nurse', 'Experience: ' || n.experience || ' yrs', n.shift
FROM Person p JOIN Nurse n ON p.personID = n.personID
UNION
SELECT p.personID, p.name, 'Receptionist', 'Front Desk', r.shift
FROM Person p JOIN Receptionist r ON p.personID = r.personID;

-- This view links five different tables to give a doctor a complete
-- overview of a patient's medical journey in a single query.

CREATE OR REPLACE VIEW vw_Patient_Medical_History AS
SELECT 
    m.recordID,
    pe_pat.name AS Patient_Name,
    pe_doc.name AS Attending_Doctor,
    t.diagnosis,
    t.treatment_details,
    m.record_date,
    m.description AS Record_Notes
FROM Medical_Record m
JOIN Patient p ON m.patientID = p.personID
JOIN Person pe_pat ON p.personID = pe_pat.personID
JOIN Doctor d ON m.doctorID = d.personID
JOIN Person pe_doc ON d.personID = pe_doc.personID
JOIN Treatment t ON m.treatmentID = t.treatmentID;

-- Receptionists need to see today's appointments instantly.
-- This view dynamically filters for the current system date.

CREATE OR REPLACE VIEW vw_Todays_Appointments AS
SELECT 
    a.appointmentID,
    a.appointment_time,
    pe.name AS Patient_Name,
    a.status,
    pe_rec.name AS Handled_By
FROM Appointment a
JOIN Attends at ON a.appointmentID = at.appointmentID
JOIN Person pe ON at.patientID = pe.personID
JOIN Person pe_rec ON a.receptionistID = pe_rec.personID
WHERE TRUNC(a.appointment_date) = TRUNC(SYSDATE)
ORDER BY a.appointment_time;

-- This view filters out out-of-stock medicines, ensuring doctors
-- only see available medications when writing a prescription.

CREATE OR REPLACE VIEW vw_Available_Medicines AS
SELECT 
    medicineID,
    medicine_name,
    unit_price,
    stock_qty
FROM Medicine
WHERE stock_qty > 0
ORDER BY medicine_name;

-- Links prescriptions directly to the medicine details and the
-- diagnosing doctor, which is highly useful for the pharmacy module.

CREATE OR REPLACE VIEW vw_Prescription_Details AS
SELECT 
    pr.prescriptionID,
    t.diagnosis,
    pe_doc.name AS Prescribed_By,
    m.medicine_name,
    pr.dosage,
    pr.duration,
    pr.date_issued
FROM Prescription pr
JOIN Treatment t ON pr.treatmentID = t.treatmentID
JOIN Doctor d ON pr.doctorID = d.personID
JOIN Person pe_doc ON d.personID = pe_doc.personID
JOIN Medicine m ON pr.medicineID = m.medicineID;

-- Aggregates lab test results alongside the cost and the associated treatment diagnosis.

CREATE OR REPLACE VIEW vw_Lab_Results_Summary AS
SELECT 
    l.testID,
    l.test_name,
    l.result,
    l.test_date,
    t.diagnosis,
    l.cost
FROM Lab_Test l
JOIN Treatment t ON l.treatmentID = t.treatmentID
ORDER BY l.test_date DESC;

-- This view helps identify which nurses are covering which
-- wards, including their shifts and the managing department.

CREATE OR REPLACE VIEW vw_Nurse_Ward_Assignments AS
SELECT 
    pe.name AS Nurse_Name,
    n.shift,
    w.wardNo,
    w.type AS Ward_Type,
    d.dept_name AS Department
FROM Assigned_To a
JOIN Nurse n ON a.nurseID = n.personID
JOIN Person pe ON n.personID = pe.personID
JOIN Ward w ON a.wardNo = w.wardNo
JOIN Department d ON w.deptID = d.deptID;

-- This view calculates the total revenue generated, grouped by payment status.

CREATE OR REPLACE VIEW vw_Revenue_Summary AS
SELECT 
    payment_status,
    COUNT(billID) AS Total_Invoices,
    SUM(Amount) AS Total_Revenue
FROM Billing
GROUP BY payment_status;

---|------------------------------------------------------------------------|---
---|_______________________________ INDEXES ________________________________|---
---|------------------------------------------------------------------------|---

CREATE INDEX idx_med_rec_patient ON Medical_Record(patientID);
CREATE INDEX idx_admitted_ward ON Admitted_To(wardNo);
CREATE INDEX idx_prescription_medicine ON Prescription(medicineID);
CREATE INDEX idx_prescription_treatment ON Prescription(treatmentID);
CREATE INDEX idx_labtest_name ON Lab_Test(test_name);
CREATE INDEX idx_person_dob ON Person(DOB);
CREATE INDEX idx_nurse_shift ON Nurse(shift);
CREATE INDEX idx_receptionist_shift ON Receptionist(shift);
CREATE INDEX idx_worksin_dept ON Works_In(deptID);
CREATE INDEX idx_treatment_date ON Treatment(treatment_date);
CREATE INDEX idx_billing_paydate ON Billing(payment_date);
CREATE INDEX idx_admitted_date ON Admitted_To(admit_date);
CREATE INDEX idx_patient_blood ON Patient(blood_group);
CREATE INDEX idx_labtest_treatment ON Lab_Test(treatmentID);
CREATE INDEX idx_attends_patient ON Attends(patientID);
CREATE INDEX idx_attends_appointment ON Attends(appointmentID);
CREATE INDEX idx_receives_doctor ON Receives(doctorID);
CREATE INDEX idx_receives_patient ON Receives(patientID);
CREATE INDEX idx_ward_dept ON Ward(deptID);

---|------------------------------------------------------------------------|---
---|______________________________ TRIGGERS ________________________________|---
---|------------------------------------------------------------------------|---

-- When a doctor prescribes a medicine, the pharmacy's stock should automatically
-- decrease. If there is no stock, the database should reject the prescription.

CREATE OR REPLACE TRIGGER trg_auto_deduct_medicine
BEFORE INSERT ON Prescription
FOR EACH ROW
DECLARE
    v_current_stock NUMBER;
BEGIN
    SELECT stock_qty INTO v_current_stock
    FROM Medicine
    WHERE medicineID = :NEW.medicineID;
    
    IF v_current_stock > 0 THEN
        UPDATE Medicine
        SET stock_qty = stock_qty - 1
        WHERE medicineID = :NEW.medicineID;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Error: Insufficient stock for Medicine ID ' || :NEW.medicineID);
    END IF;
END;
/

-- When a lab test is added to a treatment, the cost of that test
-- should automatically be added to the patient's existing bill.

CREATE OR REPLACE TRIGGER trg_add_lab_cost_to_bill
AFTER INSERT ON Lab_Test
FOR EACH ROW
BEGIN
    UPDATE Billing
    SET Amount = Amount + :NEW.cost
    WHERE treatmentID = :NEW.treatmentID;
END;
/

-- Ensure that if an admission date is somehow missed in the application
-- layer, the database automatically stamps it with the current date.

CREATE OR REPLACE TRIGGER trg_set_admit_date
BEFORE INSERT ON Admitted_To
FOR EACH ROW
BEGIN
    IF :NEW.admit_date IS NULL THEN
    :NEW.admit_date := SYSDATE;
    END IF;
END;
/

-- A hospital cannot admit a patient into a ward that is already full. This
-- trigger checks the current patient count against the ward's maximum capacity.

CREATE OR REPLACE TRIGGER trg_check_ward_capacity
BEFORE INSERT ON Admitted_To
FOR EACH ROW
DECLARE
    v_current_patients NUMBER;
    v_max_capacity NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_current_patients
    FROM Admitted_To
    WHERE wardNo = :NEW.wardNo;
    
    SELECT capacity INTO v_max_capacity
    FROM Ward
    WHERE wardNo = :NEW.wardNo; 
    
    IF v_current_patients >= v_max_capacity THEN
        RAISE_APPLICATION_ERROR(-20002, 'Admission Denied: Ward ' || :NEW.wardNo || ' is at full capacity.');
    END IF;
END;
/

-- Receptionists should not be able to schedule new appointments in the past.

CREATE OR REPLACE TRIGGER trg_prevent_past_appointments
BEFORE INSERT OR UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF :NEW.appointment_date < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Invalid entry: Appointments cannot be scheduled in the past');
    END IF;
END;
/

-- A person cannot be born tomorrow. This trigger prevents it.

CREATE OR REPLACE TRIGGER trg_validate_dob
BEFORE INSERT OR UPDATE ON Person
FOR EACH ROW
BEGIN
    IF :NEW.DOB > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20004, 'Invalid Entry: Date of Birth cannot be in the future.');
    END IF;
END;
/

-- This trigger intercepts an insert into the view and properly
-- splits the data into the Person and Patient base tables.

CREATE OR REPLACE TRIGGER trg_insert_patient_view
INSTEAD OF INSERT ON vw_Patient_Directory
FOR EACH ROW
BEGIN
    INSERT INTO Person (personID, name, DOB, gender, contact)
    VALUES (:NEW.personID, :NEW.name, :NEW.DOB, :NEW.gender, :NEW.contact);
    
    INSERT INTO Patient (personID, blood_group, patient_type, medical_history)
    VALUES (:NEW.personID, :NEW.blood_group, :NEW.patient_type, :NEW.medical_history);
END;
/

-- This trigger intercepts an insert into the view and properly splits the data into the
-- Person and Doctor base tables, and assign the doctor to the correct Works_In department.

CREATE OR REPLACE TRIGGER trg_insert_doctor_profile
INSTEAD OF INSERT ON vw_Doctor_Profile
FOR EACH ROW
BEGIN
    INSERT INTO Person (personID, name, DOB, gender, contact, address)
    VALUES (:NEW.personID, :NEW.name, :NEW.DOB, :NEW.gender, :NEW.contact, :NEW.address);
    
    INSERT INTO Doctor (personID, specialisation, salary)
    VALUES (:NEW.personID, :NEW.specialisation, :NEW.salary);
    
    IF :NEW.deptID IS NOT NULL THEN
        INSERT INTO Works_In (personID, deptID)
        VALUES (:NEW.personID, :NEW.deptID);
    END IF;
END;
/

-- When the receptionist books an appointment through this view, the
-- trigger splits the data and maps the junction table automatically.

CREATE OR REPLACE TRIGGER trg_book_appointment
INSTEAD OF INSERT ON vw_Appointment_Booking
FOR EACH ROW
BEGIN
    INSERT INTO Appointment (appointmentID, appointment_date, appointment_time, status, receptionistID)
    VALUES (:NEW.appointmentID, :NEW.appointment_date, :NEW.appointment_time, NVL(:NEW.status, 'Scheduled'), :NEW.receptionistID);
    
    INSERT INTO Attends (patientID, appointmentID)
    VALUES (:NEW.patientID, :NEW.appointmentID);
END;
/

-- This allows nurses to update the patient's record on their screen, and the patient
-- is moved to the new ward and their admission clock is reset for that specific ward.

CREATE OR REPLACE TRIGGER trg_transfer_patient_ward
INSTEAD OF UPDATE ON vw_Patient_Admission_Status
FOR EACH ROW
BEGIN
    IF :OLD.wardNo <> :NEW.wardNo THEN
        UPDATE Admitted_To
        SET wardNo = :NEW.wardNo, admit_date = SYSDATE 
        WHERE patientID = :NEW.patientID AND wardNo = :OLD.wardNo;
    END IF;
END;
/

---|------------------------------------------------------------------------|---
---|_____________________________ SUBQUERIES _______________________________|---
---|------------------------------------------------------------------------|---

-- For identifying patients who have bills greater than average which is useful for premium service targeting

SELECT patientID
FROM Pays
WHERE billID IN (
    SELECT billID
    FROM Billing
    WHERE Amount > (SELECT AVG(Amount) FROM Billing)
);

-- For retrieving doctors who treat more patients than average for workload comparison and help balance doctor assignment

SELECT doctorID
FROM Receives
GROUP BY doctorID
HAVING COUNT(patientID) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(patientID) cnt
        FROM Receives
        GROUP BY doctorID
    )
);

-- For selecting patients who never paid any bill to find defaulters and recover billing

SELECT personID
FROM Patient
WHERE personID NOT IN (
    SELECT patientID
    FROM Pays
);

-- For viewing the most expensive treatment for financial analysis

SELECT treatmentID
FROM Billing
WHERE Amount = (SELECT MAX(Amount) FROM Billing);

-- For viewing medicines with stock below average for detecting low stock and efficient inventory management

SELECT medicineID
FROM Medicine
WHERE stock_qty < (SELECT AVG(stock_qty) FROM Medicine);

-- For identifying patients admitted in full capacity wards to check high-load wards and monitor resources

SELECT patientID
FROM Admitted_To
WHERE wardNo IN (
    SELECT wardNo
    FROM Ward
    WHERE capacity = (
        SELECT MAX(capacity)
        FROM Ward
    )
);

-- For selecting doctors without any treatments to identify inactive doctors and enabling staff utilization

SELECT personID
FROM Doctor
WHERE personID NOT IN (SELECT doctorID FROM Treatment);

-- For identifying patients with more than one admission to detect frequent admissions and track chronic illness

SELECT patientID
FROM Admitted_To
GROUP BY patientID
HAVING COUNT(*) > 1;

-- For detecting treatments having lab tests above average cost for expensive tests diagnosis and cost control

SELECT treatmentID
FROM Lab_Test
WHERE cost > (SELECT AVG(cost) FROM Lab_Test);

-- For identifying receptionist with maximum number of appointments to find best performing receptionist

SELECT receptionistID
FROM Appointment
GROUP BY receptionistID
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) cnt
        FROM Appointment
        GROUP BY receptionistID
    )
);

-- For retrieving patients who have appointments but no treatment to detect missed diagnosis treatment and improve care quality

SELECT patientID
FROM Attends
WHERE appointmentID NOT IN (
    SELECT appointmentID FROM Leads_To
);

-- For viewing unused medicines that were never prescribed to reduce wastage

SELECT medicineID
FROM Medicine
WHERE medicineID NOT IN (
    SELECT medicineID FROM Prescription
);

-- For retrieving patients with the highest number of bills to identify critical patients

SELECT patientID
FROM Pays
GROUP BY patientID
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) cnt
        FROM Pays
        GROUP BY patientID
    )
);

-- For identifying wards with above average capacity for efficient resource allocation

SELECT wardNo
FROM Ward
WHERE capacity > (SELECT AVG(capacity) FROM Ward);

-- For identifying doctors earning more than average salary for salary comparison and HR analysis

SELECT personID
FROM Doctor
WHERE salary > (SELECT AVG(salary) FROM Doctor);

-- For viewing appointments scheduled today for real-time monitoring

SELECT appointmentID
FROM Appointment
WHERE appointment_date = TRUNC(SYSDATE);

-- For selecting patients who have both appointment and admission for detailed case analysis

SELECT personID
FROM Patient
WHERE personID IN (SELECT patientID FROM Attends)
AND personID IN (SELECT patientID FROM Admitted_To);

-- For retrieving treatments without lab tests for missing diagnosis and ensuring quality assurance

SELECT treatmentID
FROM Treatment
WHERE treatmentID NOT IN (
    SELECT treatmentID FROM Lab_Test
);

-- For selecting high-revenue transactions (bills paid above average) to get financial insights

SELECT billID
FROM Billing
WHERE Amount > (SELECT AVG(Amount) FROM Billing)
AND payment_status = 'Paid';

-- For retrieving nurses who are assigned to more than one ward for proper workforce planning

SELECT nurseID
FROM Assigned_To
GROUP BY nurseID
HAVING COUNT(wardNo) > 1;

---|------------------------------------------------------------------------|---
---|___________________________ QUERIES (JOINS) ____________________________|---
---|------------------------------------------------------------------------|---

-- For viewing complete patient profile with doctor assigned and department they belong to, used in dashboards for patient tracking

SELECT pe.name AS patient_name, d.specialisation, dep.dept_name
FROM Patient p
JOIN Person pe ON p.personID = pe.personID
JOIN Receives r ON p.personID = r.patientID
JOIN Doctor d ON r.doctorID = d.personID
JOIN Works_In w ON d.personID = w.personID
JOIN Department dep ON w.deptID = dep.deptID;

-- For viewing total revenue generated by each department which helps hospital management allocate resources

SELECT dep.dept_name, SUM(b.Amount) AS total_revenue
FROM Billing b
JOIN Treatment t ON b.treatmentID = t.treatmentID
JOIN Doctor d ON t.doctorID = d.personID
JOIN Works_In w ON d.personID = w.personID
JOIN Department dep ON w.deptID = dep.deptID
GROUP BY dep.dept_name;

-- For identifying unpaid bills which is useful for billing department follow-ups

SELECT pe.name, b.Amount
FROM Billing b
JOIN Pays py ON b.billID = py.billID
JOIN Patient p ON py.patientID = p.personID
JOIN Person pe ON p.personID = pe.personID
WHERE b.payment_status = 'Pending';

-- For identifying most frequently prescribed medicines to help inventory planning

SELECT m.medicine_name, COUNT(*) AS usage_count
FROM Prescription p
JOIN Medicine m ON p.medicineID = m.medicineID
GROUP BY m.medicine_name
ORDER BY usage_count DESC;

-- For selecting doctors with the highest number of patients which helps in staff balancing

SELECT pe.name, COUNT(r.patientID) AS total_patients
FROM Doctor d
JOIN Person pe ON d.personID = pe.personID
JOIN Receives r ON d.personID = r.doctorID
GROUP BY pe.name
ORDER BY total_patients DESC;

-- For viewing ward occupancy status to prevent overbooking of certain wards

SELECT w.wardNo, w.capacity, COUNT(a.patientID) AS occupied
FROM Ward w
LEFT JOIN Admitted_To a ON w.wardNo = a.wardNo
GROUP BY w.wardNo, w.capacity;

-- For selecting patients admitted in ICU which helps in emergency monitoring

SELECT pe.name
FROM Admitted_To a
JOIN Ward w ON a.wardNo = w.wardNo
JOIN Patient p ON a.patientID = p.personID
JOIN Person pe ON p.personID = pe.personID
WHERE w.type = 'ICU';

-- For viewing appointment count per receptionist to evaluate receptionist performance

SELECT pe.name, COUNT(*) AS total_appointments
FROM Appointment a
JOIN Receptionist r ON a.receptionistID = r.personID
JOIN Person pe ON r.personID = pe.personID
GROUP BY pe.name;

-- For retrieving lab tests with cost higher than 2000 which helps in cost analysis

SELECT t.treatmentID, l.test_name, l.cost
FROM Treatment t
JOIN Lab_Test l ON t.treatmentID = l.treatmentID
WHERE l.cost > 2000;

-- For retrieving patients with multiple admissions to identify chronic cases

SELECT pe.name, COUNT(*) AS admission_count
FROM Admitted_To a
JOIN Patient p ON a.patientID = p.personID
JOIN Person pe ON p.personID = pe.personID
GROUP BY pe.name
HAVING COUNT(*) > 1;

-- For selecting nurses assisting multiple doctors for efficient shift planning and managing workload

SELECT pe.name, COUNT(a.doctorID) AS doctors_assisted
FROM Assists a
JOIN Nurse n ON a.nurseID = n.personID
JOIN Person pe ON n.personID = pe.personID
GROUP BY pe.name
HAVING COUNT(a.doctorID) > 1;

-- For selecting average billing amount per patients for revenue segmentation

SELECT pe.name, AVG(b.Amount) AS avg_bill
FROM Billing b
JOIN Pays py ON b.billID = py.billID
JOIN Patient p ON py.patientID = p.personID
JOIN Person pe ON p.personID = pe.personID
GROUP BY pe.name;

-- For viewing doctors without any assigned patients for proper resource management

SELECT pe.name
FROM Doctor d
JOIN Person pe ON d.personID = pe.personID
WHERE d.personID NOT IN (SELECT doctorID FROM Receives);

-- For viewing most common diagnosis to get public health insights

SELECT diagnosis, COUNT(*) AS frequency
FROM Treatment
GROUP BY diagnosis
ORDER BY frequency DESC;

-- For retrieving daily appointment count for scheduling optimization

SELECT appointment_date, COUNT(*) AS total
FROM Appointment
GROUP BY appointment_date
ORDER BY appointment_date;

-- For retrieving patients with prescriptions and medicines to track prescriptions and coordinate pharmacies

SELECT pe.name, m.medicine_name
FROM Prescription pr
JOIN Patient p ON pr.treatmentID = p.personID
JOIN Person pe ON p.personID = pe.personID
JOIN Medicine m ON pr.medicineID = m.medicineID;

-- For selecting total lab costs per treatment for billing transparency

SELECT t.treatmentID, SUM(l.cost) AS total_lab_cost
FROM Treatment t
JOIN Lab_Test l ON t.treatmentID = l.treatmentID
GROUP BY t.treatmentID;

-- For selecting department-wise doctor count to plan workforce conveniently

SELECT dep.dept_name, COUNT(*) AS doctor_count
FROM Works_In w
JOIN Doctor d ON w.personID = d.personID
JOIN Department dep ON w.deptID = dep.deptID
GROUP BY dep.dept_name;

-- For identifying patients with completed appointments to view active patients for follow-up planning

SELECT DISTINCT pe.name
FROM Appointment a
JOIN Attends at ON a.appointmentID = at.appointmentID
JOIN Patient p ON at.patientID = p.personID
JOIN Person pe ON p.personID = pe.personID
WHERE a.status = 'Completed';

-- For identifying top 5 highest bills for financial auditing

SELECT * FROM (
    SELECT billID, Amount
    FROM Billing
    ORDER BY Amount DESC
)
WHERE ROWNUM <= 5;

---|------------------------------------------------------------------------|---
---|_____________________________ PROCEDURES _______________________________|---
---|------------------------------------------------------------------------|---

-- To register a new patient into Person and Patient tables

CREATE OR REPLACE PROCEDURE add_patient (
    p_id NUMBER, p_name VARCHAR2, p_dob DATE, p_gender VARCHAR2,
    p_contact VARCHAR2, p_address VARCHAR2,
    p_blood VARCHAR2, p_type VARCHAR2, p_history VARCHAR2
)
IS
BEGIN
    INSERT INTO Person VALUES (p_id, p_name, p_dob, p_gender, p_contact, p_address);
    INSERT INTO Patient VALUES (p_id, p_blood, p_history, p_type);
END;
/

-- To add a new doctor and assign to department

CREATE OR REPLACE PROCEDURE add_doctor (
    p_id NUMBER, p_name VARCHAR2, p_dob DATE, p_gender VARCHAR2,
    p_contact VARCHAR2, p_address VARCHAR2,
    p_spec VARCHAR2, p_salary NUMBER, p_dept NUMBER
)
IS
BEGIN
    INSERT INTO Person VALUES (p_id, p_name, p_dob, p_gender, p_contact, p_address);
    INSERT INTO Doctor VALUES (p_id, p_spec, p_salary);
    INSERT INTO Works_In VALUES (p_id, p_dept);
END;
/

-- To book an appointment and link patient

CREATE OR REPLACE PROCEDURE book_appointment (
    p_appID NUMBER, p_date DATE, p_time VARCHAR2,
    p_recID NUMBER, p_patientID NUMBER
)
IS
BEGIN
    INSERT INTO Appointment VALUES (p_appID, p_date, p_time, 'Scheduled', p_recID);
    INSERT INTO Attends VALUES (p_patientID, p_appID);
END;
/

-- To admit a patient to a ward

CREATE OR REPLACE PROCEDURE admit_patient (
    p_patientID NUMBER, p_ward NUMBER
)
IS
BEGIN
    INSERT INTO Admitted_To(patientID, wardNo) VALUES (p_patientID, p_ward);
END;
/

-- To remove a patient from ward after treatment

CREATE OR REPLACE PROCEDURE discharge_patient (
    p_patientID NUMBER, p_ward NUMBER
)
IS
BEGIN
    DELETE FROM Admitted_To
    WHERE patientID = p_patientID AND wardNo = p_ward;
END;
/

-- To assign nurse duty to ward

CREATE OR REPLACE PROCEDURE assign_nurse (
    p_nurse NUMBER, p_ward NUMBER
)
IS
BEGIN
    INSERT INTO Assigned_To VALUES (p_nurse, p_ward);
END;
/

-- To add a treatment entry by doctor

CREATE OR REPLACE PROCEDURE add_treatment (
    p_id NUMBER, p_diag VARCHAR2, p_detail VARCHAR2, p_doc NUMBER
)
IS
BEGIN
    INSERT INTO Treatment(treatmentID, diagnosis, treatment_details, doctorID)
    VALUES (p_id, p_diag, p_detail, p_doc);
END;
/

-- To create billing record for treatment

CREATE OR REPLACE PROCEDURE generate_bill (
    p_billID NUMBER, p_amount NUMBER, p_treat NUMBER, p_rec NUMBER
)
IS
BEGIN
    INSERT INTO Billing VALUES (p_billID, p_amount, SYSDATE, 'Pending', p_treat, p_rec);
END;
/

-- To update bill status and records payment

CREATE OR REPLACE PROCEDURE pay_bill (
    p_billID NUMBER, p_patient NUMBER
)
IS
BEGIN
    UPDATE Billing SET payment_status = 'Paid', payment_date = SYSDATE
    WHERE billID = p_billID;

    INSERT INTO Pays VALUES (p_patient, p_billID);
END;
/

-- To record prescribed medicine for treatment

CREATE OR REPLACE PROCEDURE add_prescription (
    p_id NUMBER, p_treat NUMBER, p_doc NUMBER,
    p_med NUMBER, p_dose VARCHAR2, p_duration VARCHAR2
)
IS
BEGIN
    INSERT INTO Prescription VALUES (p_id, p_treat, p_doc, p_med, p_dose, p_duration, SYSDATE);
END;
/

-- To record diagnostic test for treatment

CREATE OR REPLACE PROCEDURE add_lab_test (
    p_id NUMBER, p_treat NUMBER, p_name VARCHAR2, p_result VARCHAR2, p_cost NUMBER
)
IS
BEGIN
    INSERT INTO Lab_Test VALUES (p_id, p_treat, p_name, p_result, p_cost, SYSDATE);
END;
/

-- To update medicine inventory after restock

CREATE OR REPLACE PROCEDURE update_medicine_stock (
    p_medID NUMBER, p_qty NUMBER
)
IS
BEGIN
    UPDATE Medicine
    SET stock_qty = stock_qty + p_qty
    WHERE medicineID = p_medID;
END;
/

-- To move patient from one ward to another

CREATE OR REPLACE PROCEDURE transfer_patient (
    p_patient NUMBER, p_oldWard NUMBER, p_newWard NUMBER
)
IS
BEGIN
    DELETE FROM Admitted_To WHERE patientID = p_patient AND wardNo = p_oldWard;
    INSERT INTO Admitted_To VALUES (p_patient, p_newWard, SYSDATE);
END;
/

-- To link doctor with patient

CREATE OR REPLACE PROCEDURE assign_doctor (
    p_doc NUMBER, p_patient NUMBER
)
IS
BEGIN
    INSERT INTO Receives VALUES (p_doc, p_patient);
END;
/

-- To store patient's medical history record

CREATE OR REPLACE PROCEDURE add_medical_record (
    p_id NUMBER, p_patient NUMBER, p_doc NUMBER, p_treat NUMBER, p_desc VARCHAR2
)
IS
BEGIN
    INSERT INTO Medical_Record VALUES (p_id, p_patient, p_doc, p_treat, SYSDATE, p_desc);
END;
/

-- To cancel an existing appointment

CREATE OR REPLACE PROCEDURE cancel_appointment (
    p_appID NUMBER
)
IS
BEGIN
    UPDATE Appointment SET status = 'Cancelled'
    WHERE appointmentID = p_appID;
END;
/

-- To mark appointment as completed

CREATE OR REPLACE PROCEDURE complete_appointment (
    p_appID NUMBER
)
IS
BEGIN
    UPDATE Appointment SET status = 'Completed'
    WHERE appointmentID = p_appID;
END;
/

-- To track which receptionist handled appointment

CREATE OR REPLACE PROCEDURE assign_receptionist (
    p_rec NUMBER, p_app NUMBER
)
IS
BEGIN
    INSERT INTO Handles_Appointment VALUES (p_rec, p_app);
END;
/

-- To track billing handled by receptionist
CREATE OR REPLACE PROCEDURE assign_billing_handler (
    p_rec NUMBER, p_bill NUMBER
)
IS
BEGIN
    INSERT INTO Handles_Billing VALUES (p_rec, p_bill);
END;
/

-- To remove patient and all related records (via cascade)

CREATE OR REPLACE PROCEDURE delete_patient (
    p_id NUMBER
)
IS
BEGIN
    DELETE FROM Person WHERE personID = p_id;
END;
/

---|------------------------------------------------------------------------|---
---|__________________________ ROLE-BASED SYSTEM ___________________________|---
---|------------------------------------------------------------------------|---

-- Creating Roles

CREATE ROLE doctor_role;
CREATE ROLE nurse_role;
CREATE ROLE receptionist_role;
CREATE ROLE admin_role;

-- DOCTOR ROLE PERMISSIONS
-- Doctors can treat patients but cannot manipulate sensitive financial/system data

-- Read access via secure views
GRANT SELECT ON vw_Patient_Directory TO doctor_role;
GRANT SELECT ON vw_Patient_Medical_History TO doctor_role;
GRANT SELECT ON vw_Available_Medicines TO doctor_role;
GRANT SELECT ON vw_Lab_Results_Summary TO doctor_role;

-- Insert capabilities
GRANT INSERT ON Treatment TO doctor_role;
GRANT INSERT ON Prescription TO doctor_role;
GRANT INSERT ON Lab_Test TO doctor_role;

-- Limited update
GRANT UPDATE (diagnosis, treatment_details) ON Treatment TO doctor_role;

-- NURSE ROLE PERMISSIONS
-- Nurses assist operations without interfering with diagnosis or billing.

GRANT SELECT ON vw_Patient_Admission_Status TO nurse_role;
GRANT SELECT ON vw_Nurse_Ward_Assignments TO nurse_role;
GRANT SELECT ON vw_Patient_Directory TO nurse_role;

-- Allow updates through view
GRANT UPDATE ON vw_Patient_Admission_Status TO nurse_role;

-- RECEPTIONIST ROLE PERMISSIONS
-- Enables receptionists to carry out front desk operations securely like handling billing and appointments.

GRANT SELECT ON vw_Patient_Directory TO receptionist_role;
GRANT SELECT, INSERT, UPDATE ON Appointment TO receptionist_role;
GRANT SELECT, INSERT, UPDATE ON Billing TO receptionist_role;

GRANT SELECT ON vw_Todays_Appointments TO receptionist_role;
GRANT SELECT ON vw_Revenue_Summary TO receptionist_role;

-- Junction tables
GRANT INSERT ON Attends TO receptionist_role;
GRANT INSERT ON Handles_Appointment TO receptionist_role;
GRANT INSERT ON Handles_Billing TO receptionist_role;

-- ADMIN ROLE PERMISSIONS
-- Admins have complete system access and can manage users, schema, and data

GRANT ALL ON Person TO admin_role;
GRANT ALL ON Patient TO admin_role;
GRANT ALL ON Doctor TO admin_role;
GRANT ALL ON Nurse TO admin_role;
GRANT ALL ON Receptionist TO admin_role;
GRANT ALL ON Department TO admin_role;
GRANT ALL ON Works_In TO admin_role;
GRANT ALL ON Ward TO admin_role;
GRANT ALL ON Assigned_To TO admin_role;
GRANT ALL ON Admitted_To TO admin_role;
GRANT ALL ON Receives TO admin_role;
GRANT ALL ON Assists TO admin_role;
GRANT ALL ON Treatment TO admin_role;
GRANT ALL ON Appointment TO admin_role;
GRANT ALL ON Attends TO admin_role;
GRANT ALL ON Leads_To TO admin_role;
GRANT ALL ON Billing TO admin_role;
GRANT ALL ON Pays TO admin_role;
GRANT ALL ON Handles_Appointment TO admin_role;
GRANT ALL ON Handles_Billing TO admin_role;
GRANT ALL ON Medical_Record TO admin_role;
GRANT ALL ON Medicine TO admin_role;
GRANT ALL ON Prescription TO admin_role;
GRANT ALL ON Lab_Test TO admin_role;

-- Views
GRANT ALL ON vw_Patient_Directory TO admin_role;
GRANT ALL ON vw_Doctor_Profile TO admin_role;
GRANT ALL ON vw_Patient_Medical_History TO admin_role;
GRANT ALL ON vw_Todays_Appointments TO admin_role;
GRANT ALL ON vw_Revenue_Summary TO admin_role;

-- Creating Users

CREATE USER doc1 IDENTIFIED BY doc123;
CREATE USER nurse1 IDENTIFIED BY nurse123;
CREATE USER admin1 IDENTIFIED BY admin123;
CREATE USER recep1 IDENTIFIED BY recep123;

-- Assigning Roles to Users

GRANT doctor_role TO doc1;
GRANT nurse_role TO nurse1;
GRANT admin_role TO admin1;
GRANT receptionist_role TO recep1;

-- Granting System Privileges

GRANT CREATE SESSION TO doc1;
GRANT CREATE SESSION TO nurse1;
GRANT CREATE SESSION TO admin1;
GRANT CREATE SESSION TO recep1;

-- Granting Extra Security

-- Restrict direct table access and forces doctors to use secure views only
REVOKE ALL ON Patient FROM doctor_role;
REVOKE ALL ON Person FROM doctor_role;

-- Read-only role
CREATE ROLE read_only_role;
GRANT SELECT ANY TABLE TO read_only_role;

-- Password policy
ALTER PROFILE DEFAULT LIMIT
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LIFE_TIME 30;

-- SELECT * FROM USER_ROLE_PRIVS;

---|------------------------------------------------------------------------|---
---|__________________________ ADMIN-ROLE LOGIN ____________________________|---
---|------------------------------------------------------------------------|---

SELECT * FROM system.Person;
SELECT * FROM system.Patient;
SELECT * FROM system.Billing;

-- INSERT INTO system.Department VALUES (20, 'Psychiatry', 'Block Z');

-- UPDATE system.Doctor
-- SET salary = 300000
-- WHERE personID = 21;

-- DELETE FROM system.Patient
-- WHERE personID = 5;

---|------------------------------------------------------------------------|---
---|__________________________ NURSE-ROLE LOGIN ____________________________|---
---|------------------------------------------------------------------------|---

SELECT * FROM system.vw_Patient_Admission_Status;
SELECT * FROM system.vw_Nurse_Ward_Assignments;

-- UPDATE system.vw_Patient_Admission_Status
-- SET wardNo = 102
-- WHERE patientID = 2;

-- Restricted Query
-- INSERT INTO system.Prescription 
-- VALUES (200,1,21,1,'2/day','5 days',SYSDATE);

---|------------------------------------------------------------------------|---
---|_______________________ RECEPTIONIST-ROLE LOGIN ________________________|---
---|------------------------------------------------------------------------|---

SELECT * FROM system.vw_Todays_Appointments;
SELECT * FROM system.vw_Revenue_Summary;

-- INSERT INTO system.Appointment (appointmentID, appointment_date, appointment_time, status, receptionistID)
-- VALUES (101, SYSDATE + 1, '11:00', 'Scheduled', 6);

-- INSERT INTO system.Attends VALUES (1, 101);

-- INSERT INTO system.Billing (billID, Amount, payment_status, treatmentID, receptionistID)
-- VALUES (101, 5000, 'Pending', 1, 6);

-- Restricted Query
SELECT * FROM system.Medical_Record;

---|------------------------------------------------------------------------|---
---|__________________________ DOCTOR-ROLE LOGIN ___________________________|---
---|------------------------------------------------------------------------|---

SELECT * FROM system.vw_Patient_Directory;
SELECT * FROM system.vw_Patient_Medical_History;
SELECT * FROM system.vw_Available_Medicines;

-- INSERT INTO system.Treatment (treatmentID, diagnosis, treatment_details, doctorID)
-- VALUES (101, 'Flu', 'Medication + Rest', 21);

-- INSERT INTO system.Prescription (prescriptionID, treatmentID, doctorID, medicineID, dosage, duration)
-- VALUES (101, 1, 21, 1, '2/day', '5 days');

-- Restricted Query
SELECT * FROM system.Billing;