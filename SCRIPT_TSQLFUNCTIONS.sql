
--Obtener el nombre del jefe de un departamento(parámetro department_id). 

IF OBJECT_ID('DBO.GET_MGRNAME') IS NOT NULL
	DROP FUNCTION DBO.GETMGR;
GO

CREATE FUNCTION GET_MGRNAME(@DID DECIMAL) RETURNS VARCHAR(100) 

AS BEGIN
	
	DECLARE @NAME VARCHAR(100) = NULL;
	
	SELECT @NAME = FIRST_NAME + ' ' + LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = (SELECT MANAGER_ID FROM DEPARTMENTS WHERE DEPARTMENT_ID = @DID);

	RETURN @NAME;
END;

GO 

BEGIN
	SELECT DBO.GET_MGRNAME(DEPARTMENT_ID) FROM DEPARTMENTS;
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Obtener el nombre del jefe de un empleado(parámetro employee_id).
IF OBJECT_ID('GET_EMP_MGRNAME') IS NOT NULL
	 DROP FUNCTION GET_EMP_MGRNAME;
GO

CREATE FUNCTION GET_EMP_MGRNAME(@EID DECIMAL) RETURNS VARCHAR(50) AS

BEGIN
	DECLARE @NAME VARCHAR(50) = NULL;

	SELECT @NAME = FIRST_NAME + ' ' + LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = (SELECT MANAGER_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = @EID);

	RETURN @NAME;

END;

GO
BEGIN

	SELECT EMPLOYEE_ID , DBO.GET_EMP_MGRNAME(EMPLOYEE_ID) "MANAGER NAME" FROM EMPLOYEES WHERE MANAGER_ID IS NOT NULL;
END;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Calcular la antigüedad en años de un empleado en la cía. (parámetro employee_id)

IF OBJECT_ID('GET_YEARS_EMP') IS NOT NULL
	DROP FUNCTION GET_YEARS_EMP;
GO

CREATE FUNCTION GET_YEARS_EMP(@EID DECIMAL) RETURNS DECIMAL AS
BEGIN
	DECLARE @VAL DECIMAL = NULL;
		SELECT @VAL = ABS(FLOOR(DATEDIFF(DAY, HIRE_DATE, CONVERT(DATE,GETDATE()))/365.2)) FROM EMPLOYEES WHERE EMPLOYEE_ID = @EID;
	RETURN @VAL;
END;
GO

BEGIN

SELECT HIRE_DATE, DBO.GET_YEARS_EMP(EMPLOYEE_ID) AS ANTIGUEDAD FROM EMPLOYEES;

END;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Determinar si un empleado tiene comisión(parámetro employee_id) –boolean.

IF OBJECT_ID('DBO.HASCOMM_EMP') IS NOT NULL
	DROP FUNCTION DBO.HASCOMM_EMP;
GO
CREATE FUNCTION HASCOMM_EMP(@EID DECIMAL) RETURNS BIT AS
BEGIN
	DECLARE @FLAG BIT = 0;
	DECLARE @TMP DECIMAL(2,2);

		SELECT @TMP =  COMMISSION_PCT FROM EMPLOYEES WHERE EMPLOYEE_ID = @EID;

		IF(@TMP <> 0) 
			SET @FLAG = 1;

	RETURN @FLAG;

END;
GO
BEGIN

	SELECT EMPLOYEE_ID "ID EMPLEADO", CASE DBO.HASCOMM_EMP(EMPLOYEE_ID) WHEN 0 THEN 'SIN COMISION' ELSE 'CON COMISION' END AS COMISION  FROM EMPLOYEES;
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Determinar si un departamento tiene empleados –boolean.
IF OBJECT_ID('HASEMPLOYEES_DEP') IS NOT NULL
	DROP FUNCTION HASEMPLOYEES_DEP;
	GO
	CREATE FUNCTION HASEMPLOYEES_DEP(@DID DECIMAL) RETURNS BIT AS

	BEGIN
		DECLARE @FLAG BIT = 0;
		DECLARE @TMP DECIMAL = 0;
		
		SELECT @TMP = COUNT(*) FROM EMPLOYEES WHERE DEPARTMENT_ID = @DID;

		IF(@TMP > 0)
			SET @FLAG = 1;

		RETURN @FLAG;

	END;

GO
BEGIN
	SELECT DEPARTMENT_NAME , CASE DBO.HASEMPLOYEES_DEP(DEPARTMENT_ID)  WHEN 1 THEN 'Tiene empleados' ELSE 'No tiene empelados' END FROM DEPARTMENTS;
END;


