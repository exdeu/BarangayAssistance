using System;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Threading;

namespace WebLauncher
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // =========================
            // DATABASE + TABLE CHECK
            // =========================

            string masterConnection =
                @"Server=(localdb)\MSSQLLocalDB;Integrated Security=true;";

            using (SqlConnection conn =
                new SqlConnection(masterConnection))
            {
                conn.Open();

                string createDbQuery = @"
IF DB_ID('BarangayDB') IS NULL
BEGIN
    CREATE DATABASE BarangayDB;
END";

                using (SqlCommand cmd =
                    new SqlCommand(createDbQuery, conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }

            string dbConnection =
                @"Server=(localdb)\MSSQLLocalDB;Database=BarangayDB;Integrated Security=true;";

            using (SqlConnection conn =
                new SqlConnection(dbConnection))
            {
                conn.Open();

                string tablesQuery = @"

IF OBJECT_ID('beneficiaries', 'U') IS NULL
BEGIN
CREATE TABLE beneficiaries (
    beneficiary_id INT IDENTITY(1,1) PRIMARY KEY,

    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,

    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NULL,

    date_of_birth DATE NOT NULL,
    age INT NULL,
    sex VARCHAR(10) NOT NULL,

    contact_number VARCHAR(20) NOT NULL,
    civil_status VARCHAR(30) NOT NULL,

    purok_street VARCHAR(150) NOT NULL,
    household_members INT NOT NULL,
    monthly_income DECIMAL(12,2) NULL,

    beneficiary_type VARCHAR(50) NOT NULL,
    government_id_presented VARCHAR(50) NULL,

    profile_picture VARCHAR(255) NULL,

    date_registered DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(30) NOT NULL DEFAULT 'Active',
    email VARCHAR(150) NOT NULL DEFAULT ''
);
END


IF OBJECT_ID('assistance_applications', 'U') IS NULL
BEGIN
CREATE TABLE assistance_applications (
    application_id INT IDENTITY(1,1) PRIMARY KEY,
    beneficiary_id INT NOT NULL,

    full_name VARCHAR(150) NOT NULL,
    beneficiary_type VARCHAR(50) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,

    assistance_type VARCHAR(50) NOT NULL,
    preferred_date DATE NOT NULL,
    estimated_amount_requested DECIMAL(12,2) NULL,
    urgency_level VARCHAR(30) NOT NULL,

    reason_for_application TEXT NOT NULL,
    additional_notes TEXT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    date_submitted DATETIME NOT NULL DEFAULT GETDATE(),
    date_updated DATETIME NULL,

    CONSTRAINT FK_assistance_beneficiary
        FOREIGN KEY (beneficiary_id)
        REFERENCES beneficiaries(beneficiary_id)
);
END


IF OBJECT_ID('admins', 'U') IS NULL
BEGIN
CREATE TABLE admins (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'Admin',
    date_created DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

INSERT INTO admins (username, password_hash, full_name, role, status)
VALUES 
('admin1', 'admin123', 'System Administrator', 'Admin', 'Active'),
('superadmin', 'super123', 'Super Admin User', 'Admin', 'Active'),
('staff1', 'staff123', 'Barangay Staff', 'Admin', 'Active');
END


IF OBJECT_ID('notifications', 'U') IS NULL
BEGIN
CREATE TABLE notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,

    beneficiary_id INT NULL,
    
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,

    type VARCHAR(50) NOT NULL,

    is_read BIT DEFAULT 0,

    date_created DATETIME DEFAULT GETDATE(),
    date_read DATETIME NULL,

    CONSTRAINT FK_notifications_beneficiary
        FOREIGN KEY (beneficiary_id)
        REFERENCES beneficiaries(beneficiary_id)
);
END


IF OBJECT_ID('complaints_feedback', 'U') IS NULL
BEGIN
CREATE TABLE complaints_feedback (
    complaint_id INT IDENTITY(1,1) PRIMARY KEY,
    type NVARCHAR(20),
    category NVARCHAR(50),
    subject NVARCHAR(200),
    details NVARCHAR(1000),
    rating INT DEFAULT 0,
    status NVARCHAR(20) DEFAULT 'Pending',
    admin_response NVARCHAR(500) NULL,
    date_submitted DATETIME DEFAULT GETDATE(),
    date_resolved DATETIME NULL,
    admin_reply TEXT NULL
);
END
";

                using (SqlCommand cmd =
                    new SqlCommand(tablesQuery, conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }

            Console.WriteLine("Database and tables checked.");

            // =========================
            // IIS LAUNCHER
            // =========================

            string baseDir = AppDomain.CurrentDomain.BaseDirectory;

            // Since your ASPX files are directly beside the launcher EXE
            string sitePath = Path.Combine(baseDir, "BarangayAssistance");

            string iisExpressPath = @"C:\Program Files\IIS Express\iisexpress.exe";
            string port = "8080";
            string url = $"http://localhost:{port}/index.aspx";

            if (!File.Exists(iisExpressPath))
            {
                Console.WriteLine("IIS Express not found.");
                Console.ReadKey();
                return;
            }

            if (!File.Exists(Path.Combine(sitePath, "Web.config")))
            {
                Console.WriteLine("Web.config not found in:");
                Console.WriteLine(sitePath);
                Console.ReadKey();
                return;
            }

            Process.Start(new ProcessStartInfo
            {
                FileName = iisExpressPath,
                Arguments = $"/path:\"{sitePath}\" /port:{port}",
                UseShellExecute = false
            });

            Thread.Sleep(3000);

            Process.Start(new ProcessStartInfo
            {
                FileName = url,
                UseShellExecute = true
            });

            Console.WriteLine("Barangay Assistance launched.");
            Console.WriteLine(url);

            Console.ReadKey();
        }
    }
}