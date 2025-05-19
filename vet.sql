---VETERINARY CLINIC DATABASE MANAGEMENT SYSTEM----g
CREATE DATABASE IF NOT EXISTS vetClinicDB;
USE vetClinicDB;

---Owner Table--
CREATE TABLE Owner(
    OwnerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Address VARCHAR(100) NOT NULL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);  

----Staff Table----
CREATE TABLE Staff(
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100)  UNIQUE NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    specialization VARCHAR(50),
    hireDate DATE NOT NULL,
    salary DECIMAL(10,2)NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


---Pet Table--
CREATE TABLE Pet(
    PetID INT AUTO_INCREMENT  PRIMARY KEY,
    PetName VARCHAR(50) NOT NULL,
    PetType VARCHAR(50) NOT NULL,
    OwnerID INT NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    Breed VARCHAR (50),
    DOB DATE, 
    FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

----Appointment Table--
CREATE TABLE Appointment(
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PetID INT NOT NULL,
    OwnerID INT NOT NULL,
    StaffID INT NOT NULL,
    appointmentDate DATE NOT NULL,
    appointmentTime TIME NOT NULL,
    reason VARCHAR(250),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PetID) REFERENCES Pet(PetID)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
    ON DELETE RESTRICT ON UPDATE CASCADE

);


---Medical Record---
CREATE TABLE MedicalRecords(
    recordID INT AUTO_INCREMENT  PRIMARY KEY,
    PetID INT NOT NULL,
    StaffID INT,
    visitDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    symptoms VARCHAR(255),
    diagnosis VARCHAR(255),
    notes VARCHAR(255),
    FOREIGN KEY (PetID) REFERENCES Pet(PetID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
    ON DELETE SET NULL ON UPDATE CASCADE
);

--Treatment table---
create TABLE Treatment(
    treatmentID INT AUTO_INCREMENT PRIMARY KEY,
    recordID INT NOT NULL,
    treatmentType VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (recordID) REFERENCES MedicalRecords(recordID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

---Medication table--
CREATE TABLE Medication(
    medicationID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    dosageForm varchar(50) NOT NULL,
    description VARCHAR(255),
    stockQuantity INT NOT NULL,
    pricePerUnit INT NOT NULL
);

----Treatment_Medication table(Clinic administers treatment)
CREATE TABLE Treatment_Medication (
    TreatmentID INT NOT NULL,
    MedicationID INT NOT NULL,
    Dosage VARCHAR(50),
    Frequency VARCHAR(50),
    Duration VARCHAR(50),
    Notes VARCHAR(255),
    PRIMARY KEY (TreatmentID, MedicationID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MedicationID) REFERENCES Medication(MedicationID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


---Prescription table (Owner administers meds to pet with doctor's instructions)--
Create TABLE Prescription(
    prescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    recordID INT NOT NULL,
    medicationID INT NOT NULL,
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    notes VARCHAR(255),
    FOREIGN KEY (recordID) REFERENCES MedicalRecords(recordID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medicationID) REFERENCES Medication(medicationID)
    ON DELETE RESTRICT ON UPDATE CASCADE

);

---Billing Table--
CREATE TABLE Billing(
    billingID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    OwnerID INT NOT NULL,
    totalAmount DECIMAL(10,2)NOT null,
    paymentMethod VARCHAR(50) NOT NULL,
    paymentStatus VARCHAR(50) DEFAULT 'Unpaid',
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

---Vaccination Table--
CREATE TABLE Vaccination(
    vaccinationID int AUTO_INCREMENT PRIMARY KEY,
    PetID INT not NULL,
    recordID INT NOT NULL,
    vaccineName varchar(50) NOT NULL,
    dateAdministered DATETIME DEFAULT CURRENT_TIMESTAMP,
    StaffID int,
    FOREIGN KEY (PetID) REFERENCES Pet(PetID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (recordID) REFERENCES MedicalRecords(recordID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
    ON DELETE SET NULL ON UPDATE CASCADE

);

---Insurance Table--
CREATE TABLE insurance(
    insuranceID INT AUTO_INCREMENT PRIMARY KEY,
    OwnerID int NOT NULL,
    provider VARCHAR(50),
    policyNumber VARCHAR(50) NOT NULL,
    coverageDetails VARCHAR(255),
    validFrom DATE NOT NULL,
    validUntil DATE NOT NULL,
    FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexes for performance(Reference : Github copilot)--
CREATE INDEX idx_pet_owner ON Pet(OwnerID);
CREATE INDEX idx_appointment_pet ON Appointment(PetID);
CREATE INDEX idx_prescription_record ON Prescription(RecordID);
