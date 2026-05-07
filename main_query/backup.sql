BACKUP DATABASE BarangayDB
TO DISK = 'C:\Backup\BarangayDB.bak'
WITH 
    FORMAT,
    INIT,
    STATS = 10,
    NAME = 'BarangayDB Full Backup';