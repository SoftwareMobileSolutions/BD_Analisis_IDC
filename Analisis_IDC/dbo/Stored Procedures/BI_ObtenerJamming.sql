/*
===========================================================================
Armando Villavicencio
2022 - 05 - 03 
Obtencion de reportes para Power BI
===========================================================================
*/
CREATE PROCEDURE [dbo].[BI_ObtenerJamming]
AS 
BEGIN
	DECLARE @RunStoredProcSQL VARCHAR(max);
				SET @RunStoredProcSQL ='	SELECT s.name AS subflota,M.plate,M.name alais,D.name AS avl,s1.name statusid,sl.longitude,sl.latitude,sl.location,
				DATEADD(HOUR,-6,sl.dategps)dategps,DATEADD(HOUR,-6,sl.dateserver)dateserver,DATEDIFF(MINUTE,sl.dategps,sl.dateserver) date_diff
				FROM status_log sl 
				INNER JOIN mobile m ON sl.mobileid = m.mobileid
				INNER JOIN mobile_subfleet msa ON m.mobileid = msa.mobileid
				INNER JOIN subfleet s ON msa.subfleetid = s.subfleetid
				INNER JOIN status s1 ON sl.statusid = s1.statusid
				INNER JOIN device d ON m.deviceid = d.deviceid
				WHERE sl.mobileid IN (SELECT DISTINCT mobileid FROM status_log sl 
				WHERE sl.statusid IN (21,23) AND sl.dategps > DATEADD(DAY,-30,getdate()))
				--and sl.dategps > DATEADD(DAY,-10,getdate()) /*and s.companyid=458 */
				AND sl.mobileid = 17955 
				AND sl.dategps BETWEEN ''20220630 17:00:00'' AND ''20220630 18:50:00''
				union

				SELECT ''Buffer'' AS subflota,''Buffer'',''Buffer'' alais,D.name AS avl,s1.name statusid,sl.longitude,sl.latitude,sl.location,
			DATEADD(HOUR,-6,sl.dategps)dategps,DATEADD(HOUR,-6,sl.dateserver)dateserver,DATEDIFF(MINUTE,sl.dategps,sl.dateserver) date_diff
				FROM status_log sl 
				INNER JOIN mobile m ON sl.mobileid = m.mobileid
				INNER JOIN mobile_subfleet msa ON m.mobileid = msa.mobileid
				INNER JOIN subfleet s ON msa.subfleetid = s.subfleetid
				INNER JOIN status s1 ON sl.statusid = s1.statusid
				INNER JOIN device d ON m.deviceid = d.deviceid
				WHERE sl.mobileid IN (SELECT DISTINCT mobileid FROM status_log sl 
				WHERE sl.statusid IN (21,23) AND sl.dategps > DATEADD(DAY,-30,getdate()))
				--and sl.dategps > DATEADD(DAY,-10,getdate()) /*and s.companyid=458 */
				AND sl.mobileid = 17955  AND DATEDIFF(MINUTE,sl.dategps,sl.dateserver)  >1
				AND sl.dategps BETWEEN ''20220630 17:00:00'' AND ''20220630 18:50:00'''
		EXEC (@RunStoredProcSQL) AT [10.0.0.5];

/*
		DECLARE @RunStoredProcSQL VARCHAR(max);
				SET @RunStoredProcSQL ='SELECT mobile.plate,sl.* FROM status_log sl 
	INNER JOIN mobile ON sl.mobileid = mobile.mobileid
	WHERE sl.mobileid IN (SELECT DISTINCT mobileid FROM status_log sl 
	WHERE sl.statusid IN (21) AND sl.dategps > DATEADD(DAY,-30,getdate()))
	and sl.dategps > DATEADD(DAY,-7,getdate())
	ORDER BY sl.dategps DESC '
		EXEC (@RunStoredProcSQL) AT [10.0.0.5];*/
END

-- ingenios , 