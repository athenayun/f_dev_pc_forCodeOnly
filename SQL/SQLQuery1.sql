USE master
GO
xp_readerrorlog 0, 1, N'Server is listening on' 
GO

SELECT DISTINCT 
    local_tcp_port 
FROM sys.dm_exec_connections 
WHERE local_tcp_port IS NOT NULL 

select @@SERVERNAME