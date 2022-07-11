/*
===========================================================================
Armando Villavicencio
2022 - 05 - 03 
Obtencion de reportes para Power BI
===========================================================================
*/
CREATE PROCEDURE [dbo].[BI_ObtenerJammingMartinez]
AS 
BEGIN
	DECLARE @RunStoredProcSQL VARCHAR(max);
				SET @RunStoredProcSQL ='SELECT s.name AS subflota,M.plate,M.name alais,D.name AS avl,s1.name statusid,sl.longitude,sl.latitude,sl.location,DATEADD(HOUR,-6,sl.dategps)dategps,DATEADD(HOUR,-6,sl.dateserver)dateserver,DATEDIFF(MINUTE,sl.dategps,sl.dateserver) date_diff
				FROM status_log sl 
				INNER JOIN mobile m ON sl.mobileid = m.mobileid
				INNER JOIN mobile_subfleet msa ON m.mobileid = msa.mobileid
				INNER JOIN subfleet s ON msa.subfleetid = s.subfleetid
				INNER JOIN status s1 ON sl.statusid = s1.statusid
				INNER JOIN device d ON m.deviceid = d.deviceid
				WHERE sl.mobileid IN (0,5733,5919,6750,9487,5795,6720,6719,6721,9538,5741,7096,11142,9237,1858,5712,5739,5771,6375,5773,9537,5723,6718,5742,10822)
				and sl.dategps > DATEADD(DAY,-20,getdate()) --and s.companyid=458 --AND sl.mobileid = 5771 
				ORDER BY sl.dategps DESC'
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